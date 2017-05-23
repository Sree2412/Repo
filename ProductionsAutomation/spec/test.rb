require 'watir'
require 'watir-webdriver'
require 'byebug'

$browser = Watir::Browser.new :chrome
$browser.driver.manage.window.maximize
$browser.goto('http://mtpctscid961/ProductionsWeb/')
byebug
$browser.button(:text => 'Open Profile').click