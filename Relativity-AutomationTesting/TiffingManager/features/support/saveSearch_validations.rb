load 'features/support/RelativityWorkspace.rb'

class SavedSearch < RelativityWorkspace

  #attr_accessor :workspace, :allegory

  # def initialize(args={})
    #self.workspace = RelativityWorkspace.new
    #self.allegory = allegorymethod.new
    #
    #
  # end
  def NavigateToSavedSearch(saveSearchName)
  	self.browser.div(:id => 'transparentdimmerdiv').wait_while_present
  	self.SetElement(self.browser.iframe(:id=>"FolderFrame").td(:id=>"_paneCollection_iconCell").img(:id=>"_paneCollection_searchContainer_Icon")).Click
  	self.SetElement(self.browser.iframe(:id=>"FolderFrame").iframe(:id=>"_paneCollection_ctl03_searchContaineriFrame").span(:title => saveSearchName)).Click
  end

  def Verify_SavedSearch
    self.browser.iframe(:id=>"ListTemplateFrame").table(:id=>"ctl00_ctl00_itemList_listTable").exists? == true
  end

  def DocCount_in_SavedSearch
    $docs_Count = self.browser.iframe(:id=>"ListTemplateFrame").table(:id=>"ctl00_ctl00_itemList_listTable").trs.count
    self.Assert($docs_Count>1, "No Documents in the saved search", true)
    puts "Total number of documents in this saved search is:"
    puts $docs_Count
    #$array_row = self.browser.iframe(:id=>"ListTemplateFrame").execute_script("return $.map($('#ctl00_ctl00_itemList_listTable > tbody > tr'),function(element) {return $(element).text()})")
  end

  def GetSaveSearchTable
    return self.browser.iframe(:id=>"ListTemplateFrame").table(:id => 'ctl00_ctl00_itemList_listTable')
  end

  def GetSearchTableNumberRows()
    return self.browser.iframe(:id=>"ListTemplateFrame").trs(:css=>"#ctl00_ctl00_itemList_listTable > tbody > tr").length
  end

  def GetSearchTableColumnsByText(colIndex, text)
    #css = "#ctl00_ctl00_itemList_listTable > tbody > tr > td:nth-child(%s):contains(%s)" % [colIndex, text]
    return self.browser.iframe(:id=>"ListTemplateFrame").execute_script("return $('#ctl00_ctl00_itemList_listTable > tbody > tr > td:nth-child(%s):contains(%s)').length" % [colIndex, text])
  end

  def GetNumRowsByText(value)
    #return self.browser.iframe(:id=>"ListTemplateFrame").execute_script("return $('#ctl00_ctl00_itemList_listTable > tbody > tr').text()").filter(value, true).length
    return self.GetSaveSearchTable.GetRowsText.filter(value, true).length
  end

  def Verify_Config_Exists(value)
    self.Assert(self.GetNumRowsByText(value) > 0, "Value does not exist in table", true)
  end

  def Verify_Config_NotExists(value)
    self.Assert(self.GetNumRowsByText(value) == 0, "Value does exist in table", true)
  end

  def GetNumRowsByTwoFields(value, value2)
    #return self.browser.iframe(:id=>"ListTemplateFrame").execute_script("return $('#ctl00_ctl00_itemList_listTable > tbody > tr:contains(%s):contains(%s)').length" % value, value2)
    #array_row_double = self.browser.iframe(:id=>"ListTemplateFrame").execute_script("return $.map($('#ctl00_ctl00_itemList_listTable > tbody > tr'),function(element) {return $(element).text()})")
    return self.GetSaveSearchTable.GetRowsText.filter(value, true).filter(value2, true).length
  end

  def PercentageOfFileTypes(value, value2)
    percentageOfFileTypeWithQCSelected = (GetNumRowsByTwoFields(value, value2).to_f / GetNumRowsByText(value).to_f) * 100
    return percentageOfFileTypeWithQCSelected
  end

  def Verify_FileType_QCSelected(value, value2, percent)
    self.Assert(self.PercentageOfFileTypes(value, value2) == percent, "Value does exist in table", true)
  end

  def GetNumRowsByValuenotexist(value, value2)
    #array_row_notExists = self.browser.iframe(:id=>"ListTemplateFrame").execute_script("return $.map($('#ctl00_ctl00_itemList_listTable > tbody > tr'), function(element) {return $(element).text()})") 
    return self.GetSaveSearchTable.GetRowsText.remove(value, true).remove(value2, true).length
    #return self.browser.iframe(:id=>"ListTemplateFrame").execute_script("return $('#ctl00_ctl00_itemList_listTable > tbody > tr:not(:contains(%s):not:(contains(%s)))').length" % [value, value2])
  end

  def GetNumRowsByDefaultandQCSelected(value, value2, value3)
    return self.GetSaveSearchTable.GetRowsText.remove(value, true).remove(value2, true).filter(value3, true).length
    #return self.browser.iframe(:id=>"ListTemplateFrame").execute_script("return $('#ctl00_ctl00_itemList_listTable > tbody > tr:not(:contains(%s)):not(:contains(%s)):contains(%s))').length" % [value, value2, value3])
    
  end

  def PercentageOfDefaultQCSelected(value, value2, value3)
    percentageOfDefaultWithQCSelected = GetNumRowsByDefaultandQCSelected(value, value2, value3) / GetNumRowsByValuenotexist(value, value2) * 100
    return percentageOfDefaultWithQCSelected
  end

  def Verify_Default_FileType_QCSelected(value, value2, value3, percent)
    self.Assert(self.PercentageOfDefaultQCSelected(value, value2, value3) == percent, "Value does exist in table", true)
  end

end
















# def CellContainsAllValues(col1Index, col1Value, col2Index, col2Value)
#   totalCount = 0
#   AllfileTypeRows = #tr > td:nth-child(col1Index):contains(col1Value)
#   loop(row in AllFileTypeRows)
#     if row[col2Index] == col2Value
#       totalCount += 1
#     end
#   end
#   return totalCount
# end





#Assert(condition, message, stopExecution = false)
=begin
    begin
      $i = 0
      while $i<$docs_Count do
        if value == "Responsive" || value == "Privileged" 
          ((self.SetElement(self.browser.iframe(:id=>"ListTemplateFrame").table(:id=>"ctl00_ctl00_itemList_listTable").trs[$i].tds[row].text) ==value).should be true)
        elsif value == "Tiffed" || value == "Selected for QC" || value == "Passed QC" || value == "Failed QC" 
           ((self.SetElement(self.browser.iframe(:id=>"ListTemplateFrame").table(:id=>"ctl00_ctl00_itemList_listTable").trs[$i].tds[row].text) !=value).should be true)
        end
        $i=$i+1
      end
    rescue Exception => e
      if value == "Tiffed"
        puts == "Tiffed field error" 
      elsif value == "Responsive"
        puts "error responsive field"
      elsif value == "Privileged"
        puts "error privilege field"
      elsif value == "error TiffingQC"
        puts "error TiffingQC"
      elsif value == "Selected for QC" 
        puts "error with selected for QC"
      else
        puts "unknown error"
      end
      puts e
    end
  end
end
=begin
  def Verfiy_TiffingState_not_Tiffed
    begin
      $i = 0
      while $i<$docs_Count do
        tiffingState_value = self.SetElement(self.browser.iframe(:id=>"ListTemplateFrame").table(:id=>"ctl00_ctl00_itemList_listTable").trs[$i].tds[7].text)
        (tiffingState_value!='Tiffed').should be true
        #puts tiffingState_value
        $i=$i+1
      end
    rescue
    puts "error tiffingState field"
    end
  end
  def Verify_allDocs_Privilege
    begin
    $i = 0
      while $i<$docs_Count do
        ((self.SetElement(self.browser.iframe(:id=>"ListTemplateFrame").table(:id=>"ctl00_ctl00_itemList_listTable").trs[$i].tds[10].text) =="Privileged").should be true)
        $i=$i+1
      end
    rescue
    puts "error privilege field"
    end
  end

  def Verify_QC_Sampling
    begin
      $i = 0
      while $i<$docs_Count do
        ((BROWSERR.iframe(:id=>"ListTemplateFrame").table(:id=>"ctl00_ctl00_itemList_listTable").trs[$i].tds[8].text) !="Selected for QC").should be true
        ((BROWSERR.iframe(:id=>"ListTemplateFrame").table(:id=>"ctl00_ctl00_itemList_listTable").trs[$i].tds[8].text) !="Passed QC").should be true
        ((BROWSERR.iframe(:id=>"ListTemplateFrame").table(:id=>"ctl00_ctl00_itemList_listTable").trs[$i].tds[8].text) !="Failed QC").should be true
        $i=$i+1
      end
    rescue
    puts "error TiffingQC"
    end
  end
end
=end
