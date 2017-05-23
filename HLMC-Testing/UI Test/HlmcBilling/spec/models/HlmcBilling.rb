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
		$browser.ElementByCss("#ProjectBillingEditModalDialogglobalModalDialog").wait_until_present #due to the jquery open animation, need to wait until it is finished loading

		if data["EngagementNumber"] != nil
			$browser.ElementByCss("#SelectedEngagementId").Select(data["EngagementNumber"])
		end
		if data["BillingDate"] != nil
			$browser.ElementByCss("#SelectedBillingMonth").Select(data["BillingDate"])
		end
		if data["Service"] != nil
			$browser.ElementByCss("#MasterServiceId").Select(data["Service"])
		end
		if data["Location"] != nil
			$browser.ElementByCss("#LocationId").Select(data["Location"])
		end
		if data["UnitType"] != nil
			$browser.ElementByCss("#BillingItemEdit_PricingUnit").Text(data["UnitType"])
		end
		if data["ExtendedPrice"] != nil
			$browser.ElementByCss("#BillingItemEdit_ExtendedPrice").Text(data["ExtendedPrice"])
		end
		if data["UnitPrice"] != nil
			$browser.ElementByCss("#BillingItemEdit_PricePerUnit").Text(data["UnitPrice"])
		end
		if data["UnitNumber"] != nil
			$browser.ElementByCss("#BillingItemEdit_Units").Text(data["UnitNumber"])
		end
		if data["Note"] != nil
			$browser.ElementByCss("#BillingItemEdit_Note").Text(data["Note"])
		end

		$browser.ElementByCss("#ProjectBillingEditModalDialogglobalModalDialog > .modal-footer > a:eq(1)").click
	end

	def SelectBillingPeriod(period)
		$browser.goto ("%s&selectedBillingFilter=%s" % [HlmcBillingUrl.const_get($env), period])
	end

	def CreateBillingItemTest
		self.NavigateToProject(1951)
		self.SelectProjectBillingLink
		self.AddBillingItem('{ EngagementNumber: "02410-004" }')
	end

	def ProjectBillingEdit(data)

			$browser.ElementByCss(".edit").click
		# if data["UnitPrice"] = 1
  	$browser.ElementByCss("#BillingItemEdit_Units").Text(data["UnitNumber"])
		$browser.ElementByCss("#BillingItemEdit_PricePerUnit").Text(data["UnitPrice"])
    $browser.ElementByCss("#BillingItemEdit_Note").click
    $browser.ElementByCss(".edit + div > div > div.modal-footer > a.callback-btn").click

	 end
  def ProjectBillingCertify
		 sleep 5
		 $browser.ElementByCss("#billingPeriodStatusDiv > div:nth-child(1) > a > div").click

      $browser.ElementByCss(".billingPeriodLockIcon").click
      $browser.alert.ok
  end

	 def ProjectBillingLock
   sleep 2
			$browser.ElementByCss(".billingPeriodLockIcon").click
			$browser.ElementByCss(".billingPeriodLockIcon").click
	sleep 2
			 $browser.alert.ok
	end

   def ProjectBillingAudithistory
    $browser.ElementByCss("#auditHistoryDiv > a").click
	  $browser.ElementByCss("#AuditHistoryModalDialogglobalModalDialog").wait_until_present
  	$browser.ElementByCss("#closeButton").click
   end

	 def ProjectBillingDelete
	  $browser.refresh
	 	$browser.ElementByCss("body > div.main-container > div > div.container > div.billingMoveUp > table > tbody > tr > td:nth-child(2) > div > div:nth-child(2) > a").click
	 end

	 def ProjectBillingTimecardRollup
      $browser.refresh
		 	$browser.ElementByCss("#eliteRollupDiv > a").click
			$browser.ElementByCss("body > div.main-container > div.container.eliterollup-container > div:nth-child(2) > table > tbody > tr > td:nth-child(1) > h1").visible?
			$browser.ElementByCss(".projectBillingNav").click
		end

		def ProjectBillingReport
			  $browser.refresh
			$browser.ElementByCss("body > div.main-container > div > div.container > div.ProjectBillingReportDiv > a").click
			$browser.ElementByCss("#ProjectBillingReportModalDialogglobalModalDialog").wait_until_present
			$browser.ElementByCss("#BillingYearMonth").click
		  $browser.ElementByCss("#BillingYearMonth > option:nth-child(18)").click
			$browser.ElementByCss("#ReportFormat").click
			$browser.ElementByCss("#ReportFormat > option:nth-child(2)").click
			$browser.ElementByCss("#ReportFormat").click
			$browser.ElementByCss("#ProjectBillingReportModalDialogglobalModalDialog > div.modal-header > button").click
		 end

    def EngagementBillingReport
			$browser.ElementByCss("body > div.main-container > div > div.container > div.billingMoveUp > div:nth-child(3) > a").click
			$browser.ElementByCss("#ProjectBillingReportModalDialogglobalModalDialog").wait_until_present
			$browser.ElementByCss("#BillingYearMonth").click
			$browser.ElementByCss("#BillingYearMonth > option:nth-child(18)").click
			$browser.ElementByCss("#ReportFormat").click
		 	$browser.ElementByCss("#ReportFormat > option:nth-child(2)").click
			$browser.ElementByCss("#ReportFormat").click
			$browser.ElementByCss("#ProjectBillingReportModalDialogglobalModalDialog > div.modal-header > button").click
		 end

		 def ProjectBillingAttach
			 sleep 2
	 	 $browser.ElementByCss("body > div.main-container > div > div.container > div.billingMoveUp > table:nth-child(2) > tbody > tr > td:nth-child(2) > div > div:nth-child(3) > a").click
	   $browser.Assert($browser.ElementByCss("#fileToUpload").exists?, "FiletoUpload Doesn't Exist")
	 	 $browser.ElementByCss(".attach + div > div > div.modal-footer > a.btn.btn-primary.callback-btn").click

	 	end

	def GetProjectBillingItemModels
		models = []
		billingRows = $browser.ElementsByCss(".ProjectRowBilling")
		billingRows.each do |row|
			model = Hash.new
			model["EngagementNumber"] = $browser.ElementByChildCss(row, ".engagementColumnValue").text
			model["BillingDate"] = $browser.ElementByChildCss(row, ".billingDateColumnValue").text
			model["Service"] = $browser.ElementByChildCss(row, ".categoryColumnValue").text
			model["Location"] = $browser.ElementByChildCss(row, ".locationColumnValue").text
			model["UnitType"] = $browser.ElementByChildCss(row, ".unitTypeColumnValue").text
			model["ExtendedPrice"] = $browser.ElementByChildCss(row, ".extPriceColumnValue").text
			model["UnitPrice"] = $browser.ElementByChildCss(row, ".unitsColumnValue").text
			model["UnitNumber"] = $browser.ElementByChildCss(row, ".unitPriceColumnValue").text
			model["Note"] = $browser.ElementByChildCss(row, ".noteValue").text
			models.push(model)
		end
		return models
	end
end
