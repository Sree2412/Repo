@ticket_drafts

#**********delete the below snippet for full run#**************

And (/^I click on Create New Ticket$/) do
  CreateNewTicketPage()
end

Then (/^the fields Edit,Title,User Stories and Delete should be present$/) do
  BROWSER.th(:id =>"requestEditTh").exists?.should be true
  BROWSER.th(:id =>"requestSummaryTh").exists?.should be true
  BROWSER.th(:id =>"requestUS").exists?.should be true
  BROWSER.th(:text =>"Delete").exists?.should be true
  $table_count1 = BROWSER.table(:id =>"requestTable").rows.count
end

#scenario 2
Given (/^I am in Ticket Drafts page$/) do
  BROWSER.a(:id =>"requestAddLink").exists?.should be true
end

#**********delete the above snippet for full run#**************


When (/^I click on New Ticket button$/) do
  New_ticket.click
  Tic_title.wait_until_present
end

Then (/^I am directed to the Ticket Creation page$/) do
  BROWSER.form(:id =>"requestForm").exists?.should be true
end

#scenario 3
Given (/^I am in the Ticket Creation page$/) do
  BROWSER.form(:id =>"requestForm").exists?.should be true
end

When (/^I enter the title text box$/) do
  BROWSER.text_field(:id =>"titleInput").set "Cucumber Test 1"
end

And (/^I enter the user story text box$/) do
  BROWSER.text_field(:id =>"inputUserStoryId").set "17487"
end

And (/^I click on the add button for user story$/) do
  us_add = BROWSER.a(:class =>"btn btn-small").i(:class=>"icon-plus")
  us_add.click
  sleep 10
end

And (/^I click on the Save button at the bottom of the page$/) do
  form_save = BROWSER.button(:id =>"requestButtonSave")
  form_save.click
end

And (/^I click on the Back button at the bottom of the page$/) do
  form_back = BROWSER.button(:id =>"requestButtonBack")
  form_back.click
end

Then (/^I should be directed to Ticket Drafts page$/) do
   item_drafts = BROWSER.tbody(:id =>"requestTbody")
   item_drafts.wait_until_present(timeout = 300)
   sleep 5
  BROWSER.a(:id =>"requestAddLink").exists?.should be true
end

And (/^the entered ticket with title and userstory should be available here$/) do
  $table_count2 = BROWSER.table(:id =>"requestTable").rows.count
  new_ticket_name = BROWSER.table(:id=>"requestTable").rows[$table_count2-1].td(:id=>"requestSummaryTd").text
  puts new_ticket_name
  BROWSER.table(:id=> "requestTable").rows[$table_count2-1].td(:id=>"requestSummaryTd").text.include?("Cucumber Test 1").should be true
  BROWSER.table(:id=> "requestTable").rows[$table_count2-1].td(:id=>"TdUserStories").text.include?("17487").should be true
end

#scenario 4
Given (/^there is an item in the page$/) do
  BROWSER.td(:id =>"requestSummaryTd", :text =>"Cucumber Test 1").exists?.should be true
end

When (/^I click on a row's Edit button$/) do
  trs = BROWSER.trs;
  last_trs = trs[trs.count-1]
  edit_draft = last_trs.td(:id =>"requestEditTd").a(:id =>"requestEditLink")
  edit_draft.click
end

And (/^the stored data for that row's draft is pre-loaded into the page$/) do
  BROWSER.text.include?("17487 - Enter US # to pull headline from TFS").should be true
end

#scenario 5
When (/^I edit the title in the Title text box$/) do
  BROWSER.text_field(:id =>"titleInput").set "Cucumber Test Update"
end

And (/^I edit the user story # and title in the User Stories textbox$/) do
  BROWSER.text_field(:id =>"inputUserStoryId").set "17371"
end

And (/^the updated ticket with title and userstory should be available here$/) do
  BROWSER.text.include?("Cucumber Test Update").should be true
  BROWSER.text.include?("17487 ,17371").should be true
end

#scenario 6
Given (/^there is an updated item in the page$/) do
  BROWSER.td(:id =>"requestSummaryTd", :text =>"Cucumber Test Update").exists?.should be true
end

And (/^I click on a row's Delete button$/) do
  trs = BROWSER.trs;
  last_trs = trs[trs.count-1]
  delete_draft = last_trs.td(:id =>"requestDeleteTd").a(:id =>"requestDeleteLink")
  delete_draft.click
  sleep 15
end

Then (/^the stored data for that row's draft ticket is deleted$/) do
  BROWSER.text.include?("Cucumber Test Update").should be false
  BROWSER.text.include?("17487, 17371").should be false
end

#scenario 7
Then (/^I am directed to the Release Tracker home page$/) do
  firstrow = BROWSER.tbody(:id =>"ticketTbody")
  firstrow.wait_until_present(timeout = 300)
  firstrow.exists?.should be true
end
