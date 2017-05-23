require 'rubygems'
require 'bundler/setup'
require 'byebug'
require 'lib/RelativityWorkspace'
require_relative 'InputData'

class AutomationSmokeTest < RelativityWorkspace

	def createSmokeClient(clientName)
  	$browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)' % 'Clients', 3).click
		self.iframe_main.div(:id=>"_main").a(:title=>"New Client").click
		$browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__name_textBox_textBox").set clientName
		$browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__number_textBox_textBox").set Time.now.to_i
		$browser.select_list(:id=>"_editTemplate__kCuraScrollingDiv__status_dropDownList").select "Active"
    sleep 3
    $browser.a(:id=> "_editTemplate_save1_button").click
    byebug
	end

	def createSmokeMatter(matterName)
		$browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)' % "Matters", 3).click
		self.iframe_main.div(:id=>"_main").a(:title=>"New Matter").click
		$browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__name_textBox_textBox").set matterName
		$browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__number_textBox_textBox").set Time.now.to_i
		$browser.select_list(:id=>"_editTemplate__kCuraScrollingDiv__status_dropDownList").select "Active"
		ElementByCss('#_editTemplate__kCuraScrollingDiv__client_pick', 3).click
		$browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
      $browser.td(:text=>CreateSmokeItems::Client).parent.tds[0].wait_until_present.click
			$browser.ElementByCss('#_ok2_button').wait_until_present.click
		end
		$browser.a(:id=> "_editTemplate_save1_button").wait_until_present.click
    byebug
	end

	def createSmokeUser(firstName, lastName, email, newpassword)
		$browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)' % "Users", 3).click
		self.iframe_main.div(:id=>"_main").a(:title=>"New User").click
		$browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__firstName_textBox_textBox").set firstName
		$browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__lastName_textBox_textBox").set lastName
		$browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__emailAddress_textBox_textBox").set email
		ElementByCss('#_editTemplate__kCuraScrollingDiv__client_pick', 3).click
		$browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
    	$browser.td(:text=>CreateSmokeItems::Client).parent.tds[0].wait_until_present.click
			$browser.ElementByCss('#_ok2_button').wait_until_present.click
		end
		$browser.input(:id=>"_editTemplate__kCuraScrollingDiv__password_radioButtonListField_radioButtonList_2").wait_until_present.click
		sleep 2
    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__newPassword__passwordTextBox__password_TextBox"). set newpassword
		$browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__retypePassword__passwordTextBox__password_TextBox"). set newpassword
		$browser.a(:id=> "_editTemplate_save1_button").click
		sleep 1
		$browser.alert.ok
		sleep 1
    byebug
	end

	def createSmokeGroup(groupName)
		$browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)' % "Groups", 3).click
		self.iframe_main.div(:id=>"_main").a(:title=>"New Group").wait_until_present.click
		$browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__name_textBox_textBox").set groupName
		ElementByCss('#_editTemplate__kCuraScrollingDiv__client_pick', 3).wait_until_present.click
		$browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
      $browser.td(:text=>CreateSmokeItems::Client).parent.tds[0].wait_until_present.click
      sleep 2
			$browser.ElementByCss('#_ok2_button').wait_until_present.click
		end
    sleep 3
		$browser.a(:id=> "_editTemplate_save1_button").wait_until_present.click
    byebug
	end

	def addUserToGroup(fullUserName, groupName)
    byebug
		$browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)' % "Users", 3).click
		iframe_main.table(:id=>"ctl00_viewRenderer_itemList_listTable").td(:text=>CreateSmokeItems::FullName).a.wait_until_present.click
		$browser.ElementByCss('#_viewTemplate__kCuraScrollingDiv__groups_itemList_ctl10_anchor', 3).wait_until_present.click
		$browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
    	$browser.td(:text=>CreateSmokeItems::GroupName).parent.tds[0].wait_until_present.click
    	$browser.td(:text=>"System Administrators").parent.tds[0].wait_until_present.click
    	$browser.ElementByCss('#_ok2_button').click
    end
	end

	def createNewField(fieldName, fieldType)
    $browser.div(:id=>"horizontal-subtabstrip").a(:text=>"Fields").wait_until_present.click
    iframe_main.a(:text =>"New Field").wait_until_present.click
    $browser.select_list(:id=>"_editTemplate__objectType_dropDownList").select "Document"
    $browser.text_field(:id=>"_editTemplate__name_textBox_textBox").set fieldName
    $browser.select_list(:id=>"_editTemplate__type_dropDownList").select fieldType
    $browser.select_list(:id=>"_editTemplate__isRequired_booleanDropDownList__dropDownList").select "No"
    $browser.select_list(:id=>"_editTemplate__allowGroupBy_booleanDropDownList__dropDownList").select "Yes"
    $browser.alert.ok
    $browser.select_list(:id=>"_editTemplate__allowPivot_booleanDropDownList__dropDownList").select "Yes"
    $browser.alert.ok
    $browser.a(:id=>"_editTemplate_save1_button").wait_until_present.click
    sleep 3
  end

  def createNewChoices(choiceName1, choiceName2, fieldName)
    $browser.div(:id=>"horizontal-subtabstrip").a(:text=>"Choices").wait_until_present.click
    iframe_main.a(:text =>"New Choice").wait_until_present.click
    sleep 2
    $browser.select_list(:id=>"_editTemplate__kCuraScrollingDiv__type_dropDownList").select fieldName+" (Document)"
    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__name_textBox_textBox").set choiceName1
    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__order_int32TextBox_textBox").set "10"
    sleep 5
    $browser.checkbox(:id=>"_editTemplate__kCuraScrollingDiv__keyboardShortcut__ctrl_Checkbox").click
    $browser.checkbox(:id=>"_editTemplate__kCuraScrollingDiv__keyboardShortcut__ctrl_Checkbox").click
    sleep 1
    $browser.checkbox(:id=>"_editTemplate__kCuraScrollingDiv__keyboardShortcut__alt_Checkbox").click
    sleep 1
    $browser.select_list(:id=>"_editTemplate__kCuraScrollingDiv__keyboardShortcut__key_DropDownList").select "R"
    sleep 1
    $browser.a(:id=>"_editTemplate_saveAndNew1_button").wait_until_present.click
    sleep 3
    $browser.select_list(:id=>"_editTemplate__kCuraScrollingDiv__type_dropDownList").select fieldName+" (Document)"
    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__name_textBox_textBox").set choiceName2
    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__order_int32TextBox_textBox").set "20"
    $browser.a(:id=>"_editTemplate_save1_button").wait_until_present.click
    sleep 3
  end

  def createNewLayout(layoutName, fieldName)
    $browser.div(:id=>"horizontal-subtabstrip").a(:text=>"Layouts").wait_until_present.click
    iframe_main.a(:text =>"New Layout").wait_until_present.click
    $browser.select_list(:id=>"_editTemplate__kCuraScrollingDiv__objectType_dropDownList").select "Document"
    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__name_textBox_textBox").set layoutName
    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__order_int32TextBox_textBox").set "10"
    $browser.radio(:id=>"_editTemplate__kCuraScrollingDiv__copyfromprevious__radioButtonList_radioButtonList_0").set
    $browser.a(:id=>"_editTemplate_save1_button").wait_until_present.click
    $browser.a(:id=>"_viewTemplate__kCuraScrollingDiv__buildLayout_anchor").wait_until_present.click
    sleep 5
    iframe_layout.div(:class=>"fieldsArea ng-scope").click
    panel = iframe_layout.div(:class=>"ng-binding", :text=>fieldName)
    target = iframe_layout.div(:class=>"emptyField marginTop10")
    $browser.driver.action.click_and_hold(panel.wd).perform
    $browser.driver.action.move_to(target.wd).perform
    target.fire_event "onmouseup"
    iframe_layout.select_list.select "Radio Button List"
    label_pristine = iframe_layout.text_field(:class=>"marginRight3 ng-pristine ng-valid ng-scope ng-touched")
    label_dirty = iframe_layout.text_field(:class=>"marginRight3 ng-valid ng-scope ng-touched ng-dirty ng-valid-parse")
    if label_pristine.exists?
      label_pristine.set fieldName
    else
      label_dirty.set fieldName
    end
    iframe_layout.div(:class=>"artifactsViewTemplateHeader alignCenter").button(:text=>"Save and Close").click
  end

  def setFields(fieldName)
  	$browser.select_list(:id=>"_view__wizardTemplate__kCuraScrollingDiv__twoList_ListOneBox").select fieldName
  	$browser.a(:id=>"_view__wizardTemplate__kCuraScrollingDiv__twoList_MoveSelectedToTwo_anchor").span.click
  end

  def setConditions(fieldName, operator, value)
  	$browser.select_list(:id=>"_view__wizardTemplate__kCuraScrollingDiv__criteriaGroup_ViewCriteriaNum0_CriteriaField").select "Smoke Designation"
  	sleep 1
  	$browser.select_list(:id=>"_view__wizardTemplate__kCuraScrollingDiv__criteriaGroup_ViewCriteriaNum0_CodeOperator").select "any of these"
  	$browser.input(:id=>"_view__wizardTemplate__kCuraScrollingDiv__criteriaGroup_ViewCriteriaNum0_CodeValue_Pick").click
  	$browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
    	$browser.td(:text=>WorkspaceElements::ChoiceName1).parent.checkbox(:id=>"checkbox_0").set
    	sleep 1
    	$browser.a(:text=>"Add").click
    	sleep 1
    	$browser.a(:text=>"Set").click
    end
    $browser.a(:text=>"Save").click
  end

  def createNewView(viewName, fieldName, operator, value)
  	$browser.div(:id=>"horizontal-subtabstrip").a(:text=>"Views").wait_until_present.click
    iframe_main.a(:text =>"New View").wait_until_present.click
    $browser.text_field(:id=>"_view__wizardTemplate__kCuraScrollingDiv__name_textBox_textBox").set viewName
    $browser.select_list(:id=>"_view__wizardTemplate__kCuraScrollingDiv__artifacts_dropDownList").select "Document"
    $browser.select_list(:id=>"_view__wizardTemplate__kCuraScrollingDiv__visualizationType_dropDownList").select "Standard List"
    $browser.a(:text=>"Next").wait_until_present.click
    self.setFields("Edit")
    self.setFields("Control Number")
    self.setFields("Smoke Designation")
    self.setFields("Group Identifier")
    $browser.a(:text=>"Next").wait_until_present.click
    self.setConditions(fieldName, operator, value)
  end

  def createSearchProfile(folderName)
  	iframe_folder.img(:id=>"_paneCollection_searchContainer_Icon").wait_until_present.click
  	iframe_main.a(:id=>"_newSearch_button").wait_until_present.click
  	iframe_main.label(:text=>"Selected Folders").parent.radio.set
  	iframe_main.a(:text=>"Select Folders").click
  	$browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
    	$browser.span(:text=>folderName).parent.checkbox.set
    	$browser.a(:id=>"_ok_button").click
    end
    iframe_main.select_list(:id=>"_twoList_ListOneBox").select "Has Images"
    iframe_main.a(:id=>"_twoList_MoveSelectedToTwo_anchor").span.click
    iframe_main.select_list(:id=>"_twoList_ListOneBox").select "Extracted Text"
    iframe_main.a(:id=>"_twoList_MoveSelectedToTwo_anchor").span.click
    iframe_main.a(:id=>"_saveAndSearchButton_button").click
   end

  def savedSearchResultCount
  	iframe_main.table(:id=>"ctl00_ctl00_itemList_listTable").wait_until_present
   	return iframe_main.table(:id=>"ctl00_ctl00_itemList_listTable").trs.count
  end

  def viewResponsiveDocs(viewName)
  	iframe_folder.img(:id=>"_paneCollection_folder_Icon").wait_until_present.click
  	iframe_paneCollection.span(:text=>WorkspaceElements::FolderName).click
  	iframe_main.select_list(:id=>"ctl00_viewsDropDown").select viewName
  end

  def verifyResponsiveDocuments
  	return iframe_main.table(:id=>"ctl00_ctl00_itemList_listTable").trs.count
  end

  def verifyResponsiveDocumentsInclFamily
  	 iframe_main.select_list(:id=>"ctl00_FamilyDropdown").select "Include Family"
  	 iframe_main.table(:id=>"ctl00_ctl00_itemList_listTable").tr.wait_until_present
  	 return iframe_main.table(:id=>"ctl00_ctl00_itemList_listTable").trs.count
  end

  def getGroupNameElement(groupName)
  	iframe_main.table(:id=>"ctl00_viewRenderer_itemList_listTable").wait_until_present
  	return iframe_main.table(:id=>"ctl00_viewRenderer_itemList_listTable").td(:text=>groupName)
  end

  def delete_Group(groupName)
  	$browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)' % "Groups", 3).click
  	getGroupNameElement(groupName).parent.td.click
  	iframe_main.div(:id=>"ctl00_BottomActionBar").select_list.select "Delete"
  	iframe_main.a(:id=>"ctl00_go_button").click
  	$browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
    	$browser.a(:id=>"_ok_button").click
    end
  end

  def delete_User
  	
  end

  def delete_Workspace
  	
  end
end
