Feature: Utility /isalive feature for bot health checks

    Background:
        Given that the bot is in the group and properly set up

    Scenario: User pings the bot with the /isalive command
        Given that the bot is running and responsive
        When the user sends the /isalive command to the bot
        Then the bot should respond with a message confirming it is alive and operational

    Scenario: User pings the bot with the /isalive command but the bot is down
        Given that the bot is not running or unresponsive
        When the user sends the /isalive command to the bot
        Then the user should not receive any message back 