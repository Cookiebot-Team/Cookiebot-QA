Feature: customized welcome message set by the group admins that is sent to new members when they join the group

    Background:
        Given that the bot is in the group and properly set up

    Scenario: Group admin sets a welcome message using /newwelcome command
        Given the user sends the command /newwelcome
        When the user is an admin on that group
        Then the bot should display the message "If you are an admin, REPLY THIS MESSAGE with the message that will be displayed when someone joins the group. You can include <user> to be replaced with the user name"
        And the admin should be able to reply to the bot's message with the new welcome message
        And the bot should save the new welcome message and display a message confirming that the welcome message has been updated

    Scenario: User tries to use /newwelcome command but is not an admin
        Given the user sends the command /newwelcome
        When the user is not an admin on that group
        Then the bot should send a message on the group saying "You don't have permission to use this command or are in anonymous mode"
        And display a video displaying how to remove anonymous mode from the user settings

    Scenario: New member joins the group and receives welcome message
        Given a new member joins the group
        When the bot detects that a new member has joined
        Then the bot should send a message to the group welcoming the new member using the set welcome message.