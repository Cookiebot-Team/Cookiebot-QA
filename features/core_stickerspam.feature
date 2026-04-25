Feature: anti-sticker spam that prevents users from sending excessive stickers in the group

    Background:
        Given that the bot is in the group and properly set up

    Scenario: User sends excessive stickers in the group
        Given that a user sends more than the set amount of stickers within a period of time
        When the bot detects the sticker spam
        Then the bot should issue a warning to the user about excessive sticker usage 

    Scenario: The feature is set up to allow sticker spam
        Given that the bot is configured to allow sticker spam
        When a user sends more than the set amount of stickers within a period of time
        Then the bot should not issue any warnings
