# Plano de Teste — Cookiebot: Migração v1 → v2

| Campo | Valor |
|---|---|
| Projeto | Cookiebot Telegram Group Bot |
| Documento | Plano de Teste (uso único — ciclo de migração v1 → v2) |
| Versão do documento | 1.0 |
| Data | 2026-08-24 |
| Autor | github.com/bagriel01 (elaborado com apoio de Claude) |
| Fontes analisadas | `cookiebot-team.github.io/cookiebot-telegram-bot/docs` (Architecture, Cutover, Deploy), repositório `Cookiebot-QA`, repositório `COOKIEBOT-Telegram-Group-Bot` |
| Baseline v2 medida | commit `eadc339` (2026-08-15) — 369 cenários verdes, 0 falhando, suíte offline: 3343 passed / 44 skipped / 217 deselected em 36.16s |

> **Nota de escopo:** este plano cobre o ciclo de release "v1 → v2", que envolve simultaneamente (a) reescrita de stack (Java/Mongo/VM → Python async/Postgres-Citus/Kubernetes), (b) migração de dados (Cutover) e (c) **migração de plataforma de hospedagem** (VMs supervisionadas por `LAUNCHER.py` → cluster Kubernetes self-hosted). O item (c) é tratado como teste de primeira classe, conforme solicitado, e não como um "smoke test" genérico de deploy.

---

## 1. Introdução e Objetivo

O Cookiebot está sendo reescrito do zero (v2) sob a premissa de que **"uma feature só migra quando seu comportamento vira um cenário executável e esse cenário passa"**. Isso já garante cobertura funcional cenário-a-cenário (Gherkin + mock da API do Telegram). Este plano de teste **não duplica** essa suíte funcional — ele endereça as três lacunas que a suíte de cenários, por definição, não cobre:

1. A **migração de dados** do v1 (MongoDB, VMs) para o v2 (Postgres/Citus, object storage) via `cb.py cutover`.
2. A **migração de plataforma de execução**: sair de 5 processos Python supervisionados por `LAUNCHER.py` em máquinas virtuais para pods estateless orquestrados por Kubernetes/Helm, incluindo webhook privado, self-hosted Bot API e escalonamento horizontal.
3. **Carga e performance** sob o novo modelo de filas (gateway/worker separados via Redis/arq), algo que o v1 nunca teve como medir (sem cache, sem métricas de fila, thread pool único de 50 threads).

### Objetivos específicos
- Certificar que a virada de chave (cutover) de dados é segura, idempotente e reversível.
- Certificar que a virada de **infraestrutura** (VM → Kubernetes) não introduz regressão operacional (disponibilidade do webhook, perda de mensagens, duplicação de updates, tempo de resposta) mesmo sendo uma migração "sem beco de dados" — a mudança está no *onde* e *como* o bot roda, não apenas no *o que* ele guarda.
- Estabelecer uma linha de base de performance para o novo pipeline gateway → worker → api, validando a premissa arquitetural central do projeto: "o p99 do caminho de resposta rápida deve ser independente da fila de vídeo/ffmpeg".

---

## 2. Escopo

### 2.1 Dentro do escopo
- Teste de migração de dados (Cutover): os 7 passos, idempotência, dry-run, verificação de integridade.
- Teste de migração de infraestrutura VM → Kubernetes (paridade operacional, cutover de webhook, rollback, resiliência do cluster).
- Teste de carga/performance do novo pipeline assíncrono (gateway, worker, api, Citus, Redis/Valkey).
- Teste de regressão dirigido pelo mapa de defeitos do v1 (D1–D13) — cada defeito conhecido do v1 vira caso negativo no v2.
- Validação de observabilidade (traces/metrics/logs) como critério de saída, já que v1 não tinha nenhuma.
- Testes de segurança de superfície mínima ligados à migração (webhook secret, endpoints `/healthz`/`/readyz` autenticados, egress default-deny do namespace).

### 2.2 Fora do escopo
- Re-execução exaustiva dos 369 cenários funcionais Gherkin já verdes (são pré-requisito de entrada, não objeto deste plano).
- WebHub / BFF do M4 (repositório `COOKIEBOT-WebHub` está fora do workspace, conforme decisão em aberto #3 da Arquitetura).
- Precisão dos provedores externos não oficiais (Shazam/SauceNao) além do circuit breaker já especificado.
- Migração do domínio `Raffle` (descartado, sem repo/service/controller hoje).

---

## 3. Estratégia de Teste

Pirâmide de teste alinhada à que o próprio projeto já usa (unitário → integração/Citus → E2E com mock Telegram), acrescida de duas camadas que o projeto ainda não tem formalizado: **teste de migração de plataforma** e **teste de carga**.

```
        ┌───────────────────────────┐
        │  Cutover Rehearsal (UAT)  │  ← novo, este plano
        ├───────────────────────────┤
        │  Infra Migration (K8s)    │  ← novo, este plano
        ├───────────────────────────┤
        │  Performance / Carga      │  ← novo, este plano
        ├───────────────────────────┤
        │  E2E (gateway+sandbox)    │  ← já existe (docs/e2e)
        ├───────────────────────────┤
        │  Integração (Citus topo.) │  ← já existe (qa/integration)
        ├───────────────────────────┤
        │  Unitário / Gherkin (369) │  ← já existe, é gate de entrada
        └───────────────────────────┘
```

### Critérios de entrada
- Suíte funcional v2 verde no commit-alvo (0 cenários falhando).
- `helm lint` e `helm template ... | kubectl apply --dry-run=client` limpos.
- Ambiente UAT provisionado com CloudNativePG/Citus, Valkey e Bot API self-hosted (`telegramBotApi.enabled=true`, `--local`).
- Backup/snapshot do MongoDB e das VMs v1 tirado antes de qualquer ensaio de cutover.

### Critérios de saída
- Todos os casos de prioridade Crítica/Alta deste plano com status Passou.
- Nenhum achado da categoria "D-novo" (defeito equivalente a um dos D1–D13 do v1) reaberto no v2.
- Relatório de carga com p99 do caminho rápido dentro do orçamento definido em §6.4, mesmo com fila de vídeo saturada.
- Rollback de infraestrutura (K8s → v1 VM) executado com sucesso em ensaio, com RTO medido.

---

## 4. Ambiente e Dados de Teste

| Ambiente | Onde roda | Propósito |
|---|---|---|
| Dev/local | docker-compose (Citus coordinator + 2 workers, Valkey, otel-collector, Prometheus, Grafana, Tempo) | desenvolvimento e suíte offline |
| CI | GitHub Actions, mock Telegram (aiohttp local) | suíte de 369 cenários + `qa/integration` |
| UAT | Kubernetes real (namespace dedicado, egress default-deny com carve-outs), Helm chart `deploy/helm/cookiebot`, MinIO como object storage | ensaio de Cutover, ensaio de migração de infraestrutura e carga |
| v1 (referência) | VMs atuais, 5 processos supervisionados por `LAUNCHER.py`, MongoDB, GCS | fonte de dados/comportamento para comparação de paridade |

**Dados de teste:** dump/`mongodump` de um subconjunto representativo de grupos do v1 (não a base de produção inteira), incluindo pelo menos: um grupo com `randomdatabase` grande (para exercitar o passo `random`), um grupo com meme templates customizados, e um grupo multi-idioma (PT/EN/ES) para não quebrar paridade de comandos.

---

## 5. Seção Especial — Teste de Migração v1 → v2 (VM → Kubernetes)

Aqui está o núcleo do pedido: a migração **não é** "importar tabela X para tabela Y" — isso já é resolvido pelo `cutover`. A migração que precisa de teste dedicado é a **troca do runtime**: de 5 processos long-polling em VMs, supervisionados por um script que mata processos acima de 70% de CPU/RAM, para pods stateless por trás de webhook, escalonados horizontalmente pelo Kubernetes.

### 5.1 O que muda (base para os casos de teste)

| Dimensão | v1 (VM) | v2 (Kubernetes) | Risco a testar |
|---|---|---|---|
| Modelo de execução | 5 processos OS, 1 por persona de bot, `ThreadPoolExecutor(50)` | N réplicas stateless de `cb-gateway`, personas roteadas por tabela `bots` no mesmo processo | uma persona pode "sumir" se o roteamento multi-bot falhar |
| Supervisão/self-healing | `LAUNCHER.py` faz polling de CPU/RAM e `kill -9` | liveness/readiness probes do Kubernetes (`/healthz`, `/readyz`) | probes mal calibradas podem reiniciar pods saudáveis sob carga (falso positivo) ou não matar pods travados (falso negativo) |
| Recepção de update | long-polling em `api.telegram.org` | webhook privado: Telegram DC → `telegram-bot-api --local` (self-hosted) → `cb-gateway` via ClusterIP, sem ingress público | corte de rede externo→interno pode não afetar o bot (webhook é interno), mas a troca do bot de polling para webhook pode gerar updates duplicados ou perdidos na virada |
| Autenticação de origem do update | nenhuma (implícita pelo polling) | `CB_WEBHOOK_SECRET` verificado em todo update | secret ausente/errado bloqueia 100% do tráfego silenciosamente |
| Escala | fixa, 5 processos por VM, escala vertical | HPA (horizontal), gateway escala por réplica | autoscaling pode não disparar a tempo em pico (raid de spam) |
| Deploy/rollback | manual, restart de VM (`restart_vm.py`) | Helm/Argo GitOps, rollout com `migrations` como gate | rollback de um `helm upgrade` ruim precisa ser tão rápido quanto reiniciar uma VM, ou mais |
| Credenciais do bot | token direto em `api.telegram.org` | bot **deslogado** de `api.telegram.org`, obrigatório para servidor local aceitar `logOut` | se o processo de logout falhar, Telegram para de entregar ao servidor local sem aviso claro |
| Migração de schema concorrente | não existia | `migrations.enabled=true` roda como Job/init container para impedir N réplicas correndo a mesma DDL | condição de corrida se o gate for desabilitado por engano |

### 5.2 Casos de teste — Migração de Infraestrutura (VM → K8s)

| ID | Caso | Tipo | Prioridade | Critério de aceite |
|---|---|---|---|---|
| INFRA-01 | **Paridade de comandos pós-corte**: com o tráfego já roteado ao cluster, executar os ~40 comandos do bot (via conta de teste) e comparar respostas com a baseline v1 | Funcional/Paridade | Crítica | 100% das respostas equivalentes ao contrato do cenário Gherkin correspondente |
| INFRA-02 | **Ensaio de corte de webhook**: registrar `setWebhook` apontando para o `cb-gateway`, confirmar que o bot está deslogado de `api.telegram.org` antes, e medir a janela sem receber updates | Migração/Disponibilidade | Crítica | janela de indisponibilidade documentada e ≤ ao SLA acordado (sugestão: <30s) |
| INFRA-03 | **Update duplicado/perdido na virada**: enviar rajada de mensagens de teste no exato instante do corte v1→v2 | Migração/Integridade | Alta | 0 duplicações processadas (dedupe por `update_id`/blake3 cobre isso) e 0 perdas |
| INFRA-04 | **Multi-bot routing**: com N tokens configurados em `CB_BOT_TOKENS`, confirmar que cada persona responde com o skin/config correto vindo da tabela `bots` | Funcional | Alta | cada persona responde com seu próprio welcome/skin, sem cross-talk |
| INFRA-05 | **Falha de probe / self-healing**: matar (`kubectl delete pod`) um pod de `cb-gateway` sob tráfego ativo | Resiliência | Crítica | outra réplica assume, sem update perdido; tempo de recuperação medido |
| INFRA-06 | **Drenagem de nó (`kubectl drain`)** simulando manutenção de cluster | Resiliência | Alta | pods reagendados, sem downtime de webhook (múltiplas réplicas, PodDisruptionBudget) |
| INFRA-07 | **Gate de migração de schema**: subir 2ª réplica de `cb-api` simultaneamente à 1ª rodando `alembic upgrade head` | Migração/Concorrência | Crítica | apenas uma migração roda por vez; segunda réplica aguarda ou falha graciosamente, nunca corrompe o schema |
| INFRA-08 | **Webhook secret inválido**: enviar update com `secret_token` incorreto | Segurança | Alta | update rejeitado (não processado), sem vazar detalhe de erro |
| INFRA-09 | **Egress default-deny**: confirmar que o namespace só alcança Telegram DCs, `*.googleapis.com`, R2 e os hosts de LLM — nenhuma rota residual para VMs do v1 | Segurança/Rede | Média | `NetworkPolicy` testada com tentativa de conexão para destino não listado (deve falhar) |
| INFRA-10 | **Rollback de infraestrutura**: forçar `helm rollback` para a revisão anterior após um `helm upgrade` defeituoso | Migração/Recuperação | Crítica | serviço volta ao estado anterior; RTO medido e documentado |
| INFRA-11 | **Coexistência temporária v1 (VM) + v2 (K8s)**: durante a janela de dual-write (`cb-api` escrevendo enquanto Java v1 ainda serve), validar que nenhuma escrita é perdida em nenhum dos dois lados | Migração/Integridade | Crítica | reconciliação pós-janela mostra 0 divergência de contagem de linhas |
| INFRA-12 | **Tamanho e composição de imagem em produção real** (não apenas medição estática) | Migração/Build | Baixa | `cb-api` ~338MB, `cb-gateway` ~344MB, `cb-worker` ~493MB — sem pacotes indevidos (`ffmpeg` ausente em gateway/api, `duckdb`/`tg_sandbox` ausentes em `cb-api`) |
| INFRA-13 | **Bot API local aceita apenas HTTP interno**: confirmar que não existe ingress público nem túnel, e que a única rota é `telegram-bot-api --local → cb-gateway` | Segurança | Alta | scan de superfície externa não encontra endpoint do gateway exposto |

### 5.3 Abordagem — "Game Day" de Cutover

Recomenda-se rodar um **ensaio cronometrado** (game day), replicando o dia real de corte, contra o ambiente UAT com dados de um subconjunto de grupos reais:

1. `cb.py cutover --dry-run` — validar mapeamento sem escrever.
2. `cb.py cutover --only mongo,verify --yes` como Kubernetes Job — validar step de dados dentro do cluster (conforme documentado, evitando expor credencial de DB fora do cluster).
3. Corte de webhook (INFRA-02/03).
4. Execução de INFRA-01 (paridade) com checklist reduzido dos comandos mais usados.
5. Ensaio de rollback completo (INFRA-10) — o "e se der errado" tem que ser tão testado quanto o "e se der certo".
6. Repetir o cutover de dados uma segunda vez sobre o mesmo ambiente para provar idempotência (o próprio design do `cutover` promete isso — o teste deve provar, não assumir).

---

## 6. Teste de Carga e Performance

O v1 não tem nenhuma visibilidade de performance (sem cache, sem métricas de fila, sem tracing). O v2 introduz observabilidade "on by default" — isso deve ser usado como instrumento de medição do próprio teste de carga, não só como feature a validar isoladamente.

### 6.1 Premissa arquitetural a validar
> "Separar ingestão de processamento faz o p99 do caminho de resposta (<50ms) independente do ffmpeg." — Architecture, §1

Esse é o alvo central do teste de carga: provar (ou refutar) que um job pesado (`/destroy`, vídeo) na fila do `cb-worker` **não** degrada a resposta de um comando leve (`/rules`, captcha) no `cb-gateway`.

### 6.2 Ferramenta sugerida

- **Grafana + Prometheus + Tempo** (já provisionados via Helm/`docker-compose`) como painel de leitura dos resultados — usar as métricas que o próprio time já definiu (`cb_handler_duration_seconds`, `cb_queue_depth`, `cb_worker_saturation`, `cb_db_pool_in_use`) em vez de reinstrumentar.
`EXPLAIN`/`pg_stat_statements` no Citus para validar que as queries do caminho quente continuam `Task Count: 1` sob carga (a mesma asserção que os testes de topologia já fazem, mas sob volume).

### 6.3 Cenários de carga

| Cenário | Descrição | Métrica-chave |
|---|---|---|
| **Carga de linha de base (smoke de carga)** | tráfego constante e baixo (ex.: 10 updates/s) simulando operação normal dos ~1275 grupos v1 | p50/p95/p99 de `cb_handler_duration_seconds` por handler |
| **Isolamento fast-path vs slow-path** | disparar em paralelo: rajada de comandos leves + fila cheia de jobs de vídeo/ffmpeg no worker | p99 do fast-path deve permanecer estável mesmo com `cb_worker_saturation` alto |
| **Pico/raid simulado** | rajada de entradas de novos membros (captcha) em um único grupo, simulando um raid/ataque coordenado | taxa de captcha resolvido vs. `cb_telegram_rate_limited_total`; HPA deve escalar o gateway |
| **Teste de estresse no gateway** | aumentar updates/s até saturação para achar o ponto de ruptura | throughput máximo sustentável antes de erro/timeout |
| **Teste de longa duração (soak)** | carga moderada sustentada por várias horas | vazamento de memória/conexão, crescimento de `cb_db_pool_in_use`, acúmulo de `cb_queue_depth` |
| **Teste de fila (arq/Redis)** | saturar `cb-worker` com jobs de mídia e medir tempo até drenagem | `cb_job_duration_seconds{job}` e profundidade máxima de fila sem perda de job |
| **Teste de analytics/Citus** | volume alto de `message_events` gravado, então disparar rollups via `pg_cron` | tempo de rollup não deve competir com queries do caminho quente (`Task Count: 1` mantido) |


### 6.4 Orçamento de performance (SLO sugerido para este ciclo)
- Caminho rápido (handler síncrono, sem mídia): **p99 < 50ms**, independentemente do estado da fila do worker.
- Erros 5xx sob carga de linha de base: **0%**.
- HPA do `cb-gateway` deve escalar dentro de **60s** após ultrapassar o limiar de CPU/latência configurado.
- Nenhum job de fila perdido (0 jobs órfãos) mesmo no cenário de estresse — falha esperada é *lentidão*, não *perda*.

---

## 7. Testes Funcionais Dirigidos por Defeito (regressão v1 → v2)

A Arquitetura já lista os defeitos conhecidos do v1 (D1–D13, ex.: D7 chave JWT não persistida, D10 scan de `birthdate` não indexável, D11 falta de paginação, D12 health endpoints sem autenticação). Cada um deve virar um caso de teste negativo explícito no v2, não apenas ser assumido como corrigido pela reescrita:

| Defeito v1 | Caso de teste v2 |
|---|---|
| D7 — chave JWT gerada por worker, não persistida | Reiniciar múltiplas réplicas de `cb-api` e confirmar que todas compartilham a mesma chave de assinatura (`signing_keys`, migração 0008) |
| D10 — scan completo em `birthdate` | Consultar aniversariantes do dia com `EXPLAIN` e confirmar uso do índice composto em `birth_month`/`birth_day` |
| D11 — sem paginação | Testar endpoints de listagem com dataset grande e confirmar paginação por keyset, não offset |
| D12 — `/health`/`/prometheus` sem autenticação | Confirmar que `/healthz`/`/readyz` exigem autenticação ou estão restritos por rede |
| D-WL-2 — apenas 1º de 5 tokens conseguia autenticar no WebHub | Testar login via cada uma das personas/tokens configurados |

---

## 8. Papéis e Responsabilidades

| Papel | Responsabilidade |
|---|---|
| SDET/QA | autoria e execução deste plano, automação dos cenários de infraestrutura, veredito de entrada/saída |
| Backend Devs | apoio na instrumentação de métricas específicas do teste de carga, correção de achados |
| PO | decisão de aceite de risco residual e autorização do corte definitivo de produção |
| Operação/Infra (cluster) | provisionamento do ambiente UAT, execução do `helm upgrade`/`rollback`, acesso ao cluster para os ensaios de resiliência |

## 9. Riscos e Mitigações

| Risco | Impacto | Mitigação |
|---|---|---|
| Ensaio de cutover em UAT não reflete volume real de produção | achados de performance otimistas | usar subconjunto de grupos "pesados" (muitos membros/mídia) como amostra, não grupos aleatórios |
| `random` step do cutover nunca "completa" (pointers antigos falham por natureza) | falso positivo de falha no relatório de cutover | tratar taxa de falha de `random` como métrica informativa, não como critério de bloqueio (conforme já documentado pelo próprio time) |
| Credencial de bucket v1 (GCS) indisponível durante o ensaio | 4 features (`fun_death`, `fun_partneredcons`, `x_custom_commands`, `fun_battle`) ficam bloqueadas | validar com antecedência a credencial read-only antes de agendar o game day |
| Teste de carga sintético não reproduz padrão real do Telegram (ex.: rajadas correlacionadas por fuso horário) | subestimar pico real | calibrar cenário de "raid simulado" com dados históricos de pico do v1, se disponíveis via `message_events`/logs antigos |
| Rollback de infraestrutura nunca ensaiado antes do corte real | corte sem plano B testado | INFRA-10 é bloqueante para autorização de corte de produção |

---

## 10. Entregáveis deste ciclo de teste
- Este documento (Plano de Teste) -> SDET/QA 
- Relatório de execução do Game Day de Cutover (dados + infraestrutura). -> Equipe
- Dashboard/relatório de carga (k6/Locust + Grafana) com os SLOs de §6.4 comparados ao medido. -> DevOPS
- Lista de achados classificados por severidade, no formato já padronizado pelo repositório `Cookiebot-QA` (`[Módulo][QA Bug] Problema - Ação - Local - Severidade`), aberta nos GitHub Issues do repositório correspondente à versão afetada. -> SDET/QA
