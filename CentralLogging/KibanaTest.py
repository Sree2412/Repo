__author__ = 'cmiller'

from KibanaMock import *
import unittest
from start import send_sample
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from selenium.common.exceptions import TimeoutException
from socket import error as socket_error


def element_wait(browser, tag, element):    # Wait function

    try:
        item = WebDriverWait(browser, 10).until(
            EC.element_to_be_clickable((tag, element))
        )
        return item

    except (socket_error, TimeoutException):
        browser.quit()


class KibanaTest(unittest.TestCase):

    def test_a_initlogcount(self):
        self.browser = webdriver.Chrome()
        self.browser.get(kibana_home)
        if logs_before == '0':
            element_wait(self.browser, By.XPATH, no_results_load)
        else:
            element_wait(self.browser, By.XPATH, results_load)
        hits = self.browser.find_element_by_xpath(hits_xpath).text
        self.assertEqual(hits, logs_before)     # Verify initial log count
        self.browser.quit()

    def test_b_totallogcount(self):
        test_apps = []
        send_sample("sport-sample.txt")
        self.browser = webdriver.Chrome()
        self.browser.get(kibana_home)
        element_wait(self.browser, By.XPATH, results_load)
        hits = self.browser.find_element_by_xpath(hits_xpath).text
        self.assertEqual(hits, logs_after)      # Verify log count after logs sent
        self.browser.find_element_by_xpath(sidebar).click()
        self.browser.find_element_by_xpath('//*[@title="app_name"]').click()
        self.browser.find_elements_by_link_text('Visualize')[1].click()
        element_wait(self.browser, By.CLASS_NAME, 'x-axis-wrapper')
        for i in self.browser.find_elements_by_class_name('tick'):
            test_apps.append(i.text)
        self.assertTrue(set(app_names).issubset(test_apps))     # Verify expected log fields present in graph
        self.browser.quit()

# Disabled until resolution for elapsed start and stop events being received by different servers
    # def test_c_elapsedtime(self):
    #     tags_present = []
    #     self.browser = webdriver.Chrome()
    #     self.browser.get(kibana_et_home)
    #     element_wait(self.browser, By.XPATH, no_results_load)
    #     hits = self.browser.find_element_by_xpath(hits_xpath).text
    #     self.assertEqual(hits, etlogs_before)   # Verify expected number of logs initially
    #     send_sample("test-elapsed-start.txt")
    #     self.browser.refresh()
    #     element_wait(self.browser, By.XPATH, results_load)
    #     hits = self.browser.find_element_by_xpath(hits_xpath).text
    #     self.assertEqual(hits, etlogs_start)    # Verify expected number of logs after sending start log
    #     send_sample("test-elapsed-stop.txt")
    #     self.browser.refresh()
    #     element_wait(self.browser, By.XPATH, results_load)
    #     hits = self.browser.find_element_by_xpath(hits_xpath).text
    #     self.assertEqual(hits, etlogs_stop)     # Verify expected number of logs after sending stop log
    #     self.browser.find_element_by_xpath(sidebar).click()
    #     elapsed_field = self.browser.find_element_by_xpath(elapsed_time).text
    #     self.assertEqual(elapsed_field, '#elapsed_time')    # Verify elapsed_time field present
    #     self.browser.find_element_by_xpath(available_fields).click()
    #     field_input = self.browser.find_element_by_xpath(field_name)
    #     field_input.send_keys('tags')
    #     self.browser.find_element_by_xpath('//*[@title="tags"]').click()
    #     self.browser.find_element_by_xpath(tags_vis).click()
    #     element_wait(self.browser, By.CLASS_NAME, 'x-axis-wrapper')
    #     for i in self.browser.find_elements_by_class_name('tick'):
    #         tags_present.append(i.text)
    #     self.assertTrue(set(tags).issubset(tags_present))   # Verify expected tags present
    #     self.browser.quit()

if __name__ == '__main__':
    unittest.main()