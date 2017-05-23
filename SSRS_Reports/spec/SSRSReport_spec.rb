require_relative  "spec_helper"
require_relative 'models/SSRSReports'
require_relative  'models/SSRSReportMock'
require 'open-uri'
require 'byebug'


describe "SSRS Reports Verification" do

  before {
  }


  context 'Navigate to Project Snapshot Report and ensure report is loading successfully and functioning as expected ' do
    before(:all){
      @url = SSRSReportUrl.const_get($env)
      $browser.goto @url
      @SSRSReports = SSRSReports.new
    }

    it "Report Home Page should display the expected title and report list" do

      expect(@SSRSReports.Reporthomepagevalidation).to be true
    end
  
    it "Navigate to Report Page and validate the Report screen, Refresh and PageNavigation Functionality " do

      @SSRSReports.Navigatetoreportpage(SSRSReportList::ReportName1)
      expect(@SSRSReports.ReportScreenVisibility).to be true
      @SSRSReports.Reportrefreshvalidation(SSRSReportList::ReportName1) 
      @SSRSReports.ReportpageNavigationvalidation(SSRSReportList::ReportName1)       
      @SSRSReports.Reportcolumvalidation(
        PSColumnList::Column1,
        PSColumnList::Column2,
        PSColumnList::Column3,
        PSColumnList::Column4,
        PSColumnList::Column5)    
         
    end
    
      
    it "Select the Report Parameters and validate the filter functionality" do

      @SSRSReports.ReportparametersValidation(SSRSReportList::ReportName1) 
    end
    



     it "validate PDF file size greater than 0KB" do
       expect(@SSRSReports.ReportPDFExportValidation()).to be > 0
     end

  end 

end 
 


    #(SSRSReportList::ReportName1

    #@Reports = SSRSReports.new
        #@Reports.Reportvalidation()
        # @Reports.Reportvalidation()
      #}


      #it "Report screen should display expected text and report list" do

        #expect(@Reports.Reporthomepagevalidation).to be true

      #end


      #it "Report should display expected text in the report page" do

        #expect(@Reports.ReportScreenVisibility).to be true

      #end


      #it "Report should display expected Parameter list in the home page" do

        #expect(@Reports.ReportParameterVisibility).to be true

      #end


      #it "validate PDF file size greater than 0KB" do

       #expect(@Reports.PDFFileSizeValidation).to be > 0

      #end

         



     #after do |example|
        #if example.exception != nil
          #driver.save_screenshot "C:/RubyScripts/rspec/error.png"
     #end    
     # end 
  

=begin

  it "PDF File Validation" do

     #@Reports.pdffilevalidation(SSRSReportPDF::TestFile1)

     expect(@Reports.pdffilevalidation).to eq("Review Test1")

       #@Reports.pdffilevalidation(SSRSReportPDF::TestFile1)

  end

=end
