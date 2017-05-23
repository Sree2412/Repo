require "spec_helper"
require 'pry'
require 'models/HlmcBilling'

describe "Hlmc Billing" do
  
  before {
  	@url= "https://qa-hlmc.huronconsultinggroup.com/Finance/ProjectBilling?projectId=1951"
   #@url = HlmcBillingUrl.const_get($env)
	$browser.goto @url
	@hlmc = HlmcBilling.new
  }
  
  context 'when creating billing item' do
	before {
		@hlmc.AddBillingItem(HlmcBillingMock::AddBillingMock)
		@hlmc.SelectBillingPeriod("09/2015")
	}
	it "should be present in list" do
		expect(@hlmc.GetProjectBillingItemModels()[0]).to eq(HlmcBillingMock::VerifyBillingMock)
	end
  end
  
  after(:each) do |example|
	if example.exception != nil
		#driver.save_screenshot "C:/RubyScripts/rspec/error.png"
	  end
  end
end