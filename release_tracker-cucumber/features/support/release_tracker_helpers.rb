  Ticket_sort = BROWSER.link :text => "Ticket #"
  Feature_Click = BROWSER.link :text => "Go To Feature Flags"
  Release_Tracker = BROWSER.link :text => "Go To Release Tracker"
  Brand_New = BROWSER.a(:id =>"featureNew")
  Ticket_body = BROWSER.tbody(:id => "ticketTbody")
  Flags_list = BROWSER.div(:class =>"feature-flags-name ng-binding",  :text =>"Search Title")
  Request_feature_on = BROWSER.divs[24]
  Create_new_ticket = BROWSER.link :text =>"Create New Ticket"
  Draft_headers = BROWSER.thead(:id =>"requestThead")
  New_ticket = BROWSER.link :text =>"New Ticket"
  Tic_title = BROWSER.div(:id =>"requestTitleDiv")
  Us_add = BROWSER.a(:class =>"btn btn-small").i(:class=>"icon-plus")
  Form_save = BROWSER.button(:id =>"requestButtonSave")
  Form_back = BROWSER.button(:id =>"requestButtonBack")
  Item_drafts = BROWSER.tbody(:id =>"requestTbody")
  Submit_ticket = BROWSER.button(:id=>"requestButtonSubmit")
  Yes_button = BROWSER.button(:id=>"buttonYes")
  #Title_name = "Cucumber Test " + Time.now.to_s
  Title_name = 'Cucumber Test'  
  $tdButton = GetElement("#ticketTable > tbody > tr:contains('%s')>td:first>button" % Title_name)
  #$tdButton = GetElement("#ticketTable > tbody > tr:contains('Cucumber Test')>td:first>button")
  $Ticket_link = GetElement("#ticketTable > tbody > tr:contains('Cucumber Test')>td:nth-child(2)>a")
  #Title_name_chopped = $Ticket_link.text.chomp(' -0500 - Release request')
  Username = "username@huronconsultinggroup.com"
  Password = "P@ssw0rd"
    