require 'rubygems'
require 'bundler/setup'
require 'byebug'
require 'lib/RelativityWorkspace'
require_relative 'InputData'

class Login_N_CreateNewWorkspace < RelativityWorkspace

	def relativityLogin(userName, password)
		$browser.text_field(:id=>"_email").wait_until_present.set(userName)
    $browser.button(:id=>"continue").click
    $browser.text_field(:id=>"_password__password_TextBox").wait_until_present.set(password)
    $browser.button(:id=>"_login").click
    iframe_main.table(:class=>"itemListTable").wait_until_present(60)
  end

 	def createNewWorkspace(workspaceName, clientName, matterName)
 		iframe_main.a(:text=>"New Workspace").click
 		$browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__name_textBox_textBox").set(workspaceName)
 		$browser.input(:id=>"_editTemplate__kCuraScrollingDiv__client_pick").click
 		$browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
  	 $browser.td(:text=>clientName).parent.radio.set
     $browser.a(:id=>"_ok2_button").click
    end
    $browser.input(:id=>"_editTemplate__kCuraScrollingDiv__matter_pick").wait_until_present.click
    $browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
    	$browser.td(:text=>matterName).parent.radio.click
    	$browser.a(:id=>"_ok2_button").click
    end
   	$browser.input(:id=>"_editTemplate__kCuraScrollingDiv__template_pick").wait_until_present.click
   	$browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
    	$browser.td(:text=>"kCura Starter Template").parent.radio.click
    	$browser.a(:id=>"_ok2_button").click
    end
    $browser.select_list(:id => "_editTemplate__kCuraScrollingDiv__resourceGroup_dropDownList").select "Default"
    $browser.select_list(:id => "_editTemplate__kCuraScrollingDiv__defaultDocumentLocation_dropDownList").options[1].select
    $browser.select_list(:id => "_editTemplate__kCuraScrollingDiv__defaultCacheLocation_dropDownList").options[1].select
    $browser.a(:id=> "_editTemplate_save1_button").click
 	end

 	def newWorkspaceCreated(workspaceName)
 		iframe_main.table(:class=>"itemListTable").wait_until_present(60)
 		return iframe_main.td(:text=>workspaceName).exists? 		
 	end

 	def getfieldName(parentIdName, searchField)
 		SelectSearchName93(parentIdName, searchField)
 		return $browser.tr(:id=>"_name").tds[1].text		
 	end

 	def addSmokeGroup(workspaceAdmin_tab, groupName)
 		get_WorkspaceAdmin_tab(workspaceAdmin_tab)
 		$browser.a(:id=>"_viewTemplate__kCuraScrollingDiv__manageWorspacePermissions_anchor").wait_until_present.click    
		$browser.window(:index => 1).wait_until_present
   	$browser.window(:index => 1).use do
      $browser.a(:id=>"_addremovegroups",:class=>"button primary").wait_until_present.click
   	end
    $browser.window(:index => 1).wait_until_present
	  $browser.window(:index => 1).use do
      sleep 4
      $browser.span(:text=> groupName).parent.wait_until_present.click          
	    $browser.span(:text => "Add (1)").wait_until_present.click
	    $browser.button(:id=>"_addRemoveSaveButton").span(:class => "ui-button-text",:text=>"Save").click
   	end
   	$browser.window(:index => 1).wait_until_present
	  $browser.window(:index => 1).use do
	  	$browser.div(:id=>"toast-container").div(:class=>"toast-message").wait_while_present
	  	$browser.div(:id=>"content-main").span(:text=>groupName).parent.parent.spans[1].a(:text=>"Preview").click
   	end
  end

	def previewNoticationExists
		return $browser.table(:id=>"Table1").td(:text=>"Previewing as group: Smoke Group").exists?
	end

	def firstTabName
		return $browser.div(:id=>"horizontal-tabstrip").as[0].text
	end

	def otherTabsExists
		return $browser.div(:id=>"horizontal-tabstrip").li(:class=>"relativity-tab horizontal-tab ng-scope active").as[3].exists?
	end

	def returnsToWorkspaceDetails
		$browser.input(:id=>"EndPreviewSessionButton").click
		$browser.div(:id=>"_main").wait_until_present
		return $browser.div(:id=>"_viewTemplate__kCuraScrollingDiv").h2(:text=>"Workspace Information").exists?
	end

end



