=begin
Before do
  SITE = ENV['SITE']
  BROWSER = Watir::Browser.start(SITE, :chrome)
  $ticket_body = BROWSER.tbody(:id => "ticketTbody")
  $ticket_body.wait_until_present
  BROWSER.close
end
=end



  