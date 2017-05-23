require_relative 'Relativity'
require_relative 'mocks/RelativitySmokeUserMock'
require 'selenium-webdriver'
require 'json'
require 'pry'
require 'byebug'



class SmokeGroup < ParentDocumentID

    include RelativitySmokeUserUrl
    include RelativitySmokeUserMock
    include TestFramework
    include CreateSmokeItems

    def CreateSmokeGroup()

      self.SmokeWorkspaceGroup
      #self.WorkspaceNavigation
      #self.NavigatingtoWorkspaceDeatilsTab


    end


        def iframe_main

              return $browser.iframe(:id=>"ListTemplateFrame")

            end


        def SmokeWorkspaceGroup

          # Navigating to smoke work space

          #horizontal-subtabstrip > ul > li:nth-child(1) > a

          $browser.a(:css=>"#horizontal-subtabstrip > ul > li:nth-child(1) > a").visible?
          $browser.a(:css=>"#horizontal-subtabstrip > ul > li:nth-child(1) > a").click

          $browser.a(:css=>"#_viewTemplate__kCuraScrollingDiv__manageWorspacePermissions_anchor").visible?
         $browser.a(:css=>"#_viewTemplate__kCuraScrollingDiv__manageWorspacePermissions_anchor").click


$browser.window(:index => 1).wait_until_present
$browser.window(:index => 1).use do


$browser.a(:css=>"#_addremovegroups").visible?
$browser.a(:css=>"#_addremovegroups").click

$browser.window(:index => 1).wait_until_present
$browser.window(:index => 1).use do

$browser.span(:css => "#modalDialog > div > div > div.half-width.left.list-inner > section > article:nth-child(8) > div > span.dirty-effect-target.displayed-text").visible?
$browser.span(:css => "#modalDialog > div > div > div.half-width.left.list-inner > section > article:nth-child(8) > div > span.dirty-effect-target.displayed-text").cliuck

$browser.span(:css => "#modalDialog > div > div > div.half-width.left.list-inner > a > span:nth-child(2)").visible?
$browser.span(:css => "#modalDialog > div > div > div.half-width.left.list-inner > a > span:nth-child(2)").click

$browser.window(:index => 0).wait_until_present
$browser.window(:index => 0).use do


$browser.span(:css => "#_addRemoveSaveButton > span").visible?
$browser.span(:css => "#_addRemoveSaveButton > span").click

$browser.window(:index => 0).wait_until_present
$browser.window(:index => 0).use do

#$browser.td(:class => "previewModeBlock").visible?
#$browser.td(:id => "EndPreviewSessionButton").visible?



end

end

end
end
end
 #_addRemoveSaveButton > span
#_addRemoveSaveButton > span





#_addremovegroups

        end




=begin
        def WorkspaceNavigation


          self.iframe_main.a(:class=>"itemListPrimaryLink").click
          $browser.a(:css=>"#horizontal-tabstrip > ul > li:nth-child(6) > a.dropdownParent.ng-binding").visible?


          $browser.a(:css=>"#horizontal-tabstrip > ul > li:nth-child(6) > a.dropdownParent.ng-binding").click

        end



        def NavigatingtoWorkspaceDeatilsTab

          # Validating Workspace admin Tab

          $browser.a(:css=>"#horizontal-subtabstrip > ul > li.relativity-subtab.ng-scope.active > a").visible?

          $browser.a(:css=>"#horizontal-subtabstrip > ul > li.relativity-subtab.ng-scope.active > a").click

        end

=end
