Feature: Group Guardian with captcha anti-bot invasion

        Background:
        Given that the group is protected by Cookiebot
        And the bot is properly set with this feature
    
    Scenario: User encounters the group and tries to join it 
        Given that the user is not a member of the group
        And the user tries to join the group
        When they solve the captcha challenge
        Then they should be able to join the group successfully

    Scenario: User encounters the group and tries to join it but fails the captcha challenge
        Given that the user is not a member of the group
        And the user tries to join the group
        When they fail to solve the captcha challenge correctly or timeouts
        Then they should not be able to join the group