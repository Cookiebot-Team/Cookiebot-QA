Feature: allows the admins of a group to ping everyone in the chat

    Background:
        Given that the bot is in the group and properly set up

    Scenario: Admins can use the command to ping everyone in the chat
        Given that the user is an admin of the group
        When an admin sends the command to /ping everyone
        Then all members of the group should receive a notification

    Scenario: Non-admins cannot use the command to ping everyone in the chat
        Given that the user is not an admin of the group
        When a non-admin sends the command to /ping everyone
        Then the bot should respond with a message indicating that they do not have permission to use this command