require_relative 'includes'

class ProjectsPage

  def SearchProject(projectname)
    $browser.text_field(:id=>"fl-input-1").set projectname
    byebug
    # $browser.ElementByCss("#projectsToolbar > div > span.ng-scope.flex > md-autocomplete > md-autocomplete-wrap > md-input-container").click
    $browser.ElementByCss().click
		$browser.text_field(:id=>"").set projectname
		$browser.text_field(:id=>"").set Time.now.to_i
		$browser.select_list(:id=>"").select "Active"
    $browser.a(:id=> "_editTemplate_save1_button").click
  end

  def VerifyTitles
    # Verify Project Name
    # Verify Matter Name
    # Verify ProjectStatus
    # Verify ServiceLine
    # Verify Requestor
    # Verify Client Name
  end

  def VerifyDataClientEntries
  # Verify ID
  # Verify Name
  # Verify SegregationType
  end  
 
  def ExportData
  #  Export data and Save 
  end 

  def ListSettings
  # Select fields to be dispalyed on the DataClientsPage
  # Verify fields are displayed
  end 
end