require './spec_helper'
require 'httpclient'
require 'rubygems'
require 'bundler/setup'
require 'RestServiceBase'
require './mocks/ClientServicesMock'
require 'byebug'
require 'json'


describe "ClientsServices" do

  context 'odata/Client' do
	it "Get" do

    Actualvalue1 = expect(RestServiceBase.new("http://mtpctscid929:8081/odata/Clients").get[:body])
    Actualvalue1.to include(ClientServices1::ID)
    Actualvalue1.to include(ClientServices1::Name)
    Actualvalue1.to include(ClientServices1::BillingNumber)
    Actualvalue1.to include(ClientServices1::BillingName)
  end
end
  context 'odata/Projects(814)/Client' do
    it "Get" do

     Actualvalue2 = expect(RestServiceBase.new("http://mtpctscid929:8081/odata/Projects(814)/Client").get[:body])
     Actualvalue2.to include(ClientServices2::ID)
     Actualvalue2.to include(ClientServices2::Name)
     Actualvalue2.to include(ClientServices2::BillingNumber)
     Actualvalue2.to include(ClientServices2::BillingName)
  end
 end

 context 'odata/Clients(7235)' do
   it "Get" do
     Actualvalue3 = expect(RestServiceBase.new("http://mtpctscid929:8081/odata/Clients(7235)").get[:body])
     Actualvalue3.to include(ClientServices3::ID)
     Actualvalue3.to include(ClientServices3::Name)
     Actualvalue3.to include(ClientServices3::BillingNumber)
     Actualvalue3.to include(ClientServices3::BillingName)
 end
end
end
