Feature: Post forwarder feature that shares posts to other groups or channels

    Scenario: Forwarder feature is set on group a and getter feature is set on group b
        Given that the post forwarding feature is enabled on the group a and the getter feature is enabled on group b
        When a post is forwarded from group a to the bot
        Then the group b should receive the forwarded post with the original source and any relevant information about it

    Scenario: Forwarder feature is set up on group a but getter feature is disabled on the group b
        Given that the post forwarding feature is enabled on the group a and the getter feature is disabled on the group b
        When a post is forwarded from group a to the bot
        Then the bot should not forward the post to the group b
        