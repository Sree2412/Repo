require 'rubygems'
require 'bundler/setup'
require 'byebug'
require 'lib/RelativityWorkspace'
require_relative 'InputData'

class ProcessTranscript < RelativityWorkspace

 def iframe_documentViewer
    return $browser.iframe(:id=>"_documentViewer__documentIdentifierFrame")
 end
 
 def iframe_WordViewer
    return $browser.iframe(:id=>"_documentViewer__viewerFrame")
 end
 
  def iframe_WordIndex
    return self.iframe_WordViewer.iframe(:id=>"wordIndexBottomFrame")
 end

 def ValidateDocumentsCount
 	iframe_main.table(:id=>"ctl00_ctl00_itemList_listTable").trs.count    
 end
     
 def RunTranscriptProcess(header, footer)
    $browser.a(:class=>"returnLink").span(:class=>"returnText", :text=> "Return to document list").click
    iframe_main.input(:id=>"checkbox_0", :name=>"ctl00_ctl00_itemList_SELECTEDROW-0-1042157").wait_until_present.click
 	iframe_main.select(:id=>"ctl00_checkedItemsActionToTake").option(:value=>"ProcessTranscript").select
  	iframe_main.a(:id=>"ctl00_ctl04_button", :title => "Go").click
  	$browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
    	$browser.text_field(:id=>"ctl03_textBox_textBox").wait_until_present.set(header)
    	$browser.text_field(:id=>"ctl04_textBox_textBox").wait_until_present.set(footer)
    	$browser.a(:id=>"ctl01_button", :class=>"ActionButton", :title=>"Run").click
    end
    $browser.window(:index => 0).wait_until_present
    $browser.window(:index => 0).use do
       iframe_main.tr(:id=>"ctl00_ctl00_itemList_ctl00_ctl00_itemList_ROW0").a(:class=>"itemListPrimaryLink").wait_until_present
    end

  end 

 def ValidateProcessedtransacript(number,header,footer,word1)
    
   iframe_main.a(:text=>number).click
   iframe_documentViewer.td(:class=>"identifierCell").span(:text=>number).wait_until_present
   iframe_WordViewer.div(:id=>"toolbarBottomRight").span(:class=>"charm-outer icon-viewer-word-index").wait_until_present.click
   iframe_WordIndex.text_field(:id=>"_wordindex_ctl00_itemList_FILTER-BOOLEANSEARCH[Word]-T").set(word1)
   $browser.send_keys(:return)
   iframe_WordIndex.tr(:id=>"_wordindex_ctl00_itemList__wordindex_ctl00_itemList_ROW0").tds[2].as[0].wait_until_present.click
   iframe_WordViewer.div(:id=>"viewerContainer").span(:text=>word1).exists?
   iframe_WordViewer.div(:id=>"viewerContainer").span(:text=>header).exists?
   iframe_WordViewer.div(:id=>"viewerContainer").span(:text=>footer).exists?
 
 end 

end 

  #iframe_WordViewer.div(:id=>"viewerContainer").span(:text=>word1).exists?
   #iframe_WordIndex.tr(:id=>"_wordindex_ctl00_itemList__wordindex_ctl00_itemList_ROW0").wait_until_present.click
   # style="color:#FFFF00;background-color:#0000FF;"
   # page_line_index = iframe_WordIndex..tds[2].as[0].text
   # #"3:19;"
   # page_Number = page_line_index.split(":").first
   # line_Number_inital = page_line_index.split(":").last
   # line_Number_final = line_Number_inital.split(";").first
  
   #$browser.input(:title=>"Hit enter to set filter").visible?

   #_wordindex_ctl00_itemList_FILTER-BOOLEANSEARCH\5b Word\5d -T
   #_wordindex_ctl00_itemList_FILTER-BOOLEANSEARCH\5b Word\5d -T
 #iframe_main.div(:class=>"actionCellContainer rightAligned").span(:class=>"itemListActionCell").a(:id=>"ctl00_ctl00_itemList_FilterSwitch").img(:class=>"itemListActionImage").visible?
   #iframe_main.a(:id=>"ctl00_ctl00_itemList_FilterSwitch").img(:class=>"itemListActionImage").click
   
   #iframe_ma
   #iframe_main.text_field(:id=>"_documentViewer__viewerFrame"ctl00_ctl00_itemList_FILTER-BOOLEANSEARCH[ControlNumber]-T").set(number).send_keys

    #begin 
     #if Control_Number.exists?
     	#iframe_main.text_field(:id=>"ctl00_ctl00_itemList_FILTER-BOOLEANSEARCH[ControlNumber]-T").set(number)
        #$browser.send_keys(:return)
     #else
        #raise "Search Text box funnel icon doesnt exist"
    #end

  #byebug
#  iframe_main.title(:id=>"Hit enter to set filter").click

   


   #a(:class=>"ctl00_ctl00_itemList_FilterSwitch").visible?

   #img(:class=>"itemListActionImage").visible?

   #self.Assert(self.GetNumRowsByText(value) == 0, "Value does exist in table", true)