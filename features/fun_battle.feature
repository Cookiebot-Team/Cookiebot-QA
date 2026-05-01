Feature: bot makes a poll in the group, and users can vote on it on who would win in a battle

    Background:
        Given that the bot is in the group and properly set up

    Scenario: User creates a poll and users vote on it
        Given that the user is a member of the group
        When the user types the command /battle
        And tags another user in the group
        Then the bot should display a message "Who would win in a battle?" with options "Option A" and "Option B"
        And makes a poll in which the users can vote on who would win in a battle