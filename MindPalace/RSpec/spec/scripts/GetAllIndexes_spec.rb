require_relative '../../lib/RestServiceBase'
require_relative '../../lib/Utilities'
require_relative '../../spec/spec_helper'
require_relative '../../spec/mocks/MP_Mock'
require 'rubygems'
require 'json_spec'
require 'jsonpath'
require 'csv'
require 'rubyxl'

#require 'bundler/setup'

describe "Get all Indexes of Staging area and Searchable Index areas" do

  context 'Verify CAAT response' do
  	before {
          @svc = RestServiceBase.new("http://10.55.79.18:8080/nexus/r1/")
          @svc.set_auth('username', 'password')
          @result_body_with_html =  @svc.get[:body]
          @result_without_html = FunLibrary.extractJsonFromHTML(@result_body_with_html)
          @status_code = @svc.get[:code]
          @jsonsample = TestData::JsonSample
          @json = TestData::Json

  	}

    it "should get JSON response and compare with that of mock data" do
      expect(@result_without_html).to be_json_eql(TestData::JsonOutput)
  	end

    it "should get Response code 200" do
      expect(@status_code).to eq(200)
    end

    it "should read excel to get the mock data" do
      val = FunLibrary.getDataFromExcel("../../data/MockData.xlsx",0,1,1)
      expect(@result_without_html).to be_json_eql(val)
    end

    it "should parse sample nested json object" do
      path = JsonPath.new('$..author')
      puts path.on(@json)
    end

    it "should traverse api response json array and gets required value at nth place" do
      path = JsonPath.new('$..id')
      puts path.on(@result_without_html)
    end

    it "should read json data by each field" do
      result = JSON.parse(@jsonsample)
      result['fruits'].each { |hash|
          puts "\n\n#{hash['name']}, #{hash['location']}"
      }
    end

  end
end
