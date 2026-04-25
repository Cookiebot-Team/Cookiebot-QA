Feature: Doomlist feature that prevents user listed on it to join groups with this feature set
    Background:
        Given that the group has the Doomlist feature enabled
        And the bot is properly set with this feature enabled

    Scenario: User on the Doomlist tries to join the group
        Given that the user is listed on the Doomlist
        When they try to join the group
        Then they should be prevented from joining the group
