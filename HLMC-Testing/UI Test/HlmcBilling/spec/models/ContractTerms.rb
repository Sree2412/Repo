require_relative 'Hlmc'
require_relative 'mocks/HlmcBillingMock'
require_relative 'mocks/CT_Mock'
require 'json'
require 'byebug'

class ContractTerms < Hlmc
	include HlmcBillingUrl
	include HlmcBillingMock
	include CTMock

	def SetContractTerm(data)
		if data["Category"] != nil
			$browser.select(:id => 'ServiceCategoryId').option(:text => data["Category"]).when_present.click
		end
		if data["Name"] != nil
			$browser.select(:id => 'MasterServiceId').option(:text => data["Name"]).when_present.click
		end
		if data["Price"] != nil
			$browser.text_field(:id => "ProjectService_Price").when_present.set data["Price"]
		end
		if data["Location"] != nil
			$browser.select(:id => 'LocationId').option(:text => data["Location"]).when_present.click
		end
		if ($browser.a(:text => 'Save & Close').exists?) == true
			 $browser.a(:text => 'Save & Close').click
		elsif ($browser.a(:text => 'Save').exists?) == true
			 $browser.a(:text => 'Save').click
		end
	end

	def ContractTermAction(action, data)
		if "Add".casecmp(action) == 0
			$browser.a(:class => 'addContacts').click
			self.SetContractTerm(data)
		elsif "Update".casecmp(action) == 0
			$browser.ElementByCss('.smallEditTwo').click
			self.SetContractTerm(data)
			sleep 2
		end
	end

	def SetCertifiedState(state)
		if state == "Certified" && $browser.div(:class => 'contractTermsUncertifiedText',:text=>"Not Certified").exists?
	    # Verify if Contract Terms are Uncertified
      # If Contract Terms is Uncertified then we will Certify for the purpose of this test
	    puts "Contract Terms is Uncertified, Certifying it now!"  
	    $browser.div(:class => 'ContractTermsCertifyStatus').click
	  elsif state == "Decertified" && $browser.div(:class => 'contractTermsCertifiedText', :text =>"Certified").exists?
		  puts "Contract Terms is Certified, Decertifying it now"
			$browser.div(:class => 'ContractTermsCertifyStatus').click
	  end
  end

  def ContractTermState
  	return $browser.ElementByCss('#contractTermsStatusDiv > div').text
  end  

	def deleteExistingContractTerms
		deleteContractTermsButton = $browser.a(:class => "smallDeleteTwoContacts")
		while deleteContractTermsButton.exists? == true
			deleteContractTermsButton.click
			sleep 3
		end
	end

	def GetContractTermModels				
		model = Hash.new						
			model["Name"] 	  = $browser.ElementByCss(".serviceNameValue", 5).text						
			model["Location"] = $browser.ElementByCss(".locationNameValue", 5).text			
			model["Price"]		= ($brower.ElementByCss(".priceValue ", 5).text).gsub(/[^\d\.]/, '').to_s
		return model
	end

end