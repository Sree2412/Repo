require '../../spec_helper'
require '../../lib/ProfileTest'


describe "Profile Test" do
	before :all do  	
		@url = ProdAppUrl.const_get($env)
		$browser.goto @url  	
		@prodapp = ProfileTest.new
	end

  	context 'Create Profile and Save it' do
		before {
			@prodapp.CreateProfile(ProfileMock::H11344_Mock)
			@prodapp.SetGeneralSettings(ProfileMock::H11344_Mock)			
		}
		it "Verifies Profile is Created" do
	    	# sleep 2
			expect(@prodapp.VerifyProfileExists(ProfileMock::H11344_Mock["Profile_Name"])).to eq(true)			
			# expect(false).to eq(true)
		end
	end
# =begin		
		it 'verify double click opens the profile' do
			# double click on the profile name
			# profile should be opened as a tab 
		end
# =end
# =begin
  	context 'verify chnages in profile are saved' do
		before {
			# open profile
			# update load path
			# update destination path 
			
			# remove a load file field
		}
		it 'updated the load file path' do
		end 
		it 'removed the load file field' do
		end

	context 'create a new transform' do
		before {
			# create a new transform rule
		}
		it 'should be added to existing trasforms' do
		end 


	context 'create a profile' do
		before {
			# create a profile
			# Check Profile with same name doesnt exist
		}
		it 'checks the profile tab is red' do
			# verify the profile name is Red which indicates it has not been saved yet 
		end 		
		it 'should exist in open profile' do
			# Save Profile
			# Then click Open Profile and Verify it exists or has been added to the list
		end 

	context 'load fields from load file' do
		before {
			# Check source load file path is set
			# Click on Load Fields
		}
		it 'should compare fields' do
			# Verify fields on page with a Mock Object which contains the header of the load file fields			
		end 

	context 'verify elements on a profile' do
		before {
			# Open a Profile
		}
		it 'checks fields and transform tabs under Fields' do
			# Expect New Transform, Existing Transform, New Field and Load Fields to be visible
		end 
		it 'checks fields and transform tabs under Transforms' do
			# Expect New Transform, Existing Transform, New Field and Load Fields to be visible
		end 
		it 'checks Start Transform and Save Profile' do
			# Expext Start Transform and SaveProfile buttons are Visible
		end 

	context '' do
		before {}
		it '' do
		end 
  end
=end

  after(:each) do |example|
	if example.exception != nil
		#driver.save_screenshot "C:/RubyScripts/rspec/error.png"
	end
  end
end