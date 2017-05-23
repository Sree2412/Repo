require './spec_helper'
require 'httpclient'
require 'rubygems'
require 'bundler/setup'
require 'RestServiceBase'
require './mocks/ProjectServicesMock'
require 'byebug'
require 'JSON'


describe "ProjectServices" do

  context 'odata/Projects' do

	it "Get" do

   Actualvalue1 = expect(RestServiceBase.new("http://mtpctscid929:8081/odata/Projects").get[:body])
   Actualvalue1.to include(ProjectServices1::ID)
   Actualvalue1.to include(ProjectServices1::Name)
   Actualvalue1.to include(ProjectServices1::Code)
   Actualvalue1.to include(ProjectServices1::ClientID)
   Actualvalue1.to include(ProjectServices1::ClientName)
   Actualvalue1.to include(ProjectServices1::DomainServiceLineID)
   Actualvalue1.to include(ProjectServices1::DomainServiceLineName)
   Actualvalue1.to include(ProjectServices1::DomainProjectStatusID)
   Actualvalue1.to include(ProjectServices1::DomainProjectStatusName)
   Actualvalue1.to include(ProjectServices1::Requestor)
   Actualvalue1.to include(ProjectServices1::ActiveDirectorySecurityGroup)
   Actualvalue1.to include(ProjectServices1::DatabaseServer)
   Actualvalue1.to include(ProjectServices1::DatabaseName)
   Actualvalue1.to include(ProjectServices1::AdoConnectionString)
   Actualvalue1.to include(ProjectServices1::OleDbConnectionString)
   Actualvalue1.to include(ProjectServices1::OdbcConnectionString)
   Actualvalue1.to include(ProjectServices1::HasCertifiedContractTerms)

  end
end

  context 'odata/Projects(814)' do

    it "Get" do
    Actualvalue2 = expect(RestServiceBase.new("http://mtpctscid929:8081/odata/Projects(814)").get[:body])
    Actualvalue2.to include(ProjectServices2::ID)
    Actualvalue2.to include(ProjectServices2::Name)
    Actualvalue2.to include(ProjectServices2::Code)
    Actualvalue2.to include(ProjectServices2::ClientID)
    Actualvalue2.to include(ProjectServices2::ClientName)
    Actualvalue2.to include(ProjectServices2::DomainServiceLineID)
    Actualvalue2.to include(ProjectServices2::DomainServiceLineName)
    Actualvalue2.to include(ProjectServices2::DomainProjectStatusID)
    Actualvalue2.to include(ProjectServices2::DomainProjectStatusName)
    Actualvalue2.to include(ProjectServices2::Requestor)
    Actualvalue2.to include(ProjectServices2::ActiveDirectorySecurityGroup)
    Actualvalue2.to include(ProjectServices2::DatabaseServer)
    Actualvalue2.to include(ProjectServices2::DatabaseName)
    Actualvalue2.to include(ProjectServices2::AdoConnectionString)
    Actualvalue2.to include(ProjectServices2::OleDbConnectionString)
    Actualvalue2.to include(ProjectServices2::OdbcConnectionString)
    Actualvalue2.to include(ProjectServices2::HasCertifiedContractTerms)
  end
 end
end
