#require 'rspec'
require 'watir-webdriver'
SITE = "http://mlvdapmq01.huronconsultinggroup.com:8280/index.html#/"
BROWSER = Watir::Browser.start(SITE, :firefox)
PAGES ={"Feature Flags" => "http://mlvdapmq01.huronconsultinggroup.com:8280/index.html#/"
}

Given /^that I am on (.*)$/ do |page|
  BROWSER.goto(PAGES[page])
end

Then /^the page title should be (.)$/ do |release_tracker|
	BROWSER.title.eql?(release_tracker).should ==true
end

Then /^the page text should be "([^"]*)"$/) do |search_text|
	page.should have_content(search_text)
end
#BROWSER.text_field(:id => "Search Title").value
