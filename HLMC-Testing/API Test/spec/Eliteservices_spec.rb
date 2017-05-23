require 'spec_helper'
require 'httpclient'
require 'rubygems'
require 'bundler/setup'
require 'RestServiceBase'
require 'mocks/EliteservicesMock'
require 'byebug'

def createService(url, username, password)
    svc = RestServiceBase.new(url)
    svc.set_auth(username, password)
    return svc
end
describe "Eliteservices" do

context 'Eliteservices' do
	  it "Get" do
		expect(createService("https://qa-hlmc.huronconsultinggroup.com/Permissions/GetCurrentUser","samada","Account1234@@").get[:body]).to eq(EliteservicesMock::EliteserviceOne)
    end
    it "Post" do
		# expect(RestServiceBase.new("https://qa-hlmc.huronconsultinggroup.com/BillingItemSvc/Post").post(EliteservicesMock::Elitebillingitem)).to eq(EliteservicesMock::Elitebillingitem)
    # expect(RestServiceBase.new("https://qa-eliteweb.huronconsultinggroup.com/api/BillingRollUpItemDelete/14842191/12252").post(EliteservicesMock::ElitebillingRollupitemDelete)).to eq(EliteservicesMock::ElitebillingRollupitemDelete)
  	# end
 end
end
end
