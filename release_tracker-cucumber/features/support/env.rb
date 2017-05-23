require 'rspec'
require 'watir-webdriver'
require 'byebug'
require 'selenium-webdriver'
require 'nokogiri'
require 'xpath'

SITE = ENV['SITE']
BROWSER = Watir::Browser.new :chrome

Given (/^I am on Release Tracker$/) do
	BROWSER.driver.manage.window.maximize
	BROWSER.goto(SITE)
end

def GetElement(css)
	nokogiriXpath = Nokogiri::CSS.xpath_for(css)
	return BROWSER.element(:xpath, nokogiriXpath.join)
end

def GetReleaseStatus(rowText)
	return GetElement("#ticketTable > tbody > tr:contains('" + rowText + "')")
end

at_exit do
  BROWSER.close
end




