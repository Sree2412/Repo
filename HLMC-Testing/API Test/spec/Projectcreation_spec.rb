require 'spec_helper'
require 'httpclient'
require 'rubygems'
require 'bundler/setup'
require 'RestServiceBase'
require 'mocks/ProjectcreationMock'
require 'byebug'


describe "Projectcreation" do

  context 'GetDomainServices1' do

	it "Get" do
  expect(RestServiceBase.new("https://mlvdapmq01.huronconsultinggroup.com:8099/api/GetDomainServices/1").get[:body]).to eq(ProjectcreationMock::GetDomainServices1)
  end
end

  context 'GetDomainServices2' do

    it "Get" do
    expect(RestServiceBase.new("https://mlvdapmq01.huronconsultinggroup.com:8099/api/GetDomainServices/2").get[:body]).to eq(ProjectcreationMock::GetDomainServices2)
  end
end

  context 'RentionSchedules'  do

    it "Get" do
    expect(RestServiceBase.new("https://mlvdapmq01.huronconsultinggroup.com:8099/api/GetDomainRetentionSchedules").get[:body]).to eq(ProjectcreationMock::RentionSchedules)
  end
end
  context 'DomainSensitivities' do

   it "Get" do
   expect(RestServiceBase.new("https://mlvdapmq01.huronconsultinggroup.com:8099/api/GetDomainSensitivities").get[:body]).to eq(ProjectcreationMock::DomainSensitivities)
  end
end
  context 'SearchClients' do

   it "Get" do

   expect(RestServiceBase.new("https://mlvdapmq01.huronconsultinggroup.com:8099/api/SearchClients?match=test").get[:body]).to eq(ProjectcreationMock::SearchClients)
  end
end
  context 'SearchEngagements' do

   it "Get" do
   expect(RestServiceBase.new("https://mlvdapmq01.huronconsultinggroup.com:8099/api/SearchEngagements?match=HR&ClientID=6790").get[:body]).to eq(ProjectcreationMock::SearchEngagements)
  end
end
  context 'SearchProjectDetails' do

   it "Get" do
    expect(RestServiceBase.new("https://mlvdapmq01.huronconsultinggroup.com:8099/api/Project/5").get[:body]).to eq(ProjectcreationMock::SearchProjectDetails)
  end
end
  context 'SearchProject' do

   it "Get" do
    expect(RestServiceBase.new("https://mlvdapmq01.huronconsultinggroup.com:8099/api/SearchProjectName?projectName=Lambda").get[:body]).to eq(ProjectcreationMock::SearchProject)
  end
end
# context 'PostProject' do
#     it "Post" do
# 		expect(RestServiceBase.new("https://mlvdapmq01.huronconsultinggroup.com:8099/api/ProjectInsert").post(ProjectcreationMock::ProjectCreationInsertData)).to eq(ProjectcreationMock::ProjectCreatedData)
#    end
#  end
end
