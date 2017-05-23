require 'rubygems'
require 'bundler/setup'

#require 'Automation-Common'

class Hlmc
	include TestFramework

	def NavigateToProject(id)
		$browser.goto "%s/Project/Details?projectid=%s" % [@url, id]
	end

	def NavigateByProjectCode (project_code)
		 $browser.text_field(:id=>"searchString").set project_code
		 $browser.button(:name => "SearchButton").click
	end

	def SelectContractTermsLink
		$browser.ElementByCss(".contractTermsNav").click
	end

	def SelectProjectBillingLink
		$browser.ElementByCss(".projectBillingNav").click
	end

	def SelectPrimaryReviewLink
		$browser.ElementByCss(".primaryBillingNav image-primary-off").click
	end

	def SelectPrivilegeLogReviewLink
		$browser.ElementByCss(".privilegeBillingNav image-privilege-off").click
	end

	def SelectNonEnglishReviewLink
		$browser.ElementByCss(".foreignBillingNav image-foreign-on").click
	end

	def SelectRedactionReviewLink
		$browser.ElementByCss(".redactionBillingNav image-redaction-off").click
	end

	def SelectSearchTermReportsLink
		$browser.ElementByCss(".strRequestFormsNav image-primary-off").click
	end
end
