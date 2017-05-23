require "spec_helper"
require './ProdApp'

describe "Profile Test" do

  before {  	
    @url = ProdAppURL.const_get($env)
	$browser.goto @url
  	$browser.driver.manage.window.maximize
	@prodapp = ProdApp.new
	profile_name = 'H11344_QA'
  }

  context 'search for a profile name' do
	before {
		@prodapp.OpenProfile("H11344_QA")		
	}
	it "verify if profile exists" do
    	#sleep 2    			
			expect(ProfileTest.new.VerifyProfileExits(profile_name)).eq(true)
	end

	context 'profile values' do
	before {
		ProfileTest.new.NavigateToProfile("H11344_QA")
	}
	it 'Verifies Profile Values are Set' do
		expect(ProfileTest.new.VerifyProfileExits(profile_name)).eq(true)
	end 

	context 'Compare Output' do
	before {
		ProfileTest.new.RunTransform
	}
	it 'verify out put matches mock' do
		expect(ProfileTest.new.CompareOutputToMock(output_path, mock_path)).to be true
	end 

	context '' do
	before {}
	it '' do
	end 
  end



  after(:each) do |example|
	if example.exception != nil
		#driver.save_screenshot "C:/RubyScripts/rspec/error.png"
	  end
  end
end