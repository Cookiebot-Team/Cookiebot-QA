# Ferramenta de Publicação e Divulgação do Cookiebot

## Sobre a Ferramenta

> Essa ferramenta permite grupos a publicarem e divulgarem posts entre si e em canais de divulgações como o Mercado Furry e o Mural do Cookiebot. 

> Para fins de desenvolvimento de qualidade, essa função foi descrita nos arquivos 'util_postforwarder.feature' e 'util_postgetter.feature'.

## Como utilizar a função de Publicação

### Background: O administrador do grupo adicionou o bot e o configurou propriamente

**Dado** Que o administrador do grupo ou um usuário autorizado criou um post para ser divulgado em outros canais,
**Enquanto**
Ele seleciona o post e digita função /publicar,
**Então** o bot irá encaminhar o post para ser aprovado e divulgado em grupos e canais que permitem ser feito. 

> O Post deverá ser aprovado pelo dono do bot, para evitar conteúdo suspeito de ser divulgado. 

## Como utilizar a função de Divulgação

### Background: O administrador do grupo adicionou o bot e o configurou propriamente

**Dado** Que o administrador do grupo permitiu o bot divulgar posts em seu grupo ou canal
**Enquanto**
Alguém em outro grupo publicou um post,
**Então** o bot irá encaminhar o post aprovado no grupo ou canal uma vez, em um horário determinado.

> O Post fará uma rotação entre grupos e canais, quando o post é publicado, o bot te mostra uma 'agenda' de divulgações.

