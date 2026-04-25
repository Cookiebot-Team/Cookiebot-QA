Feature: /config command that allows the Admins to configure the bot's settings and preferences
  
    Scenario: Admin uses /config command to change the bot's language setting
        Given the user sends the command /config
        When the user is an admin on that group
        Then the bot should send a message on the group warning the admin to check their dms
        And the bot should send a message to the user dm's with the configuration options

    Scenario: User tries to use /config command but is not an admin
        Given the user sends the command /config
        When the user is not an admin on that group
        Then the bot should send a message on the group saying "You don't have permission to use this command."
        And display a video displaying how to use the /config command to the user 

    