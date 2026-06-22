# Quality Assurance practices for 'Cookiebot Telegram Group Bot'

**This repo gives resources and skills needed to maintain the quality levels of Cookiebot. Given that the bot has a massive scope, with multiple features, these good practices should be kept to ensure and maintain it.**

The bot itself is chatbot responsible for protecting chats against spammers, conversating using natural language, perform speech-to-text, search media, schedule posts and provides fun features for events.

Current Version of the Bot: https://github.com/Cookiebot-Team/COOKIEBOT-Telegram-Group-Bot

Backend: https://github.com/MekhyW/COOKIEBOT-backend 

Web: https://github.com/MekhyW/COOKIEBOT-WebHub

### Staff:

PO: https://github.com/MekhyW

Backend Devs: https://github.com/dangerousplay // https://github.com/myghi63 // https://github.com/LuanMartinsbr

SDET/QA: https://github.com/bagriel01


## Summary of the repo

> 1. **Features** directory contains a list of the features from modules of the bot on the cucumber extension .feature. These files will contain a brief description of the feature and test scenarios that will be implemented via automation or unit testing. 

> 2. **Pages** directory will contain an 'inventory' of the WebHub pages, as a resource for the Playwright tool to use for automated testing.

> 3. **Tests** directory will contain future automation testing written for regressions.

> 4. **Documentation** directory contains a list of the modules and all pertinent documentation written in markdown format. 

## Guidelines for Bug Report

>1. If a bug is found, contact the QA with evidence of the issue. If unavailable to fulfill the issue formalization, follow those practices bellow:
>2. Errors and Defects found from the first version of Cookiebot should be labeled as [COOKIE1] and the Date of the issue found.
>3. These issues should be reported on the repo https://github.com/Cookiebot-Team/COOKIEBOT-Telegram-Group-Bot on GitHub Issues
>4. Issues from the newest version of the bot should be reported at this repo on GitHub Issues with the current bot version. 
>5. All issues, be it bug, improvement, or task, should be opened using the format Markdown. 
>6. Be sure to correctly label the issue with which module is affected by this behavior; Example: <em>[Core][QA Bug] Bot does not present the "join in" message if the user creates the group with the bot as the founding member. - Minor</em>
>7. Place the severity of the issue at the end of the summary like the example before 
>8. Use the format [Problem - Action - Location] to fulfill the Summary, for better visibility of the issue. 
>9. A Blank issue is located on Documentation folder that can be used as a template. 
