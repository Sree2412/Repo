require 'lib/RelativityWorkspace'
require 'lib/Document'
require 'lib/InputData'
require_relative 'InputData'

class Apc < RelativityWorkspace
  include TestFramework
  include ApplicationNames
  #rowindex has been changed to just take the first APC number in the table
  def initialize
    @document = Document.new
  end

  def selectDocument
    self.iframe_main.table(:class => "itemListTable").wait_until_present
    selectDocument_checkbox = self.iframe_main.tr(:id=>"ctl00_ctl00_itemList_ctl00_ctl00_itemList_ROW0").tds[1]
    return selectDocument_checkbox
  end

  def SetAPCnumberToNil
    @document.SelectDocumentFirst
    @document.BulkEdit()
    $browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
    $browser.div(:id=>"_main").select_list(:id=>"LayoutDropdownList").select"Relativity Admin"
    $browser.ElementByCss("#dynamicViewRenderer_ctl01_ctl00", 420).click
    $browser.ElementByCss("#dynamicViewRenderer_ctl01_Removed_popupPickerButton").click
    end
    
    $browser.window(:index => 2).wait_until_present
    $browser.window(:index => 2).use do
    $browser.ElementByCss("#ctl06_VerticallySizableDiv").wait_until_present
    $browser.ElementByCss('#ctl00_Container_ctl00_itemList_itemListHead > td:nth-child(2) > input[type="checkbox"]').click
    $browser.ElementByCss("#ctl03_button").click #add
    sleep(2) # need this sleep
    $browser.ElementByCss("#ctl06_ctl03_button").click #set
    end

    $browser.window(:index => 1).use do
      #$browser.div(:id =>"_main").a(:id => "ctl01_button").wait_until_present(10)
      $browser.ElementByCss("#ctl01_button").click #save
      sleep(2) # need this sleep
      $browser.window(:index => 0).use
    end
  end

  def readAPCVal
    #self.selectDocument.wait_until_present    
    self.iframe_main.tr(:id=> "ctl00_ctl00_itemList_ctl00_ctl00_itemList_ROW0").tds[4].text    
  end

  def APCUpdateRun
    updateButton = self.tab_iFrame.a(:id => "btnUpdate")
    updateButton.wait_until_present
    updateButton.click
    self.tab_iFrame.span(:id => "updateStatus", :text => "Queued").wait_while_present
    self.tab_iFrame.span(:id => "updateStatus", :text => "Running").wait_while_present
    self.tab_iFrame.trs[1].span(:text => "Completed").wait_until_present(40)
    self.TabAccess(ApplicationNames::Documents)
    #$browser.div(:id => "horizontal-tabstrip").a(:text => "Documents").click
  end
  
  def CompareApcValueEquals(oldValue)
    Document.new.DocumentViewFolder("APC Update View")
    finalAPC = APC.new.readAPCVal
    puts "Value of APC Before APC Update Run:" + Org_APCnumber.to_s
    puts "Value of APC after APC Update Run:"  + finalAPC.to_s  
    if (oldValue.to_i == finalAPC.to_i)
      return true      
    else
      raise "APC Update Failed"
    end
  end

  def GetGroupIdentifier
     return self.iframe_main.tr(:id => "ctl00_ctl00_itemList_ctl00_ctl00_itemList_ROW0").tds[7].text
  end

end

