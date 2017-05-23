@UserStory_Headers

And (/^I click on drill down button on the zendesk ticket$/) do
  $tdButton.click()  
end

Then (/^I should have column headers with all the expected headers$/) do
  BROWSER.th(:id =>"userstoryHeader").exists?.should be true
  BROWSER.th(:id =>"userstoryProductAreaTh").exists?.should be true
  BROWSER.th(:id =>"userstoryPointsTh").exists?.should be true
  BROWSER.th(:id =>"userstoryEstTh").exists?.should be true
  BROWSER.th(:id =>"userstoryRemTh").exists?.should be true
  BROWSER.th(:id =>"userstoryCompTh").exists?.should be true
  BROWSER.th(:id =>"userstoryODTh").exists?.should be true
  BROWSER.th(:id =>"userstoryDaysTh").exists?.should be true
  BROWSER.th(:id =>"userstoryOwnerTh").exists?.should be true
  BROWSER.th(:id =>"userstoryReleaseTh").exists?.should be true
  BROWSER.th(:id =>"userstoryDownTh").exists?.should be true
  BROWSER.th(:id =>"userstoryTypeTh").exists?.should be true
  BROWSER.th(:id =>"userstoryFailureDownTh").exists?.should be true
  BROWSER.th(:id =>"userstoryMTTRTh").exists?.should be true
  BROWSER.th(:id =>"userstorySaveTh").exists?.should be true
end

Then (/^should be column headers Ticket Expand, Ticket#, Title, Release Status, Status, Solved, Created and Updated fields$/) do
sleep 15
  BROWSER.table(:id =>"ticketTable").exists?.should be true
  BROWSER.th(:id =>"ticketExpHead").exists?.should be true
  BROWSER.th(:id =>"ticketNumberHead").exists?.should be true
  BROWSER.th(:id =>"ticketTitleHead").exists?.should be true
  BROWSER.th(:id =>"ticketReleaseHead").exists?.should be true
  BROWSER.th(:id =>"ticketStatusHead").exists?.should be true
  BROWSER.th(:id =>"ticketSolvedHead").exists?.should be true
  BROWSER.th(:id =>"ticketExpHead").exists?.should be true
  BROWSER.th(:id =>"ticketCreatedHead").exists?.should be true
  BROWSER.th(:id =>"ticketUdpatedHead").exists?.should be true
end
