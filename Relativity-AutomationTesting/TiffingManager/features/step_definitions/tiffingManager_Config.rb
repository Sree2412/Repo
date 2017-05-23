@tiffing_config

#Scenario: Access Tiff Manager page
When (/^I click on TiffingManager Tab$/) do
	go_to_tiff_manager_page
end

Then (/^I should be in the Tiffing Manager Tab$/) do
	((BROWSERR.iframe(:id=>"_externalPage").div(:class=>"page-header").text)=="TIFFing Configuration").should be true
end

#Scenario: Tiffing Configuration
Given (/^I am in the Tiffing Manager Tab$/) do
	((BROWSERR.iframe(:id=>"_externalPage").div(:class=>"page-header").text)=="TIFFing Configuration").should be true
end

When (/^I delete all existing TIFFing configurations$/) do
	remove_configurations
end

Then (/^I should be able to set responsive equal to responsive$/) do
	tiff_configuration1("Responsive", "Equal", "Responsive")
end

Then  (/^I should be able to set privilege equal to privileged$/) do
	tiff_configuration2("Privilege", "Equal", "Privileged")
end

Then (/^I should be able to set Has Images equal to no$/) do
	tiff_configuration3("Has Images", "Equal", "No")
end

#Scenario: QC Sampling Set up
Given (/^I have the QC Sampling Rate$/) do
	((BROWSERR.iframe(:id=>"_externalPage").div(:class=>"col-lg-4").fieldsets[1].legend.text)=="QC Sampling Rate").should be true
end

When (/^I delete all existing file for QC Sampling Rate except the default$/) do
	remove_fileTypeSampleRate
end

Then (/^I should be able to set the QC Sampling Rate at 25% for default, 50% for msg and 50% for doc$/) do
	qc_sampling1("msg", "50", "doc", "50")
end

#Scenario: Slipsheet set up
Given (/^I have the Slipsheets$/) do
	((BROWSERR.iframe(:id=>"_externalPage").div(:class=>"col-lg-7").fieldsets[0].legend.text)=="Slipsheets").should be true
end

When (/^I delete all existing Slipsheets except the default$/) do
	remove_slipsheets
end

Then (/^I should be able to set up the "Custom Filtered File" with message "tiffs for excel files are suppressed"$/) do
	set_new_slipsheet1("Custom Filtered File", "tiffs for pptx files are suppressed")
end

Then (/^I should be able to select where in the page the message would appear: choosing "Center"$/) do
	BROWSERR.iframe(:id=>"_externalPage").div(:class=>"col-lg-7").select_list(:id=>"rptSlipsheets_ctl01_rptLines_ctl00_ddlJustification").when_present.select_value("Center")
end

#Scenario: Filtered File Types set up
Given (/^I have the Filter File Types$/) do
	((BROWSERR.iframe(:id=>"_externalPage").div(:class=>"col-lg-5").fieldsets[0].legend.text)=="Filtered File Types").should be true
end

When (/^I delete all existing filtered file types$/) do
	remove_filteredFileTypes
end

Then (/^I should be able to set pdf files to default Error Sheet slipsheet$/) do
	set_default_filteredFileType("pdf")
end

Then (/^I should be able to set xls files to custom Error sheet "Custom Filtered File"$/) do
	set_filteredFileType1("xls", "Custom Filtered File")
end

#Scenario: Imaging Set
Given (/^I have saved the changes$/) do
	#byebug
	#uncomment below line when ready to run
	#BROWSERR.iframe(:id=>"_externalPage").input(:id=>"btnSaveGlobal").when_present.click
end

When (/^I Enable Imaging$/) do
	#byebug
	#BROWSERR.iframe(:id=>"_externalPage").input(:id=>"btnEnableImaging").when_present.click
end

Then (/^I should be able to Run Image Set$/) do
	#byebug
	#BROWSERR.iframe(:id=>"_externalPage").input(:id=>"btnRunImagingSet").when_present.click
end

