 require 'watir'
require 'watir-webdriver'


 $browser = Watir::Browser.new :chrome
    $browser.driver.manage.window.maximize

    $browser.goto('https://qa-hlmc.huronconsultinggroup.com/Finance/ContractTerms?projectId=1951')
    deleteContractTermsButton = $browser.a(:class => "smallDeleteTwoContacts")
		
		# end $browser.div(:class => "serviceNameValue truncate")
			while $browser.a(:class => "smallDeleteTwoContacts").exists? == true
				deleteContractTermsButton.click
				$browser.refresh
				sleep 2
				# byebug
			end