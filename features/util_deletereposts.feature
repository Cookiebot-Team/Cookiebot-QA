Feature: Delete all posts gotten by the post getter

    Background: 
    Given that the bot is in the group and properly set up

    Scenario: Admin uses /deletereposts
        Given the user is an admin on that group
        When they use the /deletereposts command
        Then all posts sent by the post getter feature are deleted

    Scenario: user tries to use /deletereposts
        Given that the user is in a group
        When they tried to use the /deletereposts command
        Then the bot should send a message on the group saying "You don't have permission to use this command or are in anonymous mode"
        And display a video displaying how to remove anonymous mode from the user settings 
