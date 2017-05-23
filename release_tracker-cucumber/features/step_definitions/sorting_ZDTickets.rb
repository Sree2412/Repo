@sorting_ZDTickets
  
#USES SPECIFIC TICKET NUMBER item_1643

Then (/^the zendesk tickets should be in ascending order$/) do
  Ticket_sort.click
  Ticket_body.wait_until_present(timeout= 300)
  begin
    $i = 1
    $e = 230
      while $i<$e do
        (BROWSER.tds[$i].text.to_i<BROWSER.tds[$i+8].text.to_i).should be true
        $i = $i+8
      end
  end
end
