Feature: media restrict feature that prevents new users from posting media in the group

    Background:
        Given that the bot is in the group and properly set up

    Scenario: New user is restricted from posting media
        Given that a new user joins the group
        When the new user attempts to post media content
        Then the bot should prevent the new user from posting media and display a warning message

    Scenario: Existing user is allowed to post media
        Given that an existing user is in the group for more than the time limit set for media restrictions
        When the user attempts to post media content
        Then the bot should allow the existing user to post media without any restrictions