Feature: sents a random media from any group that the bot is in

    Background:
        Given that the bot is in the group and properly set up

    Scenario: User sends the command to get a random media
        Given that the bot has access to media from groups it is in
        When the user sends the command "/random"
        Then the bot should respond with a random media from one of the groups it is in
        And the media should be appropriate for the group it is sent in