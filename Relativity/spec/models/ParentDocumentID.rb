require_relative 'Relativity'
require_relative 'mocks/RelativitySmokeUserMock'
require 'selenium-webdriver'
require 'json'
require 'pry'
require 'byebug'



class ParentDocumentID

    include RelativitySmokeUserUrl
    include RelativitySmokeUserMock
    include TestFramework
    include CreateSmokeItems

    def CreateParentDocumentID()

      self.ValidateworkspaceScreen
      self.NavigatoSmokeworkspace
      self.NavigatingtoWorkSpaceAdminTab
      self.NavigatingtoFieldTab
      self.NavigatingtoNewFieldTab
      self.ObjectnameValidation
      self.CreateProjectId

    end


        def iframe_main

              return $browser.iframe(:id=>"ListTemplateFrame")

            end


        def ValidateworkspaceScreen
          # Navigating to smoke work space

          self.iframe_main.a(:class=>"actionButtonSmall", :title=>"New Workspace").visible?

        end


        def NavigatoSmokeworkspace

          self.iframe_main.a(:class=>"itemListPrimaryLink").visible?
          self.iframe_main.a(:class=>"itemListPrimaryLink").click

        end

        def NavigatingtoWorkSpaceAdminTab

          # Validating Workspace admin Tab

          $browser.a(:css=>"#horizontal-tabstrip > ul > li:nth-child(6) > a.dropdownParent.ng-binding").visible?
          $browser.a(:css=>"#horizontal-tabstrip > ul > li:nth-child(6) > a.dropdownParent.ng-binding").click


        end


        def NavigatingtoFieldTab

          # Validating Workspace admin Tab
          $browser.a(:css=>"#horizontal-subtabstrip > ul > li:nth-child(4) > a").visible?
          $browser.a(:css=>"#horizontal-subtabstrip > ul > li:nth-child(4) > a").click

        end

      def NavigatingtoNewFieldTab


          self.iframe_main.a(:css => "#_main > div:nth-child(1) > div.leftAligned > a ").visible?
          self.iframe_main.a(:css => "#_main > div:nth-child(1) > div.leftAligned > a ").click


         end


      def ObjectnameValidation


        # Validate Object name
        $browser.td(:id=>"_editTemplate__objectType_nameCell").visible?


       end


      def CreateProjectId


          $browser.select(:id=>"_editTemplate__objectType_dropDownList").visible?
          $browser.select(:id=>"_editTemplate__objectType_dropDownList").click
          $browser.option(:text => "Document").select
          $browser.text_field(:id=>"_editTemplate__name_textBox_textBox").set("Parent Document ID")
          $browser.select(:id=>"_editTemplate__type_dropDownList").visible?
          $browser.select(:id=>"_editTemplate__type_dropDownList").click
          $browser.option(:text => "Fixed-Length Text").select
          $browser.select(:id=>"_editTemplate__allowGroupBy_booleanDropDownList__dropDownList").visible?
          #$browser.select(:id=>"_editTemplate__allowGroupBy_booleanDropDownList__dropDownList").click

          #$browser.option(:value => "True").select
         # $browser.option(:text => "Yes").select

          #$browser.option(:css => "#_editTemplate__allowGroupBy_booleanDropDownList__dropDownList > option:nth-child(1)").select


          #_editTemplate__allowGroupBy_booleanDropDownList__dropDownList > option:nth-child(1)
          $browser.select(:id=>"_editTemplate__allowPivot_booleanDropDownList__dropDownList").visible?
          #$browser.select(:id=>"_editTemplate__allowPivot_booleanDropDownList__dropDownList").click


          #$browser.option(:CSS=> "#_editTemplate__allowPivot_booleanDropDownList__dropDownList > option:nth-child(1)").select

          #_editTemplate__allowPivot_booleanDropDownList__dropDownList > option:nth-child(1)
          $browser.a(:id=> "_editTemplate_cancel1_button").select


        end

      end
