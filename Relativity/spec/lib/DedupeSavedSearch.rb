require 'rubygems'
require 'bundler/setup'
require 'TestFramework'
require 'lib/RelativityWorkspace'
require 'byebug'

class DedupeSavedSearch < RelativityWorkspace
  include TestFramework
  include DedupeHistoryRunsColumns
  include DedupeInputs

  def select_savedSearch(savedSearch_name)
  	#$browser.ElementByCss('#ddlSavedSearchField > option:contains(#{savedSearch_name})')
  	self.tab_iFrame.select_list(:id=>"ddlSavedSearchField").option(:text=>savedSearch_name).select
  end

  def select_fieldToUpdate(field_name)
  	self.tab_iFrame.select_list(:id=>"ddlFieldtoUpdate").option(:text=>"#{field_name}").select
  end

  def select_deDuplicationType(deDuplication_name)
  	self.tab_iFrame.input(:id=>"radbtnDudupType#{deDuplication_name}").old_click
  end

  def submit_dedupe
  	return self.tab_iFrame.div(:id=>"pnlSetup").input(:name=>"btnSubmit")
  end

  def refresh_dedupe
  	self.tab_iFrame.div(:id=>"pnlSetup").input(:name=>"btnRefresh").old_click
  end

  def wait_while_queued
  	begin
  		i=1
  		while i<21 && self.tab_iFrame.table(:id=>"gvHistory").trs[2].tds[3].text != "Success" do
  			sleep 15
  			self.refresh_dedupe
  			i = i+1	
  		end
  	end
  end

	def check_table(column)
		return self.tab_iFrame.table(:id=>"gvHistory").trs[2].tds[column].text 
  end

	# def check_type
	# 	return self.tab_iFrame.table(:id=>"gvHistory").trs[2].tds[7].text
	# end

	# def check_total
	# 	return self.tab_iFrame.table(:id=>"gvHistory").trs[2].tds[8].text
	# end

	# def check_unique
	# 	return self.tab_iFrame.table(:id=>"gvHistory").trs[2].tds[9].text
	# end

	# def non_unique
	# 	return self.tab_iFrame.table(:id=>"gvHistory").trs[2].tds[10].text
	# end
end


