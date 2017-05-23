
class APC

  def initialize
    @workspace = RelativityWorkspace.new
    @document = Document.new
  end

  def selectDocument(rowindex)
    @workspace.iframe_main.table(:class => "itemListTable").wait_until_present
    selectDocument_checkbox = @workspace.iframe_main.tr(:id=>"ctl00_ctl00_itemList_ctl00_ctl00_itemList_ROW#{rowindex}").tds[1]
    return selectDocument_checkbox
  end

  def SetAPCnumberToNil(rowindex)
    self.selectDocument(rowindex).click
    @document.BulkEdit()
    
    BROWSERR.window(:index => 1).wait_until_present(10)
    BROWSERR.window(:index => 1).use do
      BROWSERR.div(:id=>"_main").select_list(:id=>"LayoutDropdownList").select"Relativity Admin"
      @workspace.byCss("#dynamicViewRenderer_ctl01_ctl00").click
      @workspace.byCss("#dynamicViewRenderer_ctl01_Removed_popupPickerButton").click
    end
    
    BROWSERR.window(:index => 2).wait_until_present
    BROWSERR.window(:index => 2).use do
      @workspace.byCss("#ctl06_VerticallySizableDiv").wait_until_present
      @workspace.byCss('#ctl00_Container_ctl00_itemList_itemListHead > td:nth-child(2) > input[type="checkbox"]').click
      @workspace.byCss("#ctl03_button").click #add
      sleep(2) # need this sleep
      @workspace.byCss("#ctl06_ctl03_button").click #set
    end

    BROWSERR.window(:index => 1).use do
      BROWSERR.div(:id =>"_main").a(:id => "ctl01_button").wait_until_present(10)
      @workspace.byCss("#ctl01_button").click #save
      sleep(2) # need this sleep
      BROWSERR.window(:index => 0).use
   end
  end

  def readAPCVal(rowindex)
    self.selectDocument(rowindex).wait_until_present    
    @workspace.iframe_main.tr(:id=> "ctl00_ctl00_itemList_ctl00_ctl00_itemList_ROW#{rowindex}").tds[3].text    
  end

  def APCUpdateRun
    updateButton = @workspace.tab_iFrame.a(:id => "btnUpdate")
    updateButton.wait_until_present
    updateButton.click
    @workspace.tab_iFrame.span(:id => "updateStatus", :text => "Queued").wait_while_present
    @workspace.tab_iFrame.span(:id => "updateStatus", :text => "Running").wait_while_present
    @workspace.tab_iFrame.span(:id => "updateStatus", :text => "Completed").wait_until_present(40)
    BROWSERR.div(:id => "horizontal-tabstrip").a(:text => "Documents").click
  end
  
  def CompareApcValueEquals(oldValue, rowindex)
    Document.new.DocumentViewFolder("APC Update View")
    finalAPC = APC.new.readAPCVal(rowindex)
    puts "Value of APC Before APC Update Run:" + Org_APCnumber.to_s
    puts "Value of APC after APC Update Run:"  + finalAPC.to_s  
    if (oldValue.to_i == finalAPC.to_i)
      return true      
    else
      raise "APC Update Failed"
    end
  end

  def GetGroupIdentifier(rowindex)
     return @workspace.iframe_main.tr(:id => "ctl00_ctl00_itemList_ctl00_ctl00_itemList_ROW#{rowindex}").tds[7].text
  end

end

