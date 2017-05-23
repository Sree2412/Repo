
class SqlUpdate < APC
	
	def sqlUpdateAPC(rowindex)
		client = TinyTds::Client.new dataserver:'HLPROJU01', database:'H12568_EDD', timeout: 1000
		groupIdentifier = APC.new.GetGroupIdentifier(rowindex)     
		update = "UPDATE 	EXT.allCustodianTopLevel  
		  					SET  fkCustID = fkCustID + 1
		 					 	WHERE topLevelGuid like '%#{groupIdentifier}%'"
		  
		update_result = client.execute(update)
		 
		select = "SELECT 	fkCustID 
								FROM 	EXT.allCustodianTopLevel
		            WHERE topLevelGuid like '%#{groupIdentifier}%'"
		            

		select_result = client.execute(select)
		
	  select_result.each do |row|
	  	@sql_CustId = row["fkCustID"]
  	end  	
  	return @sql_CustId
  end

end
