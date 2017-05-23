require_relative 'mocks/ReportingPortalMock'
require 'json'
require 'pry'
require 'byebug'
#require 'watir-scroll'

class ReportingPortal


# Search filters

  def ClearFilter
    $browser.elements(:text, 'clear')[0].click
  end

  def GetProjects
    projects = []
    #$browser.div(:class, 'list-project ng-binding ng-scope').wait_until_present
    $browser.divs(:class, 'list-project ng-binding ng-scope').each {|div| projects << div.text} 
    return projects
  end

	def GetClients
		clients = []
		$browser.divs(:class, 'list-client ng-binding ng-scope').each {|div| clients << div.text}
		return clients
	end

	def OpenClientSearch
		$browser.element(:text, 'expand_more').click
	end

	def OpenProject(projectcode)
		$browser.link(:href, "#/project/#{projectcode}").click
	end

	def OpenProjectSearch
		$browser.element(:text, 'search').click
	end

	def SendClient(clientname)
		$browser.text_field(:name, 'clientFilter').wait_until_present.set "#{clientname}"
	end

	def SendProject(projectname)
		$browser.text_field(:id, 'projectSearch').set "#{projectname}"
	end


# Report actions

	def BackFromReport
		$browser.i(:text, 'arrow_back').click		
	end

	def OpenReport(report)
		$browser.div(:text, "#{report}").click
		#$browser.div(:class, 'md-half-circle').wait_while_present
		$browser.div(:text, 'Loading').wait_until_present.wait_while_present
	end

	def ToggleReportPages(direction)
		#direction in [before, next]
		$browser.i(:text, "navigate_#{direction}").click
		$browser.div(:text, 'Loading').wait_while_present
	end

	def ReportContentTitle
		# content[0] = report title
		# content[2] = project name
		# content[4] = project code
		content = $browser.table(:class, 'r10').text.split("\n")
		return content
	end	

	def ElementArea
		# confirm images loaded by checking size
		area = $browser.div(:id, '12iT0_ici').img.width * $browser.div(:id, '12iT0_ici').img.width
		return area
	end


# Report filters

	def FilterReports(filter)
		$browser.span(:text, "#{filter}").click
	end

	def GetOpenProjectName
		$browser.div(:class, 'md-title').wait_until_present
		return $browser.div(:class, 'md-title').text
	end

	def GetReports
		setup = []
		reports = []
		sleep 0.5
		$browser.divs(:class, 'report-tile-content').each {|div| setup << div.text}
		#reports.collect {|i| i.gsub!("description\n",'')}
		setup.each {|i| reports << i.rpartition("\n")[2] }
		return reports
	end

	def GetReportTitle
		title = $browser.divs(:class, 'md-subhead')[1].text
		title.gsub!("arrow_back\n",'')
		return title
	end


# Report parameters

	def SetStartDate(date)
		#set date by MMDDYYYY
		$browser.input(:id, 'input_7').click
		$browser.send_keys("#{date}")
	end

	def OpenFilter(filter)
		$browser.label(:text, "#{filter}").parent.click
	end


# Misc

  def GetPageTitle
    return $browser.h3(:class, 'md-title').text
  end

  def Impersonate(user)
    $browser.button.i(:text, 'person_outline').click
    $browser.text_field(:id, 'input_3').set "#{user}"
    $browser.button(:text, 'OK').click
    $browser.element(:xpath, '/html/body/div/md-sidenav/div[2]/md-progress-circular').wait_until_present
	$browser.element(:xpath, '/html/body/div/md-sidenav/div[2]/md-progress-circular').wait_while_present
  end

  def EndImpersonation
    $browser.button.i(:text, 'person').click
	$browser.element(:xpath, '/html/body/div/md-sidenav/div[2]/md-progress-circular').wait_until_present
	$browser.element(:xpath, '/html/body/div/md-sidenav/div[2]/md-progress-circular').wait_while_present
  end

  def ScrolltoBottom
    $browser.scroll.to :bottom
  end

  def ParameterHelpTextVisible
    return $browser.div(:text, 'Fill in all required report parameters to show report').visible?   
  end
end