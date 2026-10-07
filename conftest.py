import pytest
from playwright.sync_api import Playwright, sync_playwright, expect
from dotenv import WEBSITE


# @pytest.fixture(scope="session",autouse=True)
# def website():
#     return WEBSITE
# def test_id_attribute(playwright: Playwright): 
#     playwright.selectors.set_test_id_attribute("data_test")
# currently does not support data_test id, will be updated in future releases

@pytest.fixture
def page():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=False)  # Set headless=True for headless mode
        page = browser.new_page()
        yield page
        browser.close()

