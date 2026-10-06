Feature: rules command that displays the set group rules 

    Background:
        Given that the bot is in the group and properly set up

    Scenario: User uses /rules command to view the group rules
        Given the user sends the command /rules
        When the bot receives the command
        Then the bot should send a message to the group displaying the set rules for that group

    Scenario: User tries to use /rules command but no rules are set
        Given the user sends the command /rules 
        When the bot receives the command
        Then the bot should send a message to the group saying "No rules have been set for this group yet. Please contact an admin to set the rules using /newrules command"

    Scenario: group admin sets new rules using /newrules command
        Given the user sends the command /newrules
        When the user is an admin on that group
        Then the bot should display the message "If you are an admin, REPLY THIS MESSAGE with the message that will be displayed when someone asks for the rules"
        And the admin should be able to reply to the bot's message with the new rules
        And the bot should save the new rules and display a message confirming that the rules have been updated

    Scenario: User tries to use /newrules command but is not an admin
        Given the user sends the command /newrules
        When the user is not an admin on that group
        Then the bot should send a message on the group saying "You don't have permission to use this command or are in anonymous mode"
        And display a video displaying how to remove anonymous mode from the user settings

    