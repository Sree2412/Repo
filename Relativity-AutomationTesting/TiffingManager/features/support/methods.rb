def testworkspace(workspace_id, workspace_name)
	if 	Search_funnel_1.exists?
		Search_funnel_1.wait_until_present(10)
		Search_funnel_1.click
		BROWSERR.iframe(:id=>"ListTemplateFrame").text_field(:id=>"ctl00_viewRenderer_itemList_FILTER-BOOLEANSEARCH[Name]-T").set (workspace_id)
		BROWSERR.send_keys(:return)
		BROWSERR.iframe(:id=>"ListTemplateFrame").a(:text=> workspace_name).click
	elsif Search_funnel_2.exists?
		BROWSERR.iframe(:id=>"ListTemplateFrame").text_field(:id=>"ctl00_viewRenderer_itemList_FILTER-BOOLEANSEARCH[Name]-T").set (workspace_id)
		BROWSERR.send_keys(:return)
		BROWSERR.iframe(:id=>"ListTemplateFrame").a(:text=>workspace_name).click
	end
end

def go_to_tiff_manager_page
	begin
	Dropdown_tab.when_present.click
	rescue
	end
	sleep (1)
	Tiffing_tab.wait_until_present
	Tiffing_tab.click
end

def remove_configurations
	while	BROWSERR.iframe(:id=>"_externalPage").a(:id=>"rptConditions_ctl00_btnRemoveCondition").span.exists? do
			BROWSERR.iframe(:id=>"_externalPage").a(:id=>"rptConditions_ctl00_btnRemoveCondition").span.when_present.click
	end
end

def tiff_configuration1(criteria, operator, value)
	BROWSERR.iframe(:id=>"_externalPage").div(:class=>"AddCondition").a(:id=>"btnAddCondition").span.when_present.click
	BROWSERR.iframe(:id=>"_externalPage").div(:id=>"rptConditions_ctl00_divConditionContainer").when_present.select_list(:name=>"rptConditions$ctl00$ddlField").select(criteria)
	BROWSERR.iframe(:id=>"_externalPage").div(:class=>"form-group").select_list(:name=>"rptConditions$ctl00$ddlConditionType").when_present.select(operator)
	BROWSERR.iframe(:id=>"_externalPage").div(:class=>"form-group").select_list(:name=>"rptConditions$ctl00$ddlFieldValue").when_present.select(value)
end

def tiff_configuration2(criteria2, operator2, value2)
	BROWSERR.iframe(:id=>"_externalPage").div(:class=>"AddCondition").a(:id=>"btnAddCondition").span.when_present.click
	BROWSERR.iframe(:id=>"_externalPage").div(:id=>"rptConditions_ctl01_divConditionContainer").when_present.select_list(:name=>"rptConditions$ctl01$ddlField").select(criteria2)
	BROWSERR.iframe(:id=>"_externalPage").select_list(:name=>"rptConditions$ctl01$ddlConditionType").when_present.select(operator2)
	BROWSERR.iframe(:id=>"_externalPage").select_list(:name=>"rptConditions$ctl01$ddlFieldValue").when_present.select(value2)
end

def tiff_configuration3(criteria3, operator3, value3)
	BROWSERR.iframe(:id=>"_externalPage").div(:class=>"AddCondition").a(:id=>"btnAddCondition").span.when_present.click
	BROWSERR.iframe(:id=>"_externalPage").div(:id=>"rptConditions_ctl02_divConditionContainer").when_present.select_list(:name=>"rptConditions$ctl02$ddlField").select(criteria3)
	BROWSERR.iframe(:id=>"_externalPage").select_list(:name=>"rptConditions$ctl02$ddlConditionType").when_present.select(operator3)
	BROWSERR.iframe(:id=>"_externalPage").select_list(:name=>"rptConditions$ctl02$ddlFieldValue").when_present.select(value3)
end

def remove_fileTypeSampleRate
	while	BROWSERR.iframe(:id=>"_externalPage").a(:id=>"rptSampleRates_ctl00_btnRemoveFileType").span.exists? do
			BROWSERR.iframe(:id=>"_externalPage").a(:id=>"rptSampleRates_ctl00_btnRemoveFileType").when_present.span.click
	end
end

def qc_sampling1(filetype1, percentage1, filetype2, percentage2)
	BROWSERR.iframe(:id=>"_externalPage").div(:class=>"col-lg-4").a(:id=>"btnAddRate").span.when_present.click
	BROWSERR.iframe(:id=>"_externalPage").div(:class=>"col-lg-4").text_field(:id=>"rptSampleRates_ctl00_txtFileType").when_present.set filetype1
	BROWSERR.iframe(:id=>"_externalPage").div(:class=>"col-lg-4").text_field(:id=>"rptSampleRates_ctl00_txtFileTypeRate").when_present.set percentage1
	BROWSERR.iframe(:id=>"_externalPage").div(:class=>"col-lg-4").a(:id=>"btnAddRate").span.click
	BROWSERR.iframe(:id=>"_externalPage").div(:class=>"col-lg-4").text_field(:id=>"rptSampleRates_ctl01_txtFileType").when_present.set filetype2
	BROWSERR.iframe(:id=>"_externalPage").div(:class=>"col-lg-4").text_field(:id=>"rptSampleRates_ctl01_txtFileTypeRate").when_present.set percentage2
end

def remove_slipsheets
	while	BROWSERR.iframe(:id=>"_externalPage").a(:id=>"rptSlipsheets_ctl01_btnRemoveSlipsheet").span.exists? do
			BROWSERR.iframe(:id=>"_externalPage").a(:id=>"rptSlipsheets_ctl01_btnRemoveSlipsheet").span.when_present.click
	end
end

def remove_filteredFileTypes
	while	BROWSERR.iframe(:id=>"_externalPage").a(:id=>"rptFileExtensions_ctl00_btnRemoveExtension").span.exists? do
			BROWSERR.iframe(:id=>"_externalPage").a(:id=>"rptFileExtensions_ctl00_btnRemoveExtension").span.when_present.click
	end
end

def set_new_slipsheet1(slipsheet_name1, message1)
	BROWSERR.iframe(:id=>"_externalPage").div(:class=>"col-lg-7").a(:id=>"btnAddSlipsheet").span.when_present.click
	BROWSERR.iframe(:id=>"_externalPage").div(:class=>"col-lg-7").text_field(:id=>"rptSlipsheets_ctl01_txtSlipsheetName").when_present.set slipsheet_name1
	BROWSERR.iframe(:id=>"_externalPage").div(:class=>"col-lg-7").a(:id=>"rptSlipsheets_ctl01_btnAddSlipsheetLine").span.when_present.click
	BROWSERR.iframe(:id=>"_externalPage").div(:class=>"col-lg-7").text_field(:id=>"rptSlipsheets_ctl01_rptLines_ctl00_txtLineText").when_present.set message1
end

def set_default_filteredFileType(extension)
	BROWSERR.iframe(:id=>"_externalPage").div(:class=>"col-lg-5").a(:id=>"btnAddExtension").span.when_present.click
	BROWSERR.iframe(:id=>"_externalPage").div(:class=>"col-lg-5").text_field(:id=>"rptFileExtensions_ctl00_txtFileExtension").when_present.set extension
	BROWSERR.iframe(:id=>"_externalPage").div(:id=>"rptFileExtensions_ctl00_divFileExtension").select_list(:id=>"rptFileExtensions_ctl00_ddlSlipsheet").when_present.select_value("1")
end

def set_filteredFileType1(extension1, message1)
	BROWSERR.iframe(:id=>"_externalPage").div(:class=>"col-lg-5").a(:id=>"btnAddExtension").span.when_present.click
	BROWSERR.iframe(:id=>"_externalPage").div(:class=>"col-lg-5").text_field(:id=>"rptFileExtensions_ctl01_txtFileExtension").when_present.set extension1
	BROWSERR.iframe(:id=>"_externalPage").div(:id=>"rptFileExtensions_ctl00_divFileExtension").when_present.select_list(:id=>"rptFileExtensions_ctl00_ddlSlipsheet").select(message1)
end

