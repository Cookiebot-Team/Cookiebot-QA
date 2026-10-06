Feature: Post getter feature that shares posts forwarded from other groups or channels

    Scenario: Getter feature is set on the group and user views a post forwarded
        Given that the post forwarding feature is enabled on the group
        And the post is forwarded from another group or channel
        When the user views the post
        Then they should see the original source of the post and any relevant information about it
