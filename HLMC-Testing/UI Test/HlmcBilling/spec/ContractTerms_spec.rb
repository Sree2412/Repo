require "spec_helper"
require 'models/ContractTerms'
require 'models/HlmcBilling'
require 'byebug'

describe "ContractTerms" do

  before {
      @url = HlmcBillingUrl.const_get($env)
      $browser.goto @url
      @ct = ContractTerms.new
      @hlmc = Hlmc.new
  }

  context "when contract term is certified and ADDED" do
      before {
        $browser.a(:class => 'contractTermsNav', :text => "Contract Terms").click        
        @ct.deleteExistingContractTerms
        @ct.SetCertifiedState("Certified")
        @ct.ContractTermAction("Add", CTMock::AddContractTermsMock)
      }
      
      it "should be added and also decertified" do
        expect(@ct.GetContractTermModels).to eq(CTMock::CompareCTMock)
        $browser.refresh
        expect(@ct.ContractTermState).to eq ("Not Certified")
        puts "Contract Terms is now Uncertified again" 
      end
  end

  context "when contract term is certified and UPDATED" do
      before {
        $browser.a(:class => 'contractTermsNav', :text => "Contract Terms").click 
        @ct.SetCertifiedState("Certified")
        @ct.ContractTermAction("Update", CTMock::UpdateContractTermsMock)
      }
  
    it "it should be updated and also decertified" do
      expect(@ct.GetContractTermModels).to eq(CTMock::CompareUpdatedCTMock)
      expect(@ct.ContractTermState).to eq ("Not Certified")
      puts "Contract Terms is now Uncertified again"  
    end
  
  end

  after(:each) do |example|
	if example.exception != nil
		#driver.save_screenshot "C:/RubyScripts/rspec/error.png"
	  end
  end
end
