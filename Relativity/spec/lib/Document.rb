require 'rubygems'
require 'bundler/setup'
require 'TestFramework'
require 'lib/RelativityWorkspace'
require 'byebug'

class Document < RelativityWorkspace
	include TestFramework

  def DocumentViewFolder(foldername)
   	self.iframe_main.when_present.select_list(:id=>"ctl00_viewsDropDown").when_present.option(:text =>foldername).select
  end

  def BulkAction(action)
    self.iframe_main.select_list(:name=>"ctl00$checkedItemsAction").select "Checked"
    self.iframe_main.select_list(:name=>"ctl00$checkedItemsActionToTake").select action
    self.iframe_main.a(:text => "Go").click
  end

  def BulkEdit()
  	self.iframe_main.select_list(:name=>"ctl00$checkedItemsAction").select "Checked"
  	self.iframe_main.select_list(:name=>"ctl00$checkedItemsActionToTake").select"Edit"
  	self.iframe_main.a(:text => "Go").click
	end

	def SelectDocumentFirst
		$browser.iframe(:id=>'ListTemplateFrame').checkbox(:id=>'checkbox_0').click #selecting the first document in the workspace folder All Document 
	end

	def OpenBulkDialog(selection, action) #checked, all or these
		$browser.ElementByCss("#ctl00_checkedItemsAction").SelectByText(selection) #selection like all or checked or these 1000
		$browser.ElementByCss("ctl00_checkedItemsActionToTake").SelectByText(action) #action like either edit, or move or delete
		$browser.ElementByCss("#ctl00_ctl04_button").click
	end

	def SetBulkEditCustId(value)
		$browser.ElementByCss("#dialogId").wait_until_present
		$browser.ElementByCss("#LayoutDropdownList").SelectByText("Document Metadata")
		$browser.ElementByCss("#dynamicViewRenderer_ctl01_pick").when_present.click
		#return $browser.ElementByCss("#radio_#{value}")
		$browser.ElementByCss("#_oneListPicker_ctl00_itemList_listTable > tbody > tr:eq(%s) > td:eq(1) > input"%value).click
		$browser.ElementByCss("#_oneListPicker_ctl03_button").click #set the custid
	end

	def Save
		# click save button
		#if messageexists
		#return false
		#elsif
		#return true

		$browser.ElementByCss("#ctl01_button").when_present.click
		return $browser.ElementByCss("#ctl04")== nil
	end

	def GetDocumentById(documentId)
		#$browser.GetCssInFrame("ListTemplateFrame", "#ctl00_ctl00_itemList_listTable > tbody > tr > td:nth-child(6):contains(%s)"%documentId)
		#using the td, get the parent tr and transform into json object
	end

	def GetDocumentByIndex(index)
		# using(var = EnterFrame.new(:id => 'ListTemplateFrame'))
		# {
		return $browser.GetCssInFrame("ListTemplateFrame", "#ctl00_ctl00_itemList_listTable > tbody > tr:eq(%s)"%index)
		# }
	end

	def DocumentRowToObject(row)
		values = Hash.new
		values["DocumentID"] = $browser.ByChildCss(row, "td:eq(6)").text
		values["CustID"] = $browser.ByChildCss(row, "td:eq(10)").text
		return values
	end

	def GetGroupIdentifierID(rowindex)
    return self.iframe_main.tr(:id => "ctl00_ctl00_itemList_ctl00_ctl00_itemList_ROW#{rowindex}").tds[7].text
  end

  # def codeDocResponsive(workspaceName, controlNumber, layoutName)
  # 	begin FrameScope.new("ListTemplateFrame")
  # 		sleep 4
  # 		$browser.ElementByCss('#ctl00_ctl00_itemList_ctl00_ctl00_itemList_ROW0 > td:nth-child(2) > a', 5)
  # 		#$browser.ElementByCss('#ctl00_ctl00_itemList_listTable', 5)
  # 		puts "framescope worked"
  # 		sleep 4
  # 		#$browser.ElementByCss('#ctl00_ctl00_itemList_listTable > td:contains(%s) > a' % workspaceName, 10).click
		# 	$browser.ElementByCss('#ctl00_ctl00_itemList_ctl00_ctl00_itemList_ROW0 > td:nth-child(2) > a', 5).click
		# 	sleep 4
		# 	byebug
		# 	$browser.ElementByCss('#ctl00_ctl00_itemList_listTable > td:nth-child(5) > a:contain(%s)' % controlNumber, 10).click
  # 		$browser.ElementByCss('#_documentIdentifier_ReviewLabel", span:contains(%s)' % " "+controlNumber, 5)
  # 	end
  # 	begin FrameScope.new("_profileAndPaneCollectionFrameselect_list")
  # 		$browser.ElementByCss('#_documentProfileEditor_layoutDropdown > option:contains(%s)' % layoutName, 5)
  # 		#$browser.select_lisDot(:id => "_documentProfileEditor_layoutDropdown").select(:text => layoutName)
  # 		$browser.ElementByCss("_documentProfileEditor_edit2_button", 5).click
  # 		$browser.ElementByCss('#_documentProfileEditor_save2_button', 5).click
  # 	end
  # end



  def codeDocResponsive(layoutName, code)
  	#self.SelectSearchName93(controlNumber, name)
  	iframe_document = $browser.iframe(:id=>"_documentViewer__viewerFrame")
  	iframe_document.div(:id=>"page.1").wait_until_present(25)
  	iframe_docProfile = $browser.iframe(:id=>"_profileAndPaneCollectionFrame").iframe(:id=>"_documentProfileFrame")
  	iframe_docProfile.select_list(:id=>"_documentProfileEditor_layoutDropdown").select layoutName
  	iframe_docProfile.a(:id=> "_documentProfileEditor_edit1_button").click
  	sleep 3
  	iframe_docProfile.td(:text=>code).parent.radio.set
  	iframe_docProfile.a(:id=>"_documentProfileEditor_save2_button").click
  	sleep 2
  	$browser.table(:id=>"Documentreviewcontextnavigator1__contextTable").span(:text=>"Return to document list").click
  	sleep 2
  	if $browser.alert.exists? == true
  		$browser.alert.ok#take it off after you uncomment the save)
		end
		iframe_main.table(:id=>"ctl00_ctl00_itemList_listTable").wait_until_present(10)
  end

  def createSummaryReport(reportName)
  	$browser.span(:class=>"quickNavIcon").click
  	$browser.text_field(:id=>"ctl30_ctl30_ctl03").set "Summary"
  	$browser.a(:title=>"Summary Reports").wait_until_present.click
  	iframe_main.a(:text=>"New Summary Report").wait_until_present(500).click
  	$browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__name_textBox_textBox").wait_until_present.set reportName
  	$browser.select_list(:id=>"_editTemplate__kCuraScrollingDiv__reportOnSubfolders_booleanDropDownList__dropDownList").select "Yes"
  	$browser.a(:text=>"Add Columns").click
  	$browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
    	$browser.a(:id=>"_reportFields_itemList_FilterSwitch").click
    	$browser.text_field(:id=>"_reportFields_itemList_FILTER-WC[DisplayName]").set "Smoke Designation"
    	$browser.send_keys(:return)
    	table_contents = $browser.table(:id=>"_reportFields_itemList_listTable")
    	table_contents.wait_until_present
    	table_contents.td(:text=>"Smoke Designation: (not set)").parent.checkbox.click
    	table_contents.td(:text=>"Smoke Designation: Smoke Responsive").parent.checkbox.click
    	$browser.a(:id=>"_save_button").click
    	sleep 3
    end
    $browser.a(:id=>"_editTemplate_save1_button").click
  end

  def summaryReportCount
  	$browser.table(:id=>"_viewTemplate__kCuraScrollingDiv__report_itemList_listTable").wait_until_present
  	table_result = $browser.table(:id=>"_viewTemplate__kCuraScrollingDiv__report_itemList_listTable").hashes
  	return table_result[0]["Smoke Designation: Smoke Responsive"]
  end


  	

	#def CustIDSetNULL
	#pick one document
	#record the custid
	#click on check mark
	#drop down on edit
	#click on go
	#drop down on document metadata
	#click on clear if available, else click on input, pick an arbitrary number
	#record that arbitrary number
	#click on save
	#should take us back to the main workspace documents page
	#end
end

