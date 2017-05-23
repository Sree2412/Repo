require 'spec_helper'
require 'rubygems'
require 'bundler/setup'

describe "RRS Comments" do
  
  context 'Record Retention Schedule Client Comments' do
	before {
        @svc = RestServiceBase.new("http://mlvdac12.huronconsultinggroup.com:63767/odata/RecordRetentionScheduleItemComments")
        @svc.set_auth('username', 'password')
	}
	it "Get" do
		expect(@svc.get).to eq(RRSMock::GetClientComment)
	end
    it "Post" do
		expect(@svc.post(RRSMock::AddClientComment)).to eq(RRSMock::GetClientComment)
	end
  end
end