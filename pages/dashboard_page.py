class DashboardPage:
    def __init__(self, page):
        self.page = page
    
    def go_to(self):
        self.page.goto("https://www.cookiebot.com/en/dashboard/")

    def click_on_add_to_group(self):
        self.page.click("href=https://t.me/CookieMWbot?startgroup=new")
    
    def contact_po(self):
        self.page.click("href=https://t.me/MekhyW")
    
    def select_new_group(self):
        self.page.get_by_role("button", name="Switch group").click()

    def click_on_general_settings(self):
        self.page.click("href=/dashboard/general")

    def click_on_moderation_settings(self):

        self.page.click("href=/dashboard/moderation")
    
    def click_on_post_and_publications(self):
        self.page.click("href=/dashboard/posts")
    
    def click_on_stats_settings(self):
        self.page.click("href=/dashboard/stats")
    
    def click_on_activity_log(self):
        self.page.click("href=/dashboard/audit")