
=begin
require 'nokogiri'
require 'watir-webdriver'
require 'restclient'
require 'rubygems'
require 'byebug'
require 'mechanize'
#https://qa-hlmc.huronconsultinggroup.com/Project/Details?projectId=5387
#http://mlvtdev-64.huronconsultinggroup.com/index.html#/
#doc = Nokogiri::HTML(open("http://www.bbc.com/"))
#sleep 5
#puts doc
#'//tr[@id = "item_1947"]/td[@id = "ticketNumber"]'
#node = doc.xpath('/h1[@id = "page-title"]')

#puts node.child.text

# doc.xpath('/h1[@id = "page-title"]').each do |node|
# 	puts node.text
# 	puts 'test'
# end

# BROWSER = Watir::Browser.new :chrome
# BROWSER.driver.manage.window.maximize
#  BROWSER.goto("http://mlvtdev-64.huronconsultinggroup.com/index.html#/")
#  Ticket_body.wait_until_present(timeout= 300)

browser = Watir::Browser.new
browser.goto "http://mlvtdev-64.huronconsultinggroup.com/index.html#/"
Ticket_body = browser.tbody(:id => "ticketTbody")
Ticket_body.wait_until_present(timeout= 300)
page = Nokogiri::HTML.parse(browser.html)

#createdLink = page.css("#ticketCreatedHead > a > span")


byebug
agent_page.link_with(Nokogiri::CSS.xpath_for("#ticketCreatedHead > a > span")).click

byebug
#page = Nokogiri::HTML(RestClient.get("http://mlvtdev-64.huronconsultinggroup.com/index.html#/"))
puts page.class
#puts page.css.text
puts page.css('#ticketTable > tbody > tr:contains("Release of Allegory Plugin to Production Workspace H12719")').length
at_exit do
  browser.close
end
=end
