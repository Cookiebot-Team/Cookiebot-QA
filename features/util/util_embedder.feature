Feature: embedder feature that bypass the need to access a social media or site to see a video or picture

    Scenario: User sends a video link from a social media (e.g. bluesky)
        Given that the bot is running and responsive
        When the user sends a video link from bluesky
        Then the bot should reply to the link with an embedded version of it

    Scenario: User sends an invalid link or a link for an unsupported social media
        Given that the bot is running and responsive
        When the user sends an invalid link
        Then the bot should not respond