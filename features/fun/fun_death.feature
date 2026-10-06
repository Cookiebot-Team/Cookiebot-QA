Feature: makes a funny post with the user name and tells them how they will die

    Background:
        Given that the bot is in the group and properly set up

    Scenario: user uses the command /death
        Given that the user is in the group
        When the user sends the command /death
        Then the bot should reply with a meme and a random skull gif
        And random cause of death for the user

    Scenario: user uses the command /death with another user tagged
        Given that the user is in the group
        When the user sends the command /death and tags another user
        Then the bot should reply with a meme and a random skull gif
        And random cause of death for the tagged user