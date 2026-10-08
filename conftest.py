import pytest
import os
from playwright.sync_api import Playwright, sync_playwright, expect
from dotenv import load_dotenv
import pytest

load_dotenv()

# @pytest.fixture(scope="session",autouse=True)
# def website():
#     return WEBSITE
# def test_id_attribute(playwright: Playwright): 
#     playwright.selectors.set_test_id_attribute("data_test")
# currently does not support data_test id, will be updated in future releases

@pytest.fixture
def page():
    with sync_playwright() as p:
        context = p.firefox.launch_persistent_context (
            user_data_dir="playwright/firefox-profile",
            headless=False,
            ) 
        page = context.pages[0]
        page.goto(os.environ["WEBSITE"])
        yield page
        context.close()

