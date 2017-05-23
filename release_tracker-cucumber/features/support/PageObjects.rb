def FeatureFlagsPage()
  	Feature_Click.click
  	Flags_list.wait_until_present (timeout = 100)
end

def CreateNewTicketPage()
 	Create_new_ticket.click
 	Draft_headers.wait_until_present
end

def login_as      
    Credentials.text_field(:id=> "user_email", :name=> "user[email]").set Username
    Credentials.text_field(:id=> "user_password", :name=>"user[password]").set Password
    Credentials.input(:class=> "button primary", :value=>"Sign in").click
end

