Feature: sends a fun complaint message and picture to the group when the user types a specific command

    Background:
        Given that the bot is in the group and properly set up
    
    Scenario: User types the complaint command
        Given that the user is a member of the group
        When the user types the command "/complaint"
        Then the bot should send a fun complaint message to the group
        And the bot should send a fun complaint picture to the group 
        And prompt the user to answer the message with a complaint of their own

    Scenario: User responds to the complaint message
        Given that the user has received the fun complaint message
        When the user responds to the message with their own complaint
        Then the bot should send a voice message with a on-hold music to the group
        And then after some minutes answer with a random phrase.
        

        
