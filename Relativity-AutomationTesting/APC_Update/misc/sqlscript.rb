	require 'tiny_tds'

	client = TinyTds::Client.new dataserver:'HLPROJU01', database:'H12568_EDD', timeout: 1000
		    
		groupIdentifier = "a2a9280f-4d0b-4b69-b2cf-07200cbbb158"
		update = "UPDATE 	EXT.allCustodianTopLevel  
		  					SET  fkCustID = fkCustID + 1
		  					WHERE topLevelGuid like '%#{groupIdentifier}%'"
		  					# WHERE 	topLevelGuid = 'a2a9280f-4d0b-4b69-b2cf-07200cbbb158'"
		 					 			  
		update_result = client.execute(update)
		 
		select = "SELECT 	fkCustID 
								FROM 	EXT.allCustodianTopLevel
								WHERE topLevelGuid like '%#{groupIdentifier}%'"
		            # WHERE 	topLevelGuid = 'a2a9280f-4d0b-4b69-b2cf-07200cbbb158'"
		          
		select_result = client.execute(select)
		
	  select_result.each do |row|
	  	@sql_CustId = row["fkCustID"]

	 end
			puts @sql_CustId
	  	puts "hello world"