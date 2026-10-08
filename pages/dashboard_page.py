class DashboardPage:
    def __init__(self, page):
        self.page = page
    
    def click_on_add_to_group(self):
        self.page.locator('a[href="https://t.me/CookieMWbot?startgroup=new"]').click()

    def contact_po(self):
        self.page.locator('a[href="https://t.me/MekhyW"]').click()

    def select_new_group(self):
        self.page.get_by_role("button", name="Switch group").click()

    def click_on_general_settings(self):
        self.page.get_by_role("link", name="General settings",exact=True).click()
        
    def click_on_moderation_settings(self):
        self.page.get_by_role("link", name="Moderation",exact=True).click()
    
    def click_on_post_and_publications(self):
        self.page.get_by_role("link", name="Posts & publications",exact=True).click()
    
    def click_on_stats_settings(self):
        self.page.get_by_role("link", name="Stats",exact=True).click()
    
    def click_on_activity_log(self):
        self.page.get_by_role("link", name="Activity log",exact=True).click()
