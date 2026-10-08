Feature: NSFW setting that allows the bot to post adult memes and answer with a more mature language

    Background:
        Given that the user is a group admin
        And the bot is already added in the group
        And the user is at the Miniapp home page

    Scenario: user enables the NSFW setting and saves the changes
        Given that the user selects the 'General Settings'
        When the user disables the 'Block NSFW Content' setting
        And the bot displays the message '1 unsaved change in {group name}'
        Then the user saves the current setting
        And the bot registers the setting being saved
        And the original 'Block NSFW Content' setting is restored

    Scenario: user enables the NSFW setting and discards the changes
        Given that the user selects the 'General Settings'
        When the user disables the 'Block NSFW Content' setting
        And the bot displays the message '1 unsaved change in {group name}'
        Then the user discards the current setting
        And the bot registers the setting being discarded
        
  
    Scenario: user disables the NSFW setting and saves the changes
        Given that the user selects the 'General Settings'
        When the user enables the 'Block NSFW Content' setting
        And the bot displays the message '1 unsaved change in {group name}' 
        Then the user saves the current setting
        And the bot registers the setting being saved
        And the original 'Block NSFW Content' setting is restored

     Scenario: user disables the NSFW setting and discards the changes
        Given that the user selects the 'General Settings'
        When the user enables the 'Block NSFW Content' setting
        And the bot displays the message '1 unsaved change in {group name}'  
        Then the user discards the current setting
        And the bot registers the setting being discarded
    
  
    # And any unsaved changes are discarded
    # And the user closes the Miniapp