@feature_flags

#scenario 1
When (/^I click on link "Go To Feature Flags"$/) do
  FeatureFlagsPage()
end

And (/^I set all feature flags to Default$/) do
  FeatureSettings.new.SetAllDefault

end

And (/^I click on link Go to Release Tracker$/) do
  Release_Tracker.click
  Ticket_body.wait_until_present(timeout= 300)
  createdHeader = GetElement("#ticketCreatedHead > a > span")
  createdHeader.click
  Ticket_body.wait_until_present(timeout= 300)
  createdHeader.click
  Ticket_body.wait_until_present(timeout= 300)
end

Then (/^I should have the Search box, zendesk tickets, user stories, Create Ticket and not have brand new feature button$/) do
  BROWSER.div(:id =>"searchInputGroup").exists?.should be true
  BROWSER.button(:id =>"searchButton").exists?.should be true
  BROWSER.table(:id =>"ticketTable").exists?.should be true
  $tdButton.click()
  select_list = BROWSER.select(:id=>"userstorySelect")
  select_list.wait_until_present(timeout = 300)
  BROWSER.text.include?("User Story").should be true
  BROWSER.th(:id => "userstoryHeader").exists?.should be true
  BROWSER.text.include?("Create New Ticket").should be true
  BROWSER.a(:id =>"featureRequest").exists?.should be true
  BROWSER.text.include?("Brand New Feature").should be false
  BROWSER.a(:id =>"featureNew").exists?.should be false
  BROWSER.a(:id =>"featureLink").exists?.should be true
end


#scenario 2
And (/^I set all feature flags to Off$/) do
  FeatureSettings.new.SetAllOff
end

And (/^I click on link Go to Release Tracker for OFF settings$/) do
   Release_Tracker.click
end

Then (/I should not have the Search box, zendesk tickets, user stories, Create Ticket and brand new feature$/) do
  BROWSER.div(:id =>"searchInputGroup").exists?.should be false
  BROWSER.button(:id =>"searchButton").exists?.should be false
  begin
    firstrow = BROWSER.tbody(:id =>"ticketTbody")
    firstrow.wait_until_present(timeout = 5)
    link = BROWSER.link :text => "Ticket #"
    link.click
  rescue
    puts "waited 5 seconds without seeing the element"
  end
  begin
    createdHeader = GetElement("#ticketCreatedHead > a > span")
    createdHeader.click
    Ticket_body.wait_until_present(timeout= 300)
    createdHeader.click
    Ticket_body.wait_until_present(timeout= 300)
    $tdButton.click()
    sleep 5
   rescue
    puts "waited 5 seconds without seeing the element"
  end
  begin
    select_list = BROWSER.select(:id=>"userstorySelect")
    select_list.wait_until_present(timeout = 5)
  rescue
    puts "waited 5 seconds without seeing the element"
  end
  BROWSER.table(:id =>"ticketTable").exists?.should be false
  BROWSER.text.include?("Create New Ticket").should be false
  BROWSER.a(:id =>"featureRequest").exists?.should be false
  BROWSER.text.include?("Brand New Feature").should be false
  BROWSER.a(:id =>"featureNew").exists?.should be false
  BROWSER.a(:id =>"featureLink").exists?.should be true
  Feature_Click.click
  Flags_list.wait_until_present (timeout = 100)
  display_tickets_on = BROWSER.divs[12]
  display_tickets_on.click
  Release_Tracker.click
end

#scenario 3
And (/^I set the all feature flags to ON$/) do
  FeatureSettings.new.SetAllOn
end

And (/^I click on Go to Release Tracker$/) do 
  Release_Tracker.click
  Ticket_body.wait_until_present(timeout= 300)
end

Then (/I should have the Search box, zendesk tickets, user stories, Create Ticket and brand new feature$/) do
  BROWSER.div(:id =>"searchInputGroup").exists?.should be true
  BROWSER.button(:id =>"searchButton").exists?.should be true
  BROWSER.table(:id =>"ticketTable").exists?.should be true
  createdHeader = GetElement("#ticketCreatedHead > a > span")
  createdHeader.click
  Ticket_body.wait_until_present(timeout= 300)
  createdHeader.click
  Ticket_body.wait_until_present(timeout= 300)
  $tdButton.click()
  BROWSER.text.include?("User Story").should be true
  BROWSER.th(:id => "userstoryHeader").exists?.should be true
  BROWSER.text.include?("Create New Ticket").should be true
  BROWSER.a(:id =>"featureRequest").exists?.should be true
  BROWSER.text.include?("Brand New Feature").should be true
  BROWSER.a(:id =>"featureNew").exists?.should be true
  BROWSER.a(:id =>"featureLink").exists?.should be true
end
