Feature: Setting the language for Cookiebot 

    Background:
        Given that the user is on the Cookiebot settings page
        And the user has access to the language settings
    
    Scenario: User changes the language to Spanish
        Given that the user is on the language settings page
        When they select "Spanish" from the language options
        Then the bot should display texts and respond in Spanish

    Scenario: User changes the language to English
        Given that the user is on the language settings page
        When they select "English" from the language options
        Then the bot should display texts and respond in English

    Scenario: User changes the language to Brazilian Portuguese
        Given that the user is on the language settings page
        When they select "Brazilian Portuguese" from the language options
        Then the bot should display texts and respond in Brazilian Portuguese