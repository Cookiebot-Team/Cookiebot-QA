import re

from playwright.sync_api import expect
from pytest_bdd import given, scenario, then, when

from pages.dashboard_page import DashboardPage
from pages.general_settings_page import GeneralSettingsPage

@scenario('../../features/miniapp/miniapp_NSFW_settings.feature', 'user enables the NSFW setting and discards the changes')
def test_enables_NSFW_discard():
    pass

@given("that the user is a group admin")
def is_user_group_admin():
    pass
# since i'm using my own personal account as test mass, this step is not required at this moment

@given("the bot is already added in the group")
def bot_added_to_group():
    pass
# at this version, the bot is persistently added on an UAT testing group so this step is not required. 

@given("the user is at the Miniapp home page")
def step_is_at_miniapp_home_page(page):
    DashboardPage(page)
    expect(page).to_have_url(re.compile(r".*/dashboard"))

@given("that the user selects the 'General Settings'")
def step_selects_general_settings(page):
    dashboard_page = DashboardPage(page)
    dashboard_page.click_on_general_settings()

@when("the user disables the 'Block NSFW Content' setting")
def step_disables_nsfw_setting(page):
    expect(page).to_have_url(re.compile(r".*/dashboard/general"))
    general_settings_page = GeneralSettingsPage(page)
    general_settings_page.click_block_nsfw_content()
    expect(page.get_by_role("switch", name="Block NSFW content")).not_to_be_checked()

@when("the bot displays the message '1 unsaved change in {group name}'")
def step_displays_unsaved_change_message(page):
    message = page.get_by_text("unsaved change in", exact=False).first
    expect(message).to_be_visible()

@then("the user discards the current setting")
def step_discards_current_setting(page):
    general_settings_page = GeneralSettingsPage(page)
    general_settings_page.click_discard_changes()
    expect(page.get_by_role("switch", name="Block NSFW content")).to_be_checked()

@then("the bot registers the setting being discarded")
def step_registers_setting_discarded(page):
    message = page.get_by_text("unsaved change in", exact=False).first
    expect(message).not_to_be_visible()
    expect(page.get_by_role("switch", name="Block NSFW content")).to_be_checked()