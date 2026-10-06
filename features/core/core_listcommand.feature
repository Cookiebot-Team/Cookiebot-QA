Feature: Using /commands displays a list with the commands available to the user

    Background:
        Given that the bot is online and operational

    Scenario: User types /commands in the group chat
        Given that the user is a member of the group
        When they type /commands in the group chat
        Then they should see a list of commands available to them

    Scenario: User types /commands in a private chat with the bot
        Given that the user is not a member of any group
        When they type /commands in a private chat with the bot
        Then they should see a list of commands available to them