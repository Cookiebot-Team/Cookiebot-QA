Feature: Bot skins feature that customizes the bot to cater to specific events

    Scenario: Bot skin "Bombot" is applied to the bot for "BrazilFurFest" 
        Given that the bot skin "Bombot" is applied to Cookiebot
        And the bot is on the "BrazilFurFest" event group
        When the user interacts with the bot in the group
        Then the bot should display the "Bombot" skin and provide event-specific interactions

    Scenario: Bot skin "Pawsy" is applied to the bot for "Pawstral"
        Given that the bot skin "Pawsy" is applied to Cookiebot
        And the bot is on the "Pawstral" event group
        When the user interacts with the bot in the group
        Then the bot should display the "Pawsy" skin and provide event-specific interactions

    Scenario: Bot skin "Tarinbot" is applied to the bot for "SCFurs" 
        Given that the bot skin "Tarinbot" is applied to Cookiebot
        And the bot is on the "SCFurs" event group
        When the user interacts with the bot in the group
        Then the bot should display the "Tarinbot" skin and provide event-specific interactions