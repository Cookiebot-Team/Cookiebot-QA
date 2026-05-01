Feature: sends a picture from the partnered cons from a specific command
    Background:
        Given that the bot is in the group and properly set up
    
    Scenario: User types /bff in any group
        Given that the user is a member of the group
        When the user types the command "/bff"
        Then the bot should send a picture of the "Brasil Fur Fest" convention to the group

    Scenario: User types /patas in any group
        Given that the user is a member of the group
        When the user types the command "/patas"
        Then the bot should send a picture of the "Patas" convention to the group

    Scenario: User types /fursmeet in any group
        Given that the user is a member of the group
        When the user types the command "/fursmeet"
        Then the bot should send a picture of the "Fursmeet" convention to the group
    
    Scenario: User types /trex in in any group
        Given that the user is a member of the group
        When the user types the command "/trex"
        Then the bot should send a picture of the "Trex Furplayer" event to the group

    Scenario: User types /furcamp in any group
        Given that the user is a member of the group
        When the user types the command "/furcamp"
        Then the bot should send a picture of the "Furcamp" event to the group

    Scenario: User types /fursmeet in any group
        Given that the user is a member of the group
        When the user types the command "/fursmeet"
        Then the bot should send a picture of the "Fursmeet" convention to the group

    Scenario: User types /pawstral in any group
        Given that the user is a member of the group
        When the user types the command "/pawstral" 
        Then the bot should send a picture of the "Fursmeet" convention to the group
        