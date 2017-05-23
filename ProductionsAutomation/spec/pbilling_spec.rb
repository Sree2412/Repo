require "spec_helper"
# require 'pry'
# require 'models/PrivLog'
require 'byebug'


describe "My Matters Page -" do
  
  before {
	$browser.goto "https://qa-hlmc.huronconsultinggroup.com/Finance/ProjectBilling?projectId=6862&selectedBillingFilter=04%2F2016"
	# $browser.goto "https://qa-hlmc.huronconsultinggroup.com/Finance/ContractTerms?projectId=1951"
	
  }

  context "whatever" do

  	it "click on project billing attachment add" do
  		$browser.div(:title, "Attachments").click
  		# byebug
			sleep 2
  		# $browser.a(:class, 'attachHeader').click
			# sleep 2
  		# byebug
  		$browser.file_field(:id, "fileToUpload").set('C:\Users\hparikh\Downloads\disable-write-protect.reg')
  		# byebug
  	end

 end

end