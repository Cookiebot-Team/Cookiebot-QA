Feature: bots rolls an n-sided die and returns the result

    Background:
        Given that the bot is in the group and properly set up

    Scenario: User rolls a 6-sided die
        Given that the user is a member of the group
        When the user sends the command "roll 6"
        Then the bot should respond with a number between 1 and 6

    Scenario: User rolls a 20-sided die
        Given that the user is a member of the group
        When the user sends the command "roll 20"
        Then the bot should respond with a number between 1 and 20

    Scenario: User rolls a die without specifying sides
        Given that the user is a member of the group
        When the user sends the command "roll"
        Then the bot should respond with an error message indicating that the number of sides must be specified