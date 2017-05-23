require_relative 'Relativity'
require_relative 'mocks/RelativitySmokeUserMock'
require 'selenium-webdriver'
require 'json'
require 'pry'
require 'byebug'



class RelativitySmoke

    include RelativitySmokeUserUrl
    include RelativitySmokeUserMock
    include TestFramework
    include CreateSmokeItems

    def CreateNewWorkSpace()

      self.HomepageValidation
      self.EnteringUserNameCredentials
      self.EnteringPasswordCredentials
      self.NewWorkspaceNavigation
      self.NewWorkspaceCreation
      self.Validateworkspacecreation

    end



          def HomepageValidation


              $browser.img(:css => "#_relativityLogo").visible?

              $browser.div(:css => "#usernameform > fieldset > div.cardLabel.loginLabel").visible?

          end



        def EnteringUserNameCredentials

              $browser.text_field(:id=>"_email").set("Smokeuser@kcura.com")
              $browser.button(:id=>"continue").click

        end


       def EnteringPasswordCredentials

             $browser.text_field(:id=>"_password__password_TextBox").set("Password1!")
             $browser.button(:id=>"_login").click

          end




            def iframe_main
              return $browser.iframe(:id=>"ListTemplateFrame")
            end


        def NewWorkspaceNavigation

    sleep 3
            self.iframe_main.a(:class=>"actionButtonSmall", :title=>"New Workspace").visible?
            self.iframe_main.a(:class=>"actionButtonSmall", :title=>"New Workspace").click

         end

      def NewWorkspaceCreation
        $browser.td(:id=>"_editTemplate__kCuraScrollingDiv__name_nameCell").visible?
        $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__name_textBox_textBox").set("Smoke Workspace3")
        $browser.td(:id=>"_editTemplate__kCuraScrollingDiv__client_nameCell").visible?
        $browser.input(:id=>"_editTemplate__kCuraScrollingDiv__client_pick").visible?
        $browser.input(:id=>"_editTemplate__kCuraScrollingDiv__client_pick").click

        $browser.window(:index => 1).wait_until_present
        $browser.window(:index => 1).use do
         # $browser.ElementByCss("#radio_2").visible?
          # $browser.ElementByCss("#radio_2").click
        $browser.td(:text=> "Smoke Client").parent.radio(:id=>"radio_2").set
        $browser.a(:id=>"_ok2_button").click

        $browser.window(:index => 0).wait_until_present
        $browser.window(:index => 0).use do


        $browser.td(:id=>"_editTemplate__kCuraScrollingDiv__matter_nameCell").visible?
        $browser.input(:id=>"_editTemplate__kCuraScrollingDiv__matter_pick").visible?
        $browser.input(:id=>"_editTemplate__kCuraScrollingDiv__matter_pick").click


        #$browser.td(:text=> "Smoke Matter").radio(:id=>"radio_0").set
        #$browser.td(:text=> "Smoke Matter").parent.radio(:id=>"radio_0").set

        $browser.window(:index => 1).wait_until_present
        $browser.window(:index => 1).use do

        $browser.ElementByCss("#radio_0").click
        $browser.a(:id=>"_ok2_button").click

        $browser.window(:index => 0).wait_until_present
        $browser.window(:index => 0).use do

        $browser.td(:id=>"_editTemplate__kCuraScrollingDiv__template_nameCell").visible?
        $browser.input(:id=>"_editTemplate__kCuraScrollingDiv__template_pick").visible?
        $browser.input(:id=>"_editTemplate__kCuraScrollingDiv__template_pick").click

        $browser.window(:index => 1).wait_until_present
        $browser.window(:index => 1).use do

        $browser.ElementByCss("#radio_0").click
        $browser.a(:id=>"_ok2_button").click

        $browser.window(:index => 0).wait_until_present
        $browser.window(:index => 0).use do


        $browser.h2(:text=>"Resource Information").visible?
        $browser.select(:id => "_editTemplate__kCuraScrollingDiv__resourceGroup_dropDownList").visible?
        $browser.select(:id => "_editTemplate__kCuraScrollingDiv__resourceGroup_dropDownList").click
        $browser.option(:text => "Default").select
        $browser.td(:id => "_editTemplate__kCuraScrollingDiv__defaultDocumentLocation_nameCell").visible?
        $browser.select(:id => "_editTemplate__kCuraScrollingDiv__defaultDocumentLocation_dropDownList").click
        $browser.option(:value => "1014887").select
        $browser.td(:id => "_editTemplate__kCuraScrollingDiv__defaultCacheLocation_nameCell").visible?
        $browser.select(:id => "_editTemplate__kCuraScrollingDiv__defaultCacheLocation_dropDownList").click
        $browser.option(:value => "1015534").select

        $browser.a(:id=> "_editTemplate_cancel1_button").click

         #$browser.a(:id=> "_editTemplate_save1_button").click

         def Validateworkspacecreation

         self.iframe_main.a(:class=>"actionButtonSmall", :title=>"New Workspace").wait_until_present

       end



     end
end

  end







end
end
end

 end





 end

      #$browser.input(:name=>"_editTemplate$_kCuraScrollingDiv$_matter$pick").visible?

      #$browser.input(:id=>"_editTemplate__kCuraScrollingDiv__client_pick").click





      #$browser.td(:text=>CreateSmokeItems::Client).parent.radio(:id=>"radio_2").set



    #radio_2
    #$browser.td(:css=>"#_artifacts_itemList__artifacts_itemList_ROW2 > td:nth-child(1)t").visible?



#      $browser.span(:css=>"#_title").wait_until_present
#       #_title
#       byebug
#     $browser.ElementByCss("#radio_2").visible?
#     $browser.ElementByCss("#radio_2").click
#     #radio_2
#     #$browser.input(:name=>"_artifacts_itemList_SINGLESELECTEDROW",:id=>"radio_2").visible?
#
#     #$browser.span(:css=>"#_title").visible?
# end
    #_title
#_artifacts_itemList__artifacts_itemList_ROW2 > td:nth-child(1)
#_title




           #$browser.ElementByCss(".clientNameValue").click
          #$browser.ElementByCss(".clientNameValue").click
          #$browser.element(:class => 'clientNameValue').click






=begin


    def ValidateHomePage
      #$browser.goto "%s/Project/Details?projectid=%s" % [@url, id]
      #binding.pry
      $browser.ElementByCss(".clientNameValue").click
      #$browser.element(:class => 'clientNameValue').click
      sleep 3
    end

    def NavigateToPrimaryReview
      #$browser.goto "%s/Project/Details?projectid=%s" % [@url, id]
      $browser.ElementByCss(".primaryBillingNav").click
      #$browser.element(:link, 'Primary Review').click
      sleep 3
    end


    def AddEngagementClick
      #$browser.goto "%s/Project/Details?projectid=%s" % [@url, id]
      $browser.ElementByCss(".addEngagement").click
      #$browser.element(:class => 'addEngagement').click
      sleep 3
    end


    def SelectEngagement
      #$browser.goto "%s/Project/Details?projectid=%s" % [@url, id]
      $browser.ElementByCss("#EngagementBillingID").click
      sleep 3
      #$browser.find('#selectedBillingId', :text => 'Liti').select_option
      #$browser.ElementByCss("#EngagementBillingID").Select_option('Litigation').select
      $browser.ElementByCss('#EngagementBillingID > option:nth-child(3)').select
      $browser.a(:text => 'Save').click
      sleep 5
      $browser.ElementByCss(".adminEdit").click
      sleep 3
      $browser.img(:class => 'ui-datepicker-trigger').click
      sleep 3
      $browser.a(:class => "ui-state-default ui-state-highlight").select
      sleep 3
    end

    #$browser.element(:name => 'selectedBillingId').click

    #MatterTypeDD = BROWSER.select(:name => 'MatterTypeId')


    #Engagementclcik.option(:text => Litigation).click

    #$browser.ElementByCss("#EngagementBillingID").click
    #$browser.ElementByCss("#EngagementBillingID")
    #Engagementclcik.option(:text => Litigation).click

    #$browser.ElementByCss("#EngagementBillingID").select
=end
