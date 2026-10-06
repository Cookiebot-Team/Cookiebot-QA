Feature: Displays the privacy politics of the bot, so that the users can know how their data is being used and protected

    Background:
        Given that the bot is in the group and properly set up

    Scenario: Displaying the privacy politics of the bot
        Given that a user is in the group
        When a user sends the command "/privacy"
        Then the bot should reply with a message containing the privacy politics of the bot
        