Feature: sends a montage of users that has their birthday on that day

    Background:
        Given that the bot is in the group and properly set up
    
    Scenario: user sends the command "/birthday"
        Given that the user is in the group
        When the user sends the command "/birthday"
        Then the bot should reply with a montage of users that has their birthday on that day