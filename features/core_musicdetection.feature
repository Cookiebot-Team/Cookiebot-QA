Feature: automatic music detection that identifies the song played in a voice message

    Background:
        Given that the bot is in the group and properly set up
        
    Scenario: User sends a voice message with music playing in the background
        Given the user sends a voice message with music playing in the background
        When the bot receives the voice message
        Then the bot should analyze the audio and identify the song being played
        And the bot should send a message to the group with the name of the song and artist