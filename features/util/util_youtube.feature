Feature: allows the user to search for a video on youtube and get the link of the video

    Background:
        Given that the bot is in the group and properly set up
    
    Scenario: user searches for a video on youtube
        Given that the user is in the group
        When the user sends the command "/youtube how to make a cake"
        Then the bot should reply with a link to a youtube video about how to make a cake