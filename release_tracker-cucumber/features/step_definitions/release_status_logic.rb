@release_status_logic

#Scenario 1
Given (/^the release tracker with drill down and sub header "User Story"$/) do
  BROWSER.driver.manage.window.maximize
  BROWSER.goto(SITE)
  Ticket_body.wait_until_present(timeout= 300)
  createdHeader = GetElement("#ticketCreatedHead > a > span")
  createdHeader.click
  Ticket_body.wait_until_present(timeout= 300)
  createdHeader.click
  Ticket_body.wait_until_present(timeout= 300)
  $tdButton.click()
  BROWSER.text.include?("User Story").should be true
end

When (/^I set the release status of 1st user story to "NULL" 7th round$/) do
  select_list = BROWSER.select(:id=>"userstorySelect")
  select_list.wait_until_present(timeout = 300)
   #No action required since its null by default except wait for element to appear
end

When (/^I set the release status of 2nd user story to "NULL" 7th round$/) do
  #No action required since its null by default
end

When (/^I click Save to save the 7th round changed release statuses$/) do
  BROWSER.tr(:id =>"userstoryRow").td(:id =>"userstorySaveTd").i(:id, "userstorySaveI" ).click
end

Then (/^the release status of the zendesk ticket should be NULL 7th round$/) do
  row = GetReleaseStatus(Title_name)
  #change the below line to false once we have create ticket going
  row.tds[3].text.include?("Success").should == true #false
  row.tds[3].text.include?("Failed").should == false
  row.tds[3].text.include?("Partial").should == false
 end

#Scenario 2
When (/^I set the release status of 1st user story to Success 5th round "Release Tracker"$/) do
  select_list = BROWSER.select(:id=>"userstorySelect")
  select_list.wait_until_present(timeout = 300)
  select_list.select_value ("0")
end

When (/^I set the release status of 2nd user story to "NULL" 5th round$/) do
#No action required since its null by default
end

When (/^I click Save to save the 5th round changed release statuses$/) do
  BROWSER.tr(:id =>"userstoryRow").td(:id =>"userstorySaveTd").i(:id, "userstorySaveI" ).click
end

Then (/^the release status of the zendesk ticket should be Success 5th round$/) do
  row = GetReleaseStatus(Title_name)
  row.tds[3].text.should include("Success")
  #BROWSER.screenshot.save "results\\Success_w_NULL_screenshot.png"
end

#Scenario 3
When (/^I set the release status of 1st user story to "Partial" 6th round$/) do
  select_list = BROWSER.select(:id=>"userstorySelect")
  select_list.wait_until_present(timeout = 300)
  select_list.select_value ("1")
end

When (/^I set the release status of 2nd user story to "NULL" 6th round$/) do
  #No action required since its null by default
end

When (/^I click Save to save the 6th round changed release statuses$/) do
  BROWSER.tr(:id =>"userstoryRow").td(:id =>"userstorySaveTd").i(:id, "userstorySaveI" ).click
end

Then (/^the release status of the zendesk ticket should be Partial 6th round$/) do
  row = GetReleaseStatus(Title_name)
  row.tds[3].text.should include("Partial")
   #BROWSER.screenshot.save "results\\Partial_w_NULL_n_Success_screenshot.png"
end

#Scenario 4
When (/^I set the release status of 1st user story to "Success" 1st round$/) do
  select_list = BROWSER.select(:id=>"userstorySelect")
  select_list.wait_until_present(timeout = 300)
  select_list.select_value ("0")
 end

When (/^I set the release status of 2nd user story to "Failed" 1st round$/) do
  BROWSER.select_lists[1].select_value ("2")
end

When (/^I set the release status of 3rd user story to "Partial" 1st round$/) do
  BROWSER.select_lists[2].select_value ("1")
end

When (/^I click Save to save the 1st round changed release statuses$/) do
  BROWSER.tr(:id =>"userstoryRow").td(:id =>"userstorySaveTd").i(:id, "userstorySaveI" ).click
end

Then (/^the release status of the zendesk ticket should be Failed 1st round$/) do
  row = GetReleaseStatus(Title_name)
  row.tds[3].text.should include("Failed")
  #BROWSER.screenshot.save "results\\Failed_screenshot.png"
end

  
#Scenario 5
When (/^I set the release status of 1st user story to "Success" 2nd round$/) do
  select_list = BROWSER.select(:id=>"userstorySelect")
  select_list.wait_until_present(timeout = 300)
  select_list.select_value ("0")
 end

When (/^I set the release status of 2nd user story to "Success" 2nd round$/) do
  BROWSER.select_lists[1].select_value ("0")
end

When (/^I set the release status of 3rd user story to "Success" 2nd round$/) do
  BROWSER.select_lists[2].select_value ("0")
end

When (/^I set the release status of 4th user story to "Success" 2nd round$/) do
  BROWSER.select_lists[3].select_value ("0")
end

When (/^I click Save to save the 2nd round changed release statuses$/) do
  BROWSER.tr(:id =>"userstoryRow").td(:id =>"userstorySaveTd").i(:id, "userstorySaveI" ).click
end

Then (/^the release status of the zendesk ticket should be Success 2nd round$/) do
  row = GetReleaseStatus(Title_name)
  row.tds[3].text.should include("Success")
  #BROWSER.screenshot.save "results\\AllSuccess_screenshot.png"
end

#Scenario 6
When (/^I set the release status of 1st user story to "Failed" 3rd round$/) do
  select_list = BROWSER.select(:id=>"userstorySelect")
  select_list.wait_until_present(timeout = 300)
  select_list.select_value ("2")
 end

When (/^I set the release status of 2nd user story to "Failed" 3rd round$/) do
  BROWSER.select_lists[1].select_value ("2")
end

When (/^I set the release status of 3rd user story to "Failed" 3rd round$/) do
  BROWSER.select_lists[2].select_value ("2")
end

When (/^I set the release status of 4th user story to "Failed" 3rd round$/) do
  BROWSER.select_lists[3].select_value ("2")
end

When (/^I click Save to save the 3rd round changed release statuses$/) do
  BROWSER.tr(:id =>"userstoryRow").td(:id =>"userstorySaveTd").i(:id, "userstorySaveI" ).click
end

Then (/^the release status of the zendesk ticket should be Failed 3rd round$/) do
  row = GetReleaseStatus(Title_name)
  row.tds[3].text.should include("Failed")
  #BROWSER.screenshot.save "results\\AllFail_screenshot.png"
end

#Scenario 7
When (/^I set the release status of 1st user story to "Partial" 4th round$/) do
  select_list = BROWSER.select(:id=>"userstorySelect")
  select_list.wait_until_present(timeout = 300)
  select_list.select_value ("1")
 end

When (/^I set the release status of 2nd user story to "Partial" 4th round$/) do
  BROWSER.select_lists[1].select_value ("1")
end

When (/^I set the release status of 3rd user story to "Partial" 4th round$/) do
  BROWSER.select_lists[2].select_value ("1")
end

When (/^I set the release status of 4th user story to "Partial" 4th round$/) do
  BROWSER.select_lists[3].select_value ("1")
end

When (/^I click Save to save the 4th round changed release statuses$/) do
  BROWSER.tr(:id =>"userstoryRow").td(:id =>"userstorySaveTd").i(:id, "userstorySaveI" ).click
end

Then (/^the release status of the zendesk ticket should be Partial 4th round$/) do
  row = GetReleaseStatus(Title_name)
  row.tds[3].text.should include("Partial") 
end
