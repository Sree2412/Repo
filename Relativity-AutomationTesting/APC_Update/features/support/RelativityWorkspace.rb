
class RelativityWorkspace  

  def byCss(selector)
    return BROWSERR.execute_script("var values = $('%s'); return values.length > 1 ? values : values[0];" % selector)
  end


  def iframe_main
    return BROWSERR.iframe(:id=>"ListTemplateFrame")
  end 

  def tab_iFrame
    return BROWSERR.iframe(:id => "_externalPage")
  end


  def NavigateToWorkspace(workspaceName)
    search_funnel_show = iframe_main.a(:id=>"ctl00_viewRenderer_itemList_FilterSwitch", :title=>"Show Filters")
    search_funnel_hide = iframe_main.a(:id=>"ctl00_viewRenderer_itemList_FilterSwitch", :title=>"Hide Filters")
    begin
      if search_funnel_show.exists?
        search_funnel_show.click
        iframe_main.text_field(:id=>"ctl00_viewRenderer_itemList_FILTER-BOOLEANSEARCH[Name]-T").set(workspaceName)
        BROWSERR.send_keys(:return)
        iframe_main.a(:text=> workspaceName).click
      elsif search_funnel_hide.exists?
        iframe_main.text_field(:id=>"ctl00_viewRenderer_itemList_FILTER-BOOLEANSEARCH[Name]-T").set(workspaceName)
        BROWSERR.send_keys(:return)
        iframe_main.a(:text=>workspaceName).click
      else
        raise "Search Text box funnel icon doesnt exist"
      end
    end
  end

  def TabAccess(tabName)
    dropdown_tab = BROWSERR.li(:id => "moreTabsButton").a(:id => "moreTabsButtonToggle")
    relativity_tab = BROWSERR.a(:class => "accordionParent ng-scope accordionParentVisible", :text => tabName)
    dropdown_tab.when_present.click
    sleep (1)
    relativity_tab.wait_until_present
    relativity_tab.click
  end

end
