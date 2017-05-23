require_relative '../models/ProdAppMock'
require_relative '../spec/spec_helper'
require 'rubygems'
require 'bundler/setup'
require 'byebug'

class ProfileTest  
	include Consilio::TestFramework
	# include ProdAppMock

	def OpenProfile(profile_name)
		if self.VerifyProfileExists(profile_name) == true
			$browser.a(:class => "list-group-item", :text => profile_name).click
			$browser.button(:text => 'Open').click
		else
			self.CreateProfile(profile_name)
			puts "Creating Profile: " + profile_name + "as it did not Exist"
		end
	end

	def CreateProfile(mock)
		# $browser.ElementByCss('.glyphicon-folder-open').click
		# Verifies if Profile Name exists, if it does it appends current datetime to the profile_name(like "H11824_MMDDYYYYHHMMSS")
		puts "Mock Profile Name:" + mock["ProfileName"]		
		if self.VerifyProfileExists(mock["ProfileName"]) == true			
			mock["ProfileName"] = self.SetUniqueName(mock["ProfileName"])
			puts mock["ProfileName"]
		end		
		# body > div.bootbox.modal.fade.in > div > div > div.modal-footer > button.btn.btn-primary
		$browser.div(:class => 'modal-footer').button(:text => 'Cancel').click		
		$browser.ElementByCss('.glyphicon-plus-sign').when_present.click		
		$browser.text_field(:placeholder => 'Profile Name').set mock["ProfileName"]	
		$browser.ElementByCss('.btn-success').when_present.click		
		self.SetGeneralSettings(mock)		
		byebug		
		$browser.a(:text => ' Save ').click		
	end

	def Save(name)		
		$browser.a(:text => 'General').wait_until_present.click
		$browser.ElementByCss('#production-tabs > div > ul > li:nth-child(1) > a').click		
		return $browser.span(:text => 'Profile Saved Successfully').wait_until_present.exists?
	end
	
	def SetUniqueName(name)
		# Append Current DataTime in MMDDYYHHMMSS to the name user has passed
		time = (((Time.now).strftime("%m-%d-%y_%H:%M:%S")).to_s).delete!('- :+')
		# x = (time.to_s).delete!('- :+')			
		return [name, time].join('_')		 	
	end

	def SetGeneralSettings(data)
		if data["Source"] != nil
			$browser.text_field(:placeholder => "Source Load File Path").wait_until_present.set data["Source"]
		end
		if data["Destination"] != nil
			data["Destination"] = self.SetUniqueName(data["Destination"]) + '\\Output.dat'
			puts data["Destination"]
			$browser.text_field(:placeholder => "Destination Load File Path").wait_until_present.set data["Destination"]
		end		
		if data["TextColumn"] != nil
			$browser.select_list(:id => "listid1").option(:text => data["TextColumn"]).set 
		end
		if data["NativeColumn"] != nil
			$browser.select_list(:id => "listid2").option(:text => data["NativeColumn"]).set
		end
		if ($browser.a(:text => 'Save & Close').exists?) == true
			 $browser.a(:text => 'Save & Close').click
		elsif ($browser.a(:text => 'Save').exists?) == true
			 $browser.a(:text => 'Save').click
		end
		return data["Destination"]
	end
	
	def VerifyProfileExists(profile_name)
		$browser.ElementByCss('.glyphicon-folder-open').wait_until_present.click
		$browser.a(:class => "list-group-item", :text => profile_name).wait_until_present
		if $browser.a(:class => "list-group-item", :text => profile_name).exists? == true
			return true
		end
	end

	def AddFields
		$browser.button(:text => 'Fields').click
		$browser.span(:class => 'glyphicon glyphicon-remove').wait_until_present.click # Click Remove All Fields Button 
		# $browser.span('glyphicon glyphicon glyphicon-open-file').wait_until_present.click # Click Load Fields Button 
		$browser.span(:class => 'glyphicon glyphicon-plus').wait_until_present.click # Click New Field Button 
		# $browser.button(:text => 'Clear All').wait_until_present.click
	end
	
	def CreateField(field_name, dest_field_name)
		$browser.span(:class => 'glyphicon glyphicon-plus').wait_until_present.click # Click New Field Button
		$browser.text_field(:placeholder => 'Field Name').when_present.set field_name
		$browser.text_field(:placeholder => 'Destination Field Name').when_present.set dest_field_name
		$browser.button(:text => 'Create').wait_until_present.click
		$browser.button(:text => 'Create').wait_while_present
		return $browser.span(:text => field_name + ' -> ' + dest_field_name).exists?		
	end

	def RemoveExistingTransforms		
		$browser.button(:text => 'Transforms').wait_until_present.click
		while $browser.span(:title => 'Remove Transform').exists? == true do			
			$browser.span(:title => 'Remove Transform').wait_until_present.click					
		end
	end

	def AddGroup(name, transform)
		$browser.button(:text => 'Transforms').wait_until_present.click		
		$browser.ElementByCss('#production-tabs > div > div.tab-content.inherit-height.col-sm-9 > div.tab-pane.inherit-height.active > div:nth-child(2) > div.col-sm-8.no-gutter > div.btn-group.col-sm-12.no-gutter > button.btn.btn-default.add-group > span.glyphicon.glyphicon-plus').click
		sleep 1
		$browser.span(:text => name).wait_until_present.click
		$browser.button(:text => 'Add').wait_until_present.click
		$browser.button(:text => 'Add').wait_while_present
		return $browser.span(:text => transform).exists?
	end

	def MatchTransforms(field, dest, transform)
		$browser.button(:text => 'Fields').wait_until_present.click	
		$browser.span(:text => field + ' -> ' + dest).click		
		$browser.span(:text => transform).parent.div.click
		return $browser.span(:text => transform).parent.div(:class => 'checked').exists?
	end 

=begin
	def CompareOutputToMock(output_file_path, mock_obj)
		file = File.open(output_file_path, "r:UTF-8"){|f| f.read }
		m = 0
		file.each_line do |line|	
			line = (line.to_s).delete!('þ')
			row = (line.to_s).split('')		
			# test = (line1.to_s).delete!('þ')
			# puts (test == mock)
			n = 0
			row.each do |element|
				# puts element.gsub(/\s+/, "") # Prints current element with trimmed white space
				# puts (mock_obj[m][n]).gsub(/\s+/, "") # Prints current element with trimmed white space
				if (element.gsub(/\s+/, "") != (mock_obj[m][n]).gsub(/\s+/, ""))
					puts "Transformed File Value does not Match Mock Data"
				end
				n = n + 1		
			end
			m = m + 1
		end
		return true
	end

	def NavigateToProfile(profile_name)		
        $browser.ElementByCSS('.glyphicon-folder-open').click		
		if self.VerifyProfileExists(profile_name) == true
			# click on Profile Name
			# click Create
			puts "Found Project Code"
			$browser.a(:class => "list-group-item", :text => profile_name).click
			$browser.button(:text => "Open").click
			return true		
		end		
		return false				
	end
				
	# def CreateProfile(new_profile_name)		
	# end
	
	# def SetLoadFilePath(path)	
	# end
			
	def LoadFieldsFromFile
		# Call Self.VerifyLoadFilePathIsSet
		# If True then Click Load Fields
		# Verify Fields are same as the header of the load file		
	end	
	def AddField(field_name)
		# Create a New Field	
	end
=end	
end