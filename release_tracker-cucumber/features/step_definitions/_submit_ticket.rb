# When (/^I click on link "Go To Feature Flags"$/) do
#   Feature_Click.click
#   Flags_list.wait_until_present (timeout = 100)
# end

# And (/^I set the all feature flags to ON$/) do
#    FeatureSettings.new.SetAllOn
# end

# And (/^I click on Go to Release Tracker$/) do
#  Release_Tracker.click
#  Ticket_body.wait_until_present(timeout= 300)
# end
=begin
And (/^I click on Create New Ticket$/) do
  CreateNewTicketPage()
end

When (/^I click on New Ticket button$/) do
  New_ticket.click
  Tic_title.wait_until_present
end

When (/^I enter the zendesk ticket title in the text box$/) do
  BROWSER.text_field(:id =>"titleInput").set Title_name
  puts Title_name
 end
 
When (/^I set the Assignee$/) do
  BROWSER.div(:id=>"DivAssignee").click
  BROWSER.select_list(:id=>"SelAssignee").select("Max Cascone")
end

When (/^I enter multiple CC recievers$/) do
  BROWSER.text_field(:class=>"ui-select-container ui-select-multiple select2 select2-container select2-container-multi ng-valid ng-dirty").set "Kumar Shrestha"
  BROWSER.span(:class=>"ng-binding ng-scope").click
 end

When (/^I set the ticket to hotfix$/) do
  BROWSER.checkbox(:id => "CheckboxUrgent").set
end

When (/^I set the time to schedule of release$/) do
  BROWSER.text_field(:id => "InputDateTime").set '10/10/2015 10:01 AM'
end

And (/^I enter the 1st user story text box$/) do
  BROWSER.text_field(:id =>"inputUserStoryId").set "15972"
  Us_add.click
  sleep 3
end

And (/^I enter the 2nd user story text box$/) do
  BROWSER.text_field(:id =>"inputUserStoryId").set "16661"
  Us_add.click
  sleep 3
end

And (/^I enter the 3rd user story text box$/) do
  BROWSER.text_field(:id =>"inputUserStoryId").set "17091"
  Us_add.click
  sleep 3
end

And (/^I enter the 4th user story text box$/) do
  BROWSER.text_field(:id =>"inputUserStoryId").set "17371"
  Us_add.click
 sleep 3
end

And (/^I click on the submit button to create the zendesk ticket$/) do
  Submit_ticket.click
  Yes_button.wait_until_present
  sleep 5
  Yes_button.click
  sleep 5
end

 Then (/^the newly created ticket should be in the main release tracker$/) do
  Ticket_body.wait_until_present(timeout = 180)
  sleep 175
  BROWSER.refresh
  createdHeader = GetElement("#ticketCreatedHead > a > span")
  createdHeader.click
  Ticket_body.wait_until_present(timeout= 300)
  createdHeader.click
  Ticket_body.wait_until_present(timeout= 300)
  # Ticket_body.wait_until_present(timeout = 180)
  # Ticket_sort.click
  # Ticket_body.wait_until_present(timeout = 180)
    $New_ticket_title = Title_name + " – Release request"
    puts New_ticket_title
  # Newly_Created_Ticket =  BROWSER.td(:id=>"ticketTitle", :text => New_ticket_title)
  # while !Newly_Created_Ticket.exists? do
  #   BROWSER.send_keys :space
  # end
  BROWSER.text.include?(Title_name).should be true
 end

  $trow_count1 = BROWSER.trs.count
  BROWSER.send_keys :space
  BROWSER.send_keys :space
  BROWSER.send_keys :space
  BROWSER.send_keys :space
  BROWSER.send_keys :space
  Watir::Wait.until{BROWSER.trs.count>$trow_count1}.should be true
  
And (/^I click on the Save button at the bottom of the page$/) do
  Form_save.click
end

And (/^I click on the Back button at the bottom of the page$/) do
  Form_back.click
end

Then (/^I should be directed to Ticket Drafts page$/) do
  #item_drafts = BROWSER.tbody(:id =>"requestTbody")
  Item_drafts.wait_until_present(timeout = 45)
  sleep 3
  BROWSER.a(:id =>"requestAddLink").exists?.should be true
end

And (/^the entered ticket with title and userstory should be available here$/) do
  $table_count2 = BROWSER.table(:id =>"requestTable").rows.count
  new_ticket_name = BROWSER.table(:id=>"requestTable").rows[$table_count2-1].td(:id=>"requestSummaryTd").text
  us_numbers = BROWSER.table(:id=> "requestTable").rows[$table_count2-1].td(:id=>"TdUserStories").text
  puts new_ticket_name
  puts us_numbers
  BROWSER.table(:id=> "requestTable").rows[$table_count2-1].td(:id=>"requestSummaryTd").text.include?("Cucumber Test 1").should be true
  BROWSER.table(:id=> "requestTable").rows[$table_count2-1].td(:id=>"TdUserStories").text.include?("15972 ,16661 ,17091 ,17371").should be true
end

=end