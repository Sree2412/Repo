require 'rubygems'
require 'bundler/setup'

#require 'Automation-Common'

class Hlmc	
	include TestFramework
	
	def NavigateToProject(id)
		$browser.goto "%s/Project/Details?projectid=%s" % [@url, id]
	end
	
	def SelectProjectBillingLink
		$browser.ByCss(".projectBillingNav").click
	end
end