Feature: bot generates memes based on user input

    Background:
        Given that the bot is in the group and properly set up

    Scenario: User generates a meme with the bot
        Given that the user has access to the meme generation command
        When the user sends a command to generate a meme with specific text
        Then the bot should respond with a generated meme image containing the specified text

    Scenario: User tries to generate a meme with the feature turned off on that group
        Given that the meme generation feature is turned off for the group
        When the user sends a command to generate a meme
        Then the bot should respond with a message indicating that the feature is disabled for the group

        