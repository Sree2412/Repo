require 'spec_helper'
require 'httpclient'
require 'rubygems'
require 'bundler/setup'
require 'RestServiceBase'
require 'mocks/STRMock'
require 'byebug'

describe "STR" do

  context 'STR services test' do
    before {
          @svc = RestServiceBase.new("https://qa-strweb.huronconsultinggroup.com/api/Client/6790")
  	}
  	it "Get" do
          @svc.set_auth("samada", "Account1234@@")
		expect(@svc.get).to eq(STRMock::STROne)
  end
end

 context 'STR services test' do
   before {
         @svc = RestServiceBase.new("https://qa-strweb.huronconsultinggroup.com/api/Project/10")
   }
   it "Get" do
         @svc.set_auth("samada", "Account1234@@")
   expect(@svc.get).to eq(STRMock::STRTwo)
 end
end

context 'STR services test' do
  before {
        @svc = RestServiceBase.new("https://qa-strweb.huronconsultinggroup.com/api/user")
  }
it "Get" do
      @svc.set_auth("samada", "Account1234@@")
expect(@svc.get).to eq(STRMock::STRThree)
end
end

context 'STR services test' do
  before {
        @svc = RestServiceBase.new("https://qa-strweb.huronconsultinggroup.com/api/user/getuserbylogin/mwan")
  }
	it "Get" do
           @svc.set_auth("samada", "Account1234@@")
          expect(@svc.get).to eq(STRMock::STRFour)
 end
end

 context 'STR services test' do
   before {
         @svc = RestServiceBase.new("https://qa-strweb.huronconsultinggroup.com/api/GetZenDeskUsers?name=shrestha")
   }
  it "Get" do
          @svc.set_auth("samada", "Account1234@@")
         expect(@svc.get).to eq(STRMock::STRFive)
  end
end
  context 'STR services test' do
    before {
          @svc = RestServiceBase.new("https://qa-strweb.huronconsultinggroup.com/api/GetZenDeskUsersByID?IDList=2342812487")
    }
 	it "Get" do
      @svc.set_auth("samada", "Account1234@@")
      expect(@svc.get).to eq(STRMock::STRSix)
   end
 end
   context 'STR services test' do
     before {
           @svc = RestServiceBase.new("https://qa-strweb.huronconsultinggroup.com/api/STR?projectID=7121")
     }
 	it "Get" do
      @svc.set_auth("samada", "Account1234@@")
      expect(@svc.get).to eq(STRMock::STRSeven)
   end
 end

end
