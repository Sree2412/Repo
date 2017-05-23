@infinte_scrolling

When (/^I scroll to the bottom$/) do
  $trow_count1 = BROWSER.trs.count
  BROWSER.send_keys :space
  BROWSER.send_keys :space
  BROWSER.send_keys :space
  BROWSER.send_keys :space
  Watir::Wait.until(timeout =90){BROWSER.trs.count>$trow_count1}.should be true
end

Then (/^more zendesk tickets should appear$/) do
  $trow_count2 = BROWSER.trs.count
  ($trow_count2>$trow_count1).should be true 
end

at_exit do
  BROWSER.close
end