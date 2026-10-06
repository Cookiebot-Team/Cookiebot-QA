Feature: displays the next users to have their birthdays

    Background:
        Given that the bot is in the group and properly set up
    
    Scenario: user sends the command "/nextbirthday"
        Given that the user is in the group
        When the user sends the command "/nextbirthday"
        Then the bot should reply with a list of the next users to have their birthdays, sorted by date
