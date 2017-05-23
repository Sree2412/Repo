class FeatureSettings
  
  def ClickDiv(div)
    div.click 
    sleep 1
  end

  module FeatureSettingEnum
    SearchTitleDefault = 8
    DisplayTicketsDefault = 14
    TfsUSDefault = 20
    RequestFeatureDefault = 26
    NewFeatureDefault = 32

    SearchTitleOff = 7
    DisplayTicketsOff = 13
    TfsUSOff = 19
    RequestFeatureOff = 25
    NewFeatureOff = 31

    SearchTitleOn = 6
    DisplayTicketsOn = 12
    TfsUSOn = 18
    RequestFeatureOn = 24
    NewFeatureOn = 30
  end

  module FeatureSettingDivs
   SearchTitleDefaultDiv = BROWSER.divs[FeatureSettingEnum::SearchTitleDefault]
   DisplayTicketsDefaultDiv = BROWSER.divs[FeatureSettingEnum::DisplayTicketsDefault]
   TfsUSDefaultDiv = BROWSER.divs[FeatureSettingEnum::TfsUSDefault]
   RequestFeatureDefaultDiv = BROWSER.divs[FeatureSettingEnum::RequestFeatureDefault]
   NewFeatureDefaultDiv = BROWSER.divs[FeatureSettingEnum::NewFeatureDefault]

   SearchTitleOffDiv = BROWSER.divs[FeatureSettingEnum::SearchTitleOff]
   DisplayTicketsOffDiv = BROWSER.divs[FeatureSettingEnum::DisplayTicketsOff]
   TfsUSOffDiv = BROWSER.divs[FeatureSettingEnum::TfsUSOff]
   RequestFeatureOffDiv = BROWSER.divs[FeatureSettingEnum::RequestFeatureOff]
   NewFeatureOffDiv = BROWSER.divs[FeatureSettingEnum::NewFeatureOff]

   SearchTitleOnDiv = BROWSER.divs[FeatureSettingEnum::SearchTitleOn]
   DisplayTicketsOnDiv = BROWSER.divs[FeatureSettingEnum::DisplayTicketsOn]
   TfsUSOnDiv = BROWSER.divs[FeatureSettingEnum::TfsUSOn]
   RequestFeatureOnDiv = BROWSER.divs[FeatureSettingEnum::RequestFeatureOn]
   NewFeatureOnDiv = BROWSER.divs[FeatureSettingEnum::NewFeatureOn]
  end

  def SetAllDefault
    ClickDiv(FeatureSettingDivs::SearchTitleDefaultDiv)
    ClickDiv(FeatureSettingDivs::DisplayTicketsDefaultDiv)
    ClickDiv(FeatureSettingDivs::TfsUSDefaultDiv)
    ClickDiv(FeatureSettingDivs::RequestFeatureDefaultDiv)
    ClickDiv(FeatureSettingDivs::NewFeatureDefaultDiv)
  end

  def SetAllOff
    ClickDiv(FeatureSettingDivs::SearchTitleOffDiv)
    ClickDiv(FeatureSettingDivs::DisplayTicketsOffDiv)
    ClickDiv(FeatureSettingDivs::TfsUSOffDiv)
    ClickDiv(FeatureSettingDivs::RequestFeatureOffDiv)
    ClickDiv(FeatureSettingDivs::NewFeatureOffDiv)
  end

  def SetAllOn
    ClickDiv(FeatureSettingDivs::SearchTitleOnDiv)
    ClickDiv(FeatureSettingDivs::DisplayTicketsOnDiv)
    ClickDiv(FeatureSettingDivs::TfsUSOnDiv)
    ClickDiv(FeatureSettingDivs::RequestFeatureOnDiv)
    ClickDiv(FeatureSettingDivs::NewFeatureOnDiv)
  end
end

