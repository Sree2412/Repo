require_relative 'models/mocks/ProdAppMock'
require 'spec_helper'
require 'models/Navigate'
require 'byebug'

describe "VerficationTest" do
    before {  				
	    @url = ProdAppUrl.const_get($env)			
			$browser.goto @url	  	
			@profile = Navigate.new
    }

    # This test should encompass a lot of element verification when we load on the page first time   
		context 'verify elements on a profile' do
		before {
				# Navigate to Home Page
				sleep 2
		}
		it 'Verifies Open/New Profile and SaveAll are Visible' do
			# Verify Open Profile, Create Profile and Save All are Visible
			# byebug				
			expect($browser.ElementByCss('.glyphicon-folder-open').visible?).to eq(true)		
			expect($browser.ElementByCss('.glyphicon-plus-sign').visible?).to eq(true)			
			expect($browser.ElementByCss('.glyphicon-floppy-disk').visible?).to eq(true)
		end
		
		it 'checks fields and transform tabs under Fields' do
				# Expect New Transform, Existing Transform, New Field and Load Fields to be visible
		end
		it 'checks fields and transform tabs under Transforms' do
				# Expect New Transform, Existing Transform, New Field and Load Fields to be visible
		end 
		it 'checks Start Transform and Save Profile' do
				# Expext Start Transform and SaveProfile buttons are Visible
		end
				
	end 
	
	context 'Open Profile Element Verification' do
		before {
			# Click on Open Profile
			$browser.ElementByCss('.glyphicon-folder-open').click
			sleep 2
		}
		it 'Checks if Title Text, Filter, Open and Close Buttons are visible' do	
			expect($browser.ElementByCss('.modal-title').text).to eq("Open Profile")
			expect($browser.ElementByCss('.glyphicon-filter').visible?).to eq(true)
			expect($browser.ElementByCss('.form-control').placeholder).to eq("Filter Term")
			# expect($browser.ElementByCss('.glyphicon-filter').text).to eq("Filter")
			expect($browser.ElementByCss('.btn-success').visible?).to eq(true)
			expect($browser.ElementByCss('.btn-success').text).to eq("Open")
			expect($browser.ElementByCss('.btn-primary').visible?).to eq(true)
			expect($browser.ElementByCss('.btn-primary').text).to eq("Cancel")
			$browser.button(:text => "Cancel").click					
		end
	end
	
	context 'Create Profile Element Verification' do
		before{
			$browser.ElementByCss('.glyphicon-plus-sign').click
			sleep 2
		}
		it 'Checks if Title Text, Create and Cancel Buttons are visible' do
			expect($browser.ElementByCss('.modal-title').text).to eq("New Profile")
			expect($browser.ElementByCss('.btn-success').visible?).to eq(true)
			expect($browser.ElementByCss('.btn-success').text).to eq("Create")
			expect($browser.ElementByCss('.btn-primary').visible?).to eq(true)
			expect($browser.ElementByCss('.btn-primary').text).to eq("Cancel")
			$browser.button(:text => "Cancel").click		
		end
	end

  after(:each) do |example|
	if example.exception != nil
		#driver.save_screenshot "C:/RubyScripts/rspec/error.png"
	  end
  end
end