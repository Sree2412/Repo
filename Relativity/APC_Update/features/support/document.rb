
class Document

  def initialize
    @workspace = RelativityWorkspace.new
  end


  def DocumentViewFolder(foldername)
    @workspace.iframe_main.when_present.select_list(:id=>"ctl00_viewsDropDown").when_present.option(:text =>foldername).select
  end


  def BulkEdit()
    @workspace.iframe_main.select_list(:name=>"ctl00$checkedItemsAction").select "Checked"
    @workspace.iframe_main.select_list(:name=>"ctl00$checkedItemsActionToTake").select"Edit"
    @workspace.iframe_main.a(:text => "Go").click
  end
end

