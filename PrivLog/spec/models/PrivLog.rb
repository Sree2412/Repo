require 'rubygems'
require 'bundler/setup'
require_relative 'mocks/PrivLogMock'


#require 'Automation-Common'

class PrivLog	
	include TestFramework
	include PrivLogUrl
	include PrivLogEnum
	include PrivLogSampleData
	include PrivLogTestFiles
	include PrivLogUIElements


# Data Manipulation

	def ClicktoSort(column)
		$browser.div(:text, "#{column}").click
	end

	def GetTable
		#$browser.table(:class, 'table').hashes
		#.hashes does not work, theoretically because header and table values are in two separate tables
		#solution -> get header in one array, table in another and merge to form hash
		headers = $browser.tables(:class, 'table')[0].to_a[0][1..-1]
		table_values_raw = $browser.tables(:class, 'table')[1].to_a[1..-1]
		table_values = table_values_raw.transpose[1..-1].transpose
		table = []
		table_values.each do |rows|
			table << Hash[headers.zip(rows.each)]
		end
		return table
	end

	def SelectFilters
		$browser.div(:class, 'btn')[3].click
	end


# Error Handling

	def ClickUploadButton
		$browser.link(:text, "Upload").click	
	end

	def DismissError
		$browser.button(:text, 'OK').click
	end

	def ErrorModalAbsent
		$browser.div(:text, 'Error').wait_while_present
		$browser.div(:class, 'modal-backdrop').wait_while_present
	end

	def ErrorModalPresent
		$browser.div(:text, 'Error').wait_until_present
	end

	def GetErrorText
		$browser.div(:class, 'bootstrap-dialog-message').text
	end

	def RemoveFile
		$browser.button(:title, 'Clear selected files').click
	end

	def UploadFile(filename)
		$browser.file_field(:id, "file-upload").set(filename)
	end

	def VerifyErrorText(errortext)
		$browser.div(:text, "#{errortext}").visible?
	end

# Export Options

	def ExportPage
		$browser.button(:text, "Export File >>").click
	end

	def ExportFile
		#Dir.mkdir "#{Dir.pwd}/spec/models/downloads"
		$browser.button(:text, "ExportFile").click
	end

	def AttorneyIndicator(character)
		$browser.text_field(:id, "is-attorney").set("#{character}")
	end

	def NameDelimiter(character)
		$browser.text_field(:id, "name-delimiter").set("#{character}")
	end

	def SetFirstLast
		$browser.radio(:id, "first-last").set
	end

	def SetFirstUnderscoreLast
		$browser.radio(:id, "first-underscore-last").set
	end



# File Upload

	def ProcessUploadedFile(filename)
		#Upload the file
		$browser.file_field(:id,"file-upload").set(filename)
		#Click the upload button
		$browser.link(:text, "Upload").click
		#Verify upload processed
		$browser.button(:text, "Export File >>").wait_until_present
	end

# Processed File Data Updates


	def ClickOnRow(id)
		$browser.td(:title, "#{id}").click
	end

	def EditRow
		#$browser.button(:id, 'edit_edit-entries-grid').click
		$browser.div(:class, 'btn').click
		#browser.divs(:class, 'btn')[0].click - this works too
		$browser.span(:text, 'Edit Record').wait_until_present
	end

	def UpdateRow(field,input)
		#Fields include FirstName, MiddleName, or LastName
		$browser.text_field(:id, "#{field}").set("#{input}")
	end

	def SetIsAttorney
		$browser.checkbox(:id, 'IsAttorney').set
	end

	def ClearIsAttorney
		$browser.checkbox(:id, 'IsAttorney').clear
	end

	def SubmitEdit
		$browser.span(:text, 'Submit').click
		sleep 1
		#$browser.span(:text, 'Edit Record').wait_until_present.wait_while_present
	end

	def CancelEdit
		$browser.span(:text, 'Cancel').click
		#$browser.span(:text, 'Edit Record').wait_while_present
	end

	def RefreshGrid
		$browser.divs(:class, 'btn')[2].click		
	end

	def OpenFilters
		$browser.divs(:class, 'btn')[3].click	
	end

	def FilterFirstName(input)
		input << "\n"
		$browser.text_field(:name, 'FirstName').set(input)
	end

	def ToggleEditPrevious
		$browser.a(:id, 'pData').click
	end

	def ToggleEditNext
		$browser.a(:id, 'nData').click
	end

	def GetRowData(id, field)
		# Find row, then parent, then find elements I want to select
		#if firstname then $browser.td(:title, '95').parent.tds[4].text
		return $browser.td(:title, "#{id}").parent.tds[PrviLogEnum.FirstName].text if field == 'FirstName'
		return $browser.td(:title, "#{id}").parent.tds[PrivLogEnum::MiddleName].text if field == 'MiddleName'
		return $browser.td(:title, "#{id}").parent.tds[PrivLogEnum::LastName].text if field == 'LastName'
		#if middlename then $browser.td(:title, '95').parent.tds[5].text
		#if lastname then $browser.td(:title, '95').parent.tds[6].text
		#find something else to do for attorney
		#$browser.td(:title, "#{id}").parent.td
	end

	def GetIsAttorney(id)
		return $browser.td(:title, "#{id}").parent.i.class_name
	end

end

