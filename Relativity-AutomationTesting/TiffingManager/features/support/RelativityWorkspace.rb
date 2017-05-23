load 'features/support/TestFramework.rb'

class RelativityWorkspace < FeatureTest  
  
  def FilterWorkspaceById(id)
    self.SetElement(self.browser.iframe(:id=>"ListTemplateFrame").a(:id=>"ctl00_viewRenderer_itemList_FilterSwitch").img()).Click
    begin
      self.SetElement(self.browser.iframe(:id=>"ListTemplateFrame").text_field(:id=>"ctl00_viewRenderer_itemList_FILTER-BOOLEANSEARCH[Name]-T")).Text(id)
      self.PressEnterKey
    rescue
    end
  end

  def NavigateToWorkspace(id, name)
    self.FilterWorkspaceById(id)
    self.SetElement(self.browser.iframe(:id=>"ListTemplateFrame").a(:text=>name)).Click
  end
end
