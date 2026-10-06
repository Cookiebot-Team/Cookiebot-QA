Feature: creates a shipp from one or more users

    Background:
        Given that the bot is in the group and properly set up

    Scenario: Create a shipp from two users
        Given that the user is in the group 
        When the user sends the command /shipp
        Then the bot should reply with a shipp of two users in the group
    
    Scenario: Create a shipp with one user already tagged
        Given that the user is in the group 
        When the user sends the command /shipp @user1
        Then the bot should reply with a shipp of user1 and another user in the group

    Scenario: Create a shipp with the fun feature turned off
        Given that the user is in the group 
        And the fun feature is turned off
        When the user sends the command /shipp @user1
        Then the bot should reply with a message saying that the fun feature is turned off