from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
import time

chrome_options = Options()
chrome_options.add_argument("--headless=new")
chrome_options.add_argument("--disable-gpu")

driver = webdriver.Chrome(
    service=Service(ChromeDriverManager().install()),
    options=chrome_options
)

site = "https://ruh-al-tarikh.github.io/System-Automation-Hub/"
driver.get(site)

time.sleep(3)

driver.execute_script("""
var style = document.createElement('style');
style.innerHTML = `
body {font-family: Segoe UI; line-height:1.6;}
header {background:#111827;color:white;padding:12px;}
`;
document.head.appendChild(style);
""")

print("UI automation executed")

driver.quit()