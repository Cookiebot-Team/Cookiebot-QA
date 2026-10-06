Feature: sends a firecracker message sequence to the group when the user types a specific command

    Background:
        Given that the bot is in the group and properly set up
    
    Scenario: User types the firecracker command
        Given that the user is a member of the group
        When the user types the command "/firecracker"
        Then the bot should send multiple firecracker messages in a sequence to the group

        