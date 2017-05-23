require "spec_helper"
require 'pry'
require 'models/PrivLog'
require 'byebug'

describe "PrivLog" do
  
 
  context 'Upload sample privlog file' do	

  	before(:all) {
    	@url = PrivLogUrl.const_get($env)
		$browser.goto @url
		@PrivLog = PrivLog.new
  	}

	   it "upload a valid file" do
		    @PrivLog.ProcessUploadedFile(PrivLogTestFiles::TestFile1)
     end

     it "update processed data" do
        expect(@PrivLog.GetRowData(95,'MiddleName')).to eq(" ")
        expect(@PrivLog.GetIsAttorney(95)).to eq(PrivLogUIElements::IsAttorneyUnchecked)
        @PrivLog.ClickOnRow(88)
        @PrivLog.EditRow
        @PrivLog.CancelEdit
        @PrivLog.ClickOnRow(95)
        @PrivLog.EditRow
        @PrivLog.ToggleEditPrevious
        @PrivLog.ToggleEditNext
        @PrivLog.UpdateRow('MiddleName','TestUpdate')
        @PrivLog.SetIsAttorney
        @PrivLog.SubmitEdit
        expect(@PrivLog.GetRowData(95,'MiddleName')).to eq('TestUpdate')
        expect(@PrivLog.GetIsAttorney(95)).to eq(PrivLogUIElements::IsAttorneyChecked)
	   end	

     it "manipulate table" do
        default_table = @PrivLog.GetTable
        email_asc_sort = default_table.sort_by { |k,v| k[' Email Address'] }
        @PrivLog.ClicktoSort('Email Address')
        expect(email_asc_sort). to eq(@PrivLog.GetTable)
        # filter table and compare
        @PrivLog.OpenFilters
        @PrivLog.FilterFirstName("B")
        expect(@PrivLog.GetTable).to eq(PrivLogSampleData::FilteredTable)
        @PrivLog.RefreshGrid
        # expect(default_table) = @PrivLog.GetTable
        expect(email_asc_sort). to eq(@PrivLog.GetTable)

     end
	
     it "tear down steps" do
        @PrivLog.ClickOnRow(95)
        @PrivLog.EditRow
        @PrivLog.UpdateRow('MiddleName',' ')
        @PrivLog.ClearIsAttorney
        @PrivLog.SubmitEdit
        expect(@PrivLog.GetRowData(95,'MiddleName')).to eq(' ')
        expect(@PrivLog.GetIsAttorney(95)).to eq(PrivLogUIElements::IsAttorneyUnchecked)
     end

     it "export file" do
        @PrivLog.ExportPage
        @PrivLog.ExportFile
        @PrivLog.SetFirstLast
        @PrivLog.AttorneyIndicator("!")
        @PrivLog.ExportFile
        @PrivLog.SetFirstUnderscoreLast
        @PrivLog.NameDelimiter("?")
        @PrivLog.ExportFile
        sleep 2
     end

    it "Compares .dat file to expected array" do
      input = File.open("#{Dir.pwd}/spec/models/downloads/PrivLogSample_Export.dat", "r:UTF-8")
      array = input.lines.map(&:split)
      input.close
      expect(array).to eq(PrivLogSampleData::Sample)
      input1 = File.open("#{Dir.pwd}/spec/models/downloads/PrivLogSample_Export (1).dat", "r:UTF-8")
      array1 = input1.lines.map(&:split)
      input1.close
      expect(array1).to eq(PrivLogSampleData::Sample1)
      input2 = File.open("#{Dir.pwd}/spec/models/downloads/PrivLogSample_Export (2).dat", "r:UTF-8")
      array2 = input2.lines.map(&:split)
      input2.close
      expect(array2).to eq(PrivLogSampleData::Sample2)
    end

  end

  context 'Upload some files that are illformatted' do

  	before(:all) {
    	@url = PrivLogUrl.const_get($env)
		$browser.goto @url
		@PrivLog = PrivLog.new
  }

  	it "Upload .txt file" do
  		@PrivLog.UploadFile(PrivLogTestFiles::ErrorFile1)
  		@PrivLog.ErrorModalPresent
  		expect(@PrivLog.VerifyErrorText('Oops! Unsupported file type. Please choose a CSV file.')).to be true
  		@PrivLog.DismissError
  		@PrivLog.ErrorModalAbsent
  		@PrivLog.RemoveFile
  	end

  	it "Upload a file missing an expected header" do
  		@PrivLog.UploadFile(PrivLogTestFiles::ErrorFile2)
  		@PrivLog.ClickUploadButton
  		@PrivLog.ErrorModalPresent
  		expect(@PrivLog.GetErrorText).to eq("An error occurred while importing the file. The header row in the uploaded file is missing the following required column(s):\n\nFrom\n\nPlease update the header row and try uploading again.")
  		@PrivLog.DismissError
  		@PrivLog.ErrorModalAbsent
  		@PrivLog.RemoveFile
  	end

  	it "Upload a file containing an extra header" do
  		@PrivLog.UploadFile(PrivLogTestFiles::ErrorFile3)
  		@PrivLog.ClickUploadButton
  		@PrivLog.ErrorModalPresent
  		expect(@PrivLog.GetErrorText).to eq("An error occurred while importing the file. The header row in the uploaded file has the following unrecognized column(s):\n\nfalseheader2\n\nThe expected columns are:\n\nDocumentID, From, To, CC, BCC\n\nPlease update the header row and try uploading again.")
  		@PrivLog.DismissError
  		@PrivLog.ErrorModalAbsent
  		@PrivLog.RemoveFile
  	end

  end


  after(:each) do |example|
	if example.exception != nil
		#driver.save_screenshot "C:/RubyScripts/rspec/error.png"
	  end
  end
end