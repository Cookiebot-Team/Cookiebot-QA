class DashboardPage:
    def __init__(self, page):
        self.page = page
    
    def go_to(self):
        self.page.goto("https://www.cookiebot.com/en/dashboard/")

    def click_on_add_to_group(self):
        self.page.click("xpath=/html/body/div/div[1]/main/div/div[1]/section/div/div/a[1]")
    
    def contact_PO(self):
        self.page.click("xpath=/html/body/div/div[1]/main/div/div[1]/section/div/div/a[2]")
    
    def select_new_group(self):
        self.page.click("xpath=/html/body/div/div[1]/main/div/div[1]/button/span[3]")  

    def click_on_general_settings(self):
        self.page.click("xpath=/html/body/div/div[1]/main/div/div[2]/a[1]")

    def click_on_moderation_settings(self):
        self.page.click("xpath=/html/body/div/div[1]/main/div/div[2]/a[2]")
    
    def click_on_post_and_publications(self):
        self.page.click("xpath=/html/body/div/div[1]/main/div/div[2]/a[3]")
    
    def click_on_stats_settings(self):
        self.page.click("xpath=/html/body/div/div[1]/main/div/div[2]/a[5]")
    
    def click_on_activity_log(self):
        self.page.click("xpath=/html/body/div/div[1]/main/div/div[2]/a[6]")