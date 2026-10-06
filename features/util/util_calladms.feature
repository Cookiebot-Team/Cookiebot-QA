Feature: command /adm that ping all adm's from a group 

    Background:
        Given that the bot is in the group and properly set up

    Scenario: User pings the bot with the /adm command
        Given that there are admins in the group
        When the user sends the /adm command to the bot
        And confirms the intention to ping all admins
        Then the bot should respond by pinging all admins in the group
        And should send a message on the adm's DM confirming that they have been pinged in a group