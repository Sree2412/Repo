require_relative 'Hlmc'
require_relative 'mocks/HlmcBillingMock'
require 'json'
require 'pry'
require 'byebug'

class HlmcBilling < Hlmc
	include HlmcBillingUrl
	include HlmcBillingMock
	
	def AddBillingItem(data)
		#EngagementNumber
		#BillingDate
		#Service
		#Location
		#UnitType
		#ExtendedPrice
		#UnitPrice
		#UnitNumber
		#Note
		
		$browser.ElementByCss("#BillingAddButton > a").click
		byebug
		$browser.ByCss("#ProjectBillingEditModalDialogglobalModalDialog").wait_until_present #due to the jquery open animation, need to wait until it is finished loading
		
		if data["EngagementNumber"] != nil
			$browser.ByCss("#SelectedEngagementId").Select(data["EngagementNumber"])
		end
		if data["BillingDate"] != nil
			$browser.ByCss("#SelectedBillingMonth").Select(data["BillingDate"])
		end
		if data["Service"] != nil
			$browser.ByCss("#MasterServiceId").Select(data["Service"])
		end
		if data["Location"] != nil
			$browser.ByCss("#LocationId").Select(data["Location"])
		end
		if data["UnitType"] != nil
			$browser.ByCss("#BillingItemEdit_PricingUnit").Text(data["UnitType"])
		end
		if data["ExtendedPrice"] != nil
			$browser.ByCss("#BillingItemEdit_ExtendedPrice").Text(data["ExtendedPrice"])
		end
		if data["UnitPrice"] != nil
			$browser.ByCss("#BillingItemEdit_PricePerUnit").Text(data["UnitPrice"])
		end
		if data["UnitNumber"] != nil
			$browser.ByCss("#BillingItemEdit_Units").Text(data["UnitNumber"])
		end
		if data["Note"] != nil
			$browser.ByCss("#BillingItemEdit_Note").Text(data["Note"])
		end
		
		$browser.ByCss("#ProjectBillingEditModalDialogglobalModalDialog > .modal-footer > a:eq(1)").click
	end
	
	def SelectBillingPeriod(period)
		$browser.goto ("%s&selectedBillingFilter=%s" % [HlmcBillingUrl.const_get($env), period])
	end
	
	def CreateBillingItemTest
		self.NavigateToProject(1951)
		self.SelectProjectBillingLink
		self.AddBillingItem('{ EngagementNumber: "02410-004" }')
	end
	
	def GetProjectBillingItemModels
		models = []
		billingRows = $browser.ByCss(".ProjectRowBilling")
		billingRows.each do |row|
			model = Hash.new
			model["EngagementNumber"] = $browser.ByChildCss(row, ".engagementColumnValue").text
			model["BillingDate"] = $browser.ByChildCss(row, ".billingDateColumnValue").text
			model["Service"] = $browser.ByChildCss(row, ".categoryColumnValue").text
			model["Location"] = $browser.ByChildCss(row, ".locationColumnValue").text
			model["UnitType"] = $browser.ByChildCss(row, ".unitTypeColumnValue").text
			model["ExtendedPrice"] = $browser.ByChildCss(row, ".extPriceColumnValue").text
			model["UnitPrice"] = $browser.ByChildCss(row, ".unitsColumnValue").text
			model["UnitNumber"] = $browser.ByChildCss(row, ".unitPriceColumnValue").text
			model["Note"] = $browser.ByChildCss(row, ".noteValue").text
			models.push(model)
		end
		return models
	end
end