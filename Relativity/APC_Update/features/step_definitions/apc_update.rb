@apc_update

When (/^I select Workspace name "([^"]*)" that I want to work on$/) do |workspace_Name|
	RelativityWorkspace.new.NavigateToWorkspace(workspace_Name)
	Document.new.DocumentViewFolder("APC Update View")
end


When (/^I update APC via "([^"]*)" and Row Id is "([^"]*)"$/)do |platform, row_id|
	
	Row_Id = row_id
	if (platform == "Relativity")
		# Here we Uncheck the APC value through Relativity
				Org_APCnumber = APC.new.readAPCVal(Row_Id)
				APC.new.SetAPCnumberToNil(Row_Id)		
				
	elsif (platform == "SQL")
		# Here we Update the APC value through SQL
				SqlUpdateAPCNumber = SqlUpdate.new.sqlUpdateAPC(Row_Id).to_i
	end		
end

When (/^I run the Update All Processed Custodian$/) do
	RelativityWorkspace.new.TabAccess("All Processed Custodian Update")
	APC.new.APCUpdateRun
end

Then (/^Verify Original APC Value to Value Updated thru "([^"]*)"$/)do |platform|
		 
	if (platform == "Relativity")			
			if (APC.new.CompareApcValueEquals(Org_APCnumber, Row_Id).should be true)
				puts "APC Update Thru Relativity was Successful!"
			end

	elsif (platform == "SQL")			
			if (APC.new.CompareApcValueEquals(SqlUpdateAPCNumber,Row_Id).should be true)
				puts "APC Update Thru SQL was Successful!"
			end			
	end		

end

