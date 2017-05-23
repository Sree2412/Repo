
require 'rubygems'
require 'bundler/setup'
require 'byebug'
require_relative 'SSRSReportMock'


class SSRSReports

  def Reporthomepagevalidation  
    
    $browser.div(:css =>"#s4-titlerow > div.BreadCrumbWrap.s4-notdlg").wait_until_present.visible?

  end       

  def Navigatetoreportpage(name1)
  
    $browser.a(:text => name1).wait_until_present(10).click
    sleep 3
    $browser.div(:text => name1).wait_until_present(10).visible?
    sleep 3
  end  
  
  def ReportScreenVisibility

    $browser.div(:text => "Enron - Nuix 6.2").wait_until_present(10).visible? 
    $browser.div(:text => "H12568").wait_until_present(10).visible?
  end
  
  def Reportrefreshvalidation(name1)
    
    $browser.div(:id => "m_sqlRsWebPart_RSWebPartToolbar_ctl00_RptControls_ctl00_ctl00_ctl00").wait_until_present(20).click
    $browser.div(:text=> name1).visible? 
    sleep 2
  end 

 
  def ReportpageNavigationvalidation(name1)

    $browser.input(:title => "Next Page").wait_until_present(30).click 
    $browser.input(:title => "Previous Page").wait_until_present(30).click 
    $browser.input(:title => "Last Page").wait_until_present(30).click 
    $browser.span(:text => "Data Received:").wait_until_present(30).visible?
    $browser.span(:text => "Ingested:").wait_until_present(30).visible?
    $browser.span(:text => "Filtered:").wait_until_present(30).visible?
    $browser.span(:text => "Hosted:").wait_until_present(30).visible?
    $browser.span(:text => "Review Population:").wait_until_present(30).visible? 
    $browser.input(:title => "First Page").wait_until_present(50).click
    sleep 2 
    $browser.div(:text=> name1).visible? 
    sleep 4
   
  end 

  def Reportcolumvalidation(column1,column2,column3,column4,column5)
    sleep 4
    $browser.td(:text=> column1).visible?  
    $browser.td(:text=> column2).visible?    
    $browser.div(:text=> column3).visible?    
    $browser.div(:text=> column4).visible?  
    $browser.div(:text=> column5).visible?
    sleep 4
  end 

  def ReportparametersValidation(name1)
   sleep 4
   $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_ddDropDownButton").click  
   sleep 2  
   $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_divDropDown_ctl00").clear  
   sleep 2
   $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_divDropDown_ctl01").set 
   sleep 3
   $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_ddDropDownButton").click  
   sleep 3
   $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_ddDropDownButton").click 
   sleep 3
   $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_divDropDown_ctl00").clear
   sleep 3 
   $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_divDropDown_ctl01").set
   $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_divDropDown_ctl02").set
   $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_divDropDown_ctl03").set
   $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_divDropDown_ctl04").set
   $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_divDropDown_ctl05").set
   sleep 3 
   $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_ddDropDownButton").click  
   sleep 3
   $browser.input(:name => "m_sqlRsWebPart$ctl00$ctl19$ApplyParameters").click   
   sleep 3 
   $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_ddDropDownButton").click  
   sleep 3 
   $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_divDropDown_ctl00").set 
   sleep 3
   $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_ddDropDownButton").click   
   sleep 3
   $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_ddDropDownButton").click 
   sleep 3 
   $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_divDropDown_ctl00").set 
   sleep 3
   $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_ddDropDownButton").click 
   sleep 3
   $browser.input(:name => "m_sqlRsWebPart$ctl00$ctl19$ApplyParameters").click   
   sleep 3 
   $browser.div(:text=> name1).visible? 
   sleep 3
   
  end

  def ReportPDFExportValidation
  
   $browser.img(:class => "ms-viewselector-arrow").click
   sleep 3
   $browser.a(:id=> "mp1_0_1_Anchor").click
   sleep 3
   $browser.span(:text=> "PDF").click
   sleep 3
   return File.size("#{Dir.pwd}/spec/models/downloads/Project Snapshot.pdf") 
   sleep 5 
  end
  
   

  # def PDFFileSizeValidation
  
  # return File.size("#{Dir.pwd}/spec/models/downloads/Project Snapshot.pdf") 

  # end


end 


# def ReportPDFExportValidation

    #   #validate export to PDF functionality
    #   sleep 2
    #   $browser.div(:id => "m_sqlRsWebPart_RSWebPartToolbar_ctl00_RptControls_RSActionMenu_ctl01_t").visible?
    #   sleep 2
    #   $browser.img(:class => "ms-viewselector-arrow").visible?
    #   sleep 2
    #   $browser.img(:class => "ms-viewselector-arrow").click
    #   sleep 2
    #   $browser.a(:id=> "mp1_0_1_Anchor").visible?
    #   sleep 2
    #   $browser.a(:id=> "mp1_0_1_Anchor").click
    #   sleep 2

    #   $browser.span(:text=> "PDF").visible?
    #   sleep 2

    #   $browser.span(:text=> "PDF").click

    #   #byebug
    #   sleep 3

    #   end


    #   def PDFFileSizeValidation


    #      return File.size("#{Dir.pwd}/spec/models/downloads/Project Snapshot.pdf")

    #      #File.exists?("#{Dir.pwd}/spec/models/downloads/Project Snapshot.pdf")
    #    end
    



    



    #   def ReportParameterVisibility

    #     #Report Paramter text validation
    #     $browser.td(:id=> "m_sqlRsWebPart_ctl00_ctl19_TitleCell").visible?
    #     #Report Include section text validation
    #    $browser.span(:css => "#ParameterTable_m_sqlRsWebPart_ctl00_ctl19_ctl06 > tbody > tr:nth-child(1) > td > span").visible?
    #    #Report expanded section text validation
    #    $browser.span(:css => "#ParameterTable_m_sqlRsWebPart_ctl00_ctl19_ctl06 > tbody > tr:nth-child(4) > td > span").visible?
    #    #Report Include Custodians section text validation
    #    $browser.span(:css => "#ParameterTable_m_sqlRsWebPart_ctl00_ctl19_ctl06 > tbody > tr:nth-child(7) > td > span").visible?
    #   #Report Include Highlighting section text validation
    #    $browser.span(:css => "#ParameterTable_m_sqlRsWebPart_ctl00_ctl19_ctl06 > tbody > tr:nth-child(10) > td > span").visible?

    # end



    # def Reportrefreshvalidation
    #        #validate Refresh Button Functionality
    #   $browser.div(:id => "m_sqlRsWebPart_RSWebPartToolbar_ctl00_RptControls_ctl00_ctl00_ctl00").click
    #   sleep 2
    #   #Validate Report Name after refresh
    #   $browser.div(:text => "Project Snapshot").visible?
    #   sleep 3
    #   #validate the report-table after refresh
    #   #$browser.table(:class => "P2e1f50d725434c229426f75880dc062e_11_r18").visible?
    # end


    # def ReportpageNavigationvalidation

    #  #Navigate to Next Page
    #   $browser.table(:title => "Next Page").visible?
    #   $browser.table(:title => "Next Page").click
    #   #Navigate to First Page
    #   sleep 3
    #  $browser.input(:id => "m_sqlRsWebPart_RSWebPartToolbar_ctl00_RptControls_PageNav_First_ctl00_ctl00").click
    #  sleep 2
    #  #$browser.table(:class => "P2e1f50d725434c229426f75880dc062e_11_r18").visible?
    #   #Navigate to Last Page
    #  $browser.input(:id => "m_sqlRsWebPart_RSWebPartToolbar_ctl00_RptControls_PageNav_Last_ctl00_ctl00").click
    #  sleep 2
    # $browser.input(:id => "m_sqlRsWebPart_RSWebPartToolbar_ctl00_RptControls_PageNav_First_ctl00_ctl00").click
    #  #$browser.td(:id => "P2e1f50d725434c229426f75880dc062e_7_514").visible?
    #  sleep 2
    # end


    # def Reportparameterselection

    # #validate Include sections parameter function
    #     $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_ddDropDownButton").visible?
    #     $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_ddDropDownButton").click
    #     sleep 3
    #     #Clear all the selected list
    #     $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_divDropDown_ctl00").visible?
    #     $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_divDropDown_ctl00").clear
    #     sleep 3
    #     $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_divDropDown_ctl01").visible?
    #     $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_divDropDown_ctl01").set
    #     sleep 3
    #     $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_ddDropDownButton").click
    #     sleep 3
    #     # checking true Radiobutton
    #     #$browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl05_rbTrue").click

    #     # checking 'Include Custodian' dropdown list box
    #     $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_ddDropDownButton").visible?
    #     $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_ddDropDownButton").click
    #     sleep 3
    #     # clearing the list of all custodians
    #     $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_divDropDown_ctl00").visible?
    #     $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_divDropDown_ctl00").clear
    #     sleep 3

    #     # Selecting all the Custodian values
    #      $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_divDropDown_ctl01").set
    #      $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_divDropDown_ctl02").set
    #      $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_divDropDown_ctl03").set
    #      $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_divDropDown_ctl04").set
    #      $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_divDropDown_ctl05").set


    #     #Closing the dropdownlist box
    #     $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_ddDropDownButton").click

    #     sleep 3
    #     $browser.input(:name => "m_sqlRsWebPart$ctl00$ctl19$ApplyParameters").click
    #     sleep 5

    #     $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_ddDropDownButton").visible?
    #     sleep 3
    #     $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_ddDropDownButton").click

    #     sleep 3
    #     #Clear all the selected list
    #     $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_divDropDown_ctl00").visible?
    #     sleep 3
    #     $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_divDropDown_ctl00").set
    #     sleep 3
    #     $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_ddDropDownButton").click

    #     sleep 3
    #     # clearing all the parameter selection

    #     $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_ddDropDownButton").visible?
    #     $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_ddDropDownButton").click
    #     sleep 3
    #      # checking select all option
    #     $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_divDropDown_ctl00").visible?
    #     $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_divDropDown_ctl00").set
    #     #$browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_divDropDown_ctl00").clear
    #     sleep 3

    #     $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_ddDropDownButton").click
    #     sleep 3

    #     $browser.input(:name => "m_sqlRsWebPart$ctl00$ctl19$ApplyParameters").click
    #     sleep 3

    #   end




    # def ReportPDFExportValidation

    #   #validate export to PDF functionality
    #   sleep 2
    #   $browser.div(:id => "m_sqlRsWebPart_RSWebPartToolbar_ctl00_RptControls_RSActionMenu_ctl01_t").visible?
    #   sleep 2
    #   $browser.img(:class => "ms-viewselector-arrow").visible?
    #   sleep 2
    #   $browser.img(:class => "ms-viewselector-arrow").click
    #   sleep 2
    #   $browser.a(:id=> "mp1_0_1_Anchor").visible?
    #   sleep 2
    #   $browser.a(:id=> "mp1_0_1_Anchor").click
    #   sleep 2

    #   $browser.span(:text=> "PDF").visible?
    #   sleep 2

    #   $browser.span(:text=> "PDF").click

    #   #byebug
    #   sleep 3

    #   end


    #   def PDFFileSizeValidation


    #      return File.size("#{Dir.pwd}/spec/models/downloads/Project Snapshot.pdf")

    #      #File.exists?("#{Dir.pwd}/spec/models/downloads/Project Snapshot.pdf")
    #    end




=begin



       def XMLFileSizeValidation


          return File.size("#{Dir.pwd}/spec/models/downloads/Project Snapshot.XML")

          #File.exists?("#{Dir.pwd}/spec/models/downloads/Project Snapshot.XML")
        end



        def EXECLFileSizeValidation


           return File.size("#{Dir.pwd}/spec/models/downloads/Project Snapshot.EXCEL")

           #File.exists?("#{Dir.pwd}/spec/models/downloads/Project Snapshot.EXCEL")
         end


         def MHTMLFileSizeValidation


            return File.size("#{Dir.pwd}/spec/models/downloads/Project Snapshot.MHTML")

            #File.exists?("#{Dir.pwd}/spec/models/downloads/Project Snapshot.MHTML")
          end


          def CSVFileSizeValidation


             return File.size("#{Dir.pwd}/spec/models/downloads/Project Snapshot.CSV")

             #File.exists?("#{Dir.pwd}/spec/models/downloads/Project Snapshot.CSV")
           end


           def FileSizeValidation


              return File.size("#{Dir.pwd}/spec/models/downloads/Project Snapshot.pdf")

              #File.exists?("#{Dir.pwd}/spec/models/downloads/Project Snapshot.pdf")
            end


=end

    	#$browser.button(:text, "ExportFile").click

      #$browser.file_field(:id,"file-upload").set(filename)
      #$browser.link(:text, "Upload").click
      #$browser.button(:text, "Export File >>").wait_until_present



=begin



        def ReportCSVExportValidation

          #validate export to Excel functionality
          sleep 3
          $browser.div(:id => "m_sqlRsWebPart_RSWebPartToolbar_ctl00_RptControls_RSActionMenu_ctl01_t").visible?
          sleep 3
          $browser.img(:class => "ms-viewselector-arrow").visible?
          sleep 3
          $browser.img(:class => "ms-viewselector-arrow").click
          sleep 3
          $browser.a(:id=> "mp1_0_1_Anchor").visible?
          sleep 3
          $browser.a(:id=> "mp1_0_1_Anchor").click
          sleep 3
          $browser.span(:text=> "CSV").visible?
          sleep 3
          $browser.span(:text=> "CSV").click
          sleep 5
          end


          def ReportMHTMLExportValidation

            #validate export to Excel functionality
            sleep 3
            $browser.div(:id => "m_sqlRsWebPart_RSWebPartToolbar_ctl00_RptControls_RSActionMenu_ctl01_t").visible?
            sleep 3
            $browser.img(:class => "ms-viewselector-arrow").visible?
            sleep 3
            $browser.img(:class => "ms-viewselector-arrow").click
            sleep 3
            $browser.a(:id=> "mp1_0_1_Anchor").visible?
            sleep 3
            $browser.a(:id=> "mp1_0_1_Anchor").click
            sleep 3
            $browser.span(:text=> "MHTML").visible?
            sleep 3
            $browser.span(:text=> "MHTML").click
            sleep 5
            end

            def ReportExcelExportValidation
           #validate export to Excel functionality
              sleep 3
              $browser.div(:id => "m_sqlRsWebPart_RSWebPartToolbar_ctl00_RptControls_RSActionMenu_ctl01_t").visible?
              sleep 3
              $browser.img(:class => "ms-viewselector-arrow").visible?
              sleep 3
              $browser.img(:class => "ms-viewselector-arrow").click
              sleep 3
              $browser.a(:id=> "mp1_0_1_Anchor").visible?
              sleep 3
              $browser.a(:id=> "mp1_0_1_Anchor").click
              sleep 3
              $browser.span(:text=> "Excel").visible?
              sleep 3
              $browser.span(:text=> "Excel").click
              sleep 5
              end

              def ReportTiffExportValidation
             #validate export to Excel functionality
                sleep 3
                $browser.div(:id => "m_sqlRsWebPart_RSWebPartToolbar_ctl00_RptControls_RSActionMenu_ctl01_t").visible?
                sleep 3
                $browser.img(:class => "ms-viewselector-arrow").visible?
                sleep 3
                $browser.img(:class => "ms-viewselector-arrow").click
                sleep 3
                $browser.a(:id=> "mp1_0_1_Anchor").visible?
                sleep 3
                $browser.a(:id=> "mp1_0_1_Anchor").click
                sleep 3
                $browser.span(:text=> "TIFF file").visible?
                sleep 3
                $browser.span(:text=> "TIFF file").click
                sleep 5
                end


    end





=begin


byebug




mp2_1_2_Anchor
ms-viewselector-arrow
$browser.img(:class=> "ms-viewselector-arrow").visible?

$browser.span(:text=> "XML file with report data").visible?
sleep 3
$browser.span(:text=> "Excel").visible?
sleep 3
$browser.span(:text=> "Excel").click
sleep 3

byebug
$browser.div(:id => "m_sqlRsWebPart_ctl00_ReportViewer_ctl10").visible?
sleep 5
byebug
$browser.div(:id => "m_sqlRsWebPart_ctl00_ReportViewer_ctl10").click
sleep 3

      $browser.table(:title => "Next Page").visible?
      $browser.table(:title => "Next Page").click
      #Navigate to First Page
      sleep 2
     $browser.input(:id => "m_sqlRsWebPart_RSWebPartToolbar_ctl00_RptControls_PageNav_First_ctl00_ctl00").click
     sleep 2
     #$browser.table(:class => "P2e1f50d725434c229426f75880dc062e_11_r18").visible?
      #Navigate to Last Page
     $browser.input(:id => "m_sqlRsWebPart_RSWebPartToolbar_ctl00_RptControls_PageNav_Last_ctl00_ctl00").click
     sleep 2
     #$browser.td(:id => "P2e1f50d725434c229426f75880dc062e_7_514").visible?
     sleep 2
    end











end












  def ReportpageNavigationvalidation

   $browser.input(:id => "m_sqlRsWebPart_RSWebPartToolbar_ctl00_RptControls_PageNav_Last_ctl00_ctl00").click

  end
end



    $browser.a(:text => "Project Snapshot").click
       #$browser.ElementByCss('#onetidDoclibViewTbl0 > tbody > tr:nth-child(10) > td > a').click
    sleep 2
       #Validate Report Name
    $browser.div(:text => "Project Snapshot").visible?
     #Validate project Name
    $browser.div(:text => "Enron - Nuix 6.2").visible?
    #Validate project Number
    $browser.div(:text => "H12568").visible?
     sleep 2
     # Validate the Report Name
        #$browser.ElementByCss("Project Snapshot").text

    $browser.input(:id => "m_sqlRsWebPart_RSWebPartToolbar_ctl00_RptControls_PageNav_Last_ctl00_ctl00").click
    sleep 2
    $browser.div(:text => "Page 2 of 2").visible?

   $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_ddDropDownButton").click
    sleep 1

   $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_divDropDown_ctl00").clear
  #$browser.label(:text => "Intake").visible?
  #$browser.label("m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_divDropDown_ctl01").visible?
  sleep 1
   $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_divDropDown_ctl01").set
   sleep 1
   $browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_ddDropDownButton").click
    $browser.checkbox(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl03_divDropDown_ctl00").clear
    sleep 1

   sleep 1
   end



    def ReportVerification
      return "Review Test"
    end
$browser.input(:id => "m_sqlRsWebPart_ctl00_ctl19_ctl06_ctl07_ddDropDownButton").click


  #  def NavigateToReportPage

      #$browser.goto "%s/Project/Details?projectid=%s" % [@url, id]
      #binding.pry

      #$browser.ElementByCss(".BreadCrumbWrap").text



      #BROWSER.find_element(:class, 'BreadCrumbWrap').text
      #sleep 5

    #end
end
=end
