require 'rspec'
require 'watir-webdriver'
require 'byebug'
require 'selenium-webdriver'
require 'yaml'
require 'Nokogiri'
require 'xpath'
require 'capybara'

SITE = ENV['SITE']
BROWSERR = Watir::Browser.new :chrome
TestFeatureConfig = {:browser => BROWSERR, :screen_capture => true}

Given (/^I have the url for "Relativity" 9.2 test$/) do
	BROWSERR.driver.manage.window.maximize
	BROWSERR.goto(SITE)
	#below line only for IE
	#BROWSERR.table(:align =>"center", :class=>"motdOuter").a(:name=>"_continue$button").click
end


def GetElement(css)
	nokogiriXpath = Nokogiri::CSS.xpath_for(css)
	return BROWSERR.element(:xpath, nokogiriXpath.join)
end

at_exit do
  BROWSERR.close
end

