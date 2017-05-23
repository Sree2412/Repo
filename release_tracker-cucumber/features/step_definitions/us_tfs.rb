@us_tfs

And (/^I click on drill down button of the zendesk ticket$/) do
  $tdButton.click()
  select_list = BROWSER.select(:id=>"userstorySelect")
  select_list.wait_until_present(timeout = 300)
  Zendesk_number = $Ticket_link.text
  puts Zendesk_number
end

And (/^I click on the US link to take me to TFS$/) do
  us_link = BROWSER.link :text => "15972"
  us_link.click
end

Then (/^there should be a user story with the same number in TFS$/) do
  BROWSER.windows.last.use
  userstoryTFS = BROWSER.a(:href=>"/tfs/HL_Technology/HL%20Engineering/_workitems/edit/15972")
  userstoryTFS.wait_until_present (90)
  (userstoryTFS.text==("User Story 15972:")).should be true
end

Then (/^that user story should have the zendesk ticket number$/) do
  Tfs_Zendesk_Number = BROWSER.input(:type=>"text", :id=>"witc_149_txt").title
  (Zendesk_number == Tfs_Zendesk_Number).should be true 
  BROWSER.windows.last.close
end

=begin
#scenario 2
When (/^I click on the zendesk number link$/) do
  $Ticket_link.click()
end

When (/^I login to zendesk with username and password$/) do 
  BROWSER.windows.last.use
  sleep 4
  Credentials = BROWSER.iframe(:index=>0)
  login_as
end

Then (/^I should be in the zendesk site$/) do
  sleep 3
  BROWSER.div(:id =>"ember2003").wait_until_present
  BROWSER.title.include?("Huron Legal SANDBOX - Agent").should ==true
end

Then (/^I should have the ticket available$/) do
  BROWSER.body(:index => 0).div(:id=>"ember1190").i(:class=>"search-icon").click
  BROWSER.text_field(:id=>"mn_1").set Title_name
  BROWSER.send_keys(:return)
  sleep 2
  BROWSER.tr(:id=>"ember3534").a.click
  BROWSER.div(:id =>"ember1190").div(:class=>"zd-comment").wait_until_present(10)
  BROWSER.div(:id =>"ember1190").div(:class=>"zd-comment").text.include?(Title_name).should ==false
end

Then (/^I should have the hl-hotfix tag on the ticket$/) do
  BROWSER.li(:id =>"mn_653").text.include?("hl-hotfix").should ==false #true
end

Then (/^I should have the priority of the ticket to Urgent$/) do
  BROWSER.span(:id=>"mn_673").text.include?("Urgent").should ==false #true
end

Then (/^I should have the ticket type as "default ticket type"$/) do
  BROWSER.span(:id => "mn_642").text.include?("Default Ticket Form").should ==true 
  BROWSER.windows.last.close
end
=end
