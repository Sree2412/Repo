# <select name="rptConditions$ctl01$ddlConditionType" onchange="javascript:setTimeout('__doPostBack(\'rptConditions$ctl01$ddlConditionType\',\'\')', 0)" id="rptConditions_ctl01_ddlConditionType" class="form-control" style="width:8.5em;">
# 	<option value="Equal">Equal</option>
# 	<option value="Not Equal">Not Equal</option>
# 	<option value="Is set">Is set</option>
# 	<option selected="selected" value="Is not set">Is not set</option>

# </select>

# //*[@id="rptConditions_ctl01_ddlConditionType"]
#rptConditions_ctl01_ddlConditionType
# #rptConditions_ctl01_ddlConditionType
# //*[@id="rptConditions_ctl01_ddlConditionType"]

# #rptConditions_ctl01_ddlConditionType > option:nth-child(1)
# add_operator = GetElement("rptConditions_ctl01_ddlConditionType > option:nth-child(1)")
# def remove_configurations
# 	begin n = 11
# 		while n>-1 do
# 			n_string = n.to_s.rjust(2, '0')
# 			if BROWSERR.iframe(:id=>"_externalPage").a(:id=>"rptConditions_ctl#{n_string}_btnRemoveCondition").span.exists?
# 				BROWSERR.iframe(:id=>"_externalPage").a(:id=>"rptConditions_ctl#{n_string}_btnRemoveCondition").span.click
# 				puts "One condition deleted"
# 			 else
# 				puts "No condition to delete"
# 			end
# 			n=n-1
# 		end
# 	end
# end
