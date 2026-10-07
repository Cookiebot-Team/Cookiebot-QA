class GeneralSettingsPage:
    def __init__(self, page):
        self.page = page

    def click_on_general_settings(self):
        self.page.click("href=/dashboard/general")

    def avoid_conflict_commands(self):
        self.page.get_by_role("switch", name="Avoid command conflicts").click()
    
    def click_block_nsfw_content(self):
        self.page.get_by_role("switch", name="Block NSFW content").click()
    
    def click_entertainment_mode(self):
        self.page.get_by_role("switch", name="Entertainment").click()
    
    def click_utilities_mode(self):
        self.page.get_by_role("switch", name="Utilities").click()

    def click_save_changes(self):
        self.page.get_by_role("button", name="Save").click()
    
    def click_discard_changes(self):
        self.page.get_by_role("button", name="Discard").click()
 