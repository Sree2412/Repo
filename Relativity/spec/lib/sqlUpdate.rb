require 'tiny_tds'
require 'lib/Intake_Information'
require 'lib/Apc'
require 'byebug'

class SqlUpdate
	include TestFramework
	@apc = Apc.new
	@intakeinformation = IntakeInformation.new
	# custID = @intakeinformation.custodianID 
	# puts custID
	#client = TinyTds::Client.new dataserver:'MLVUDPRJ01', database:'H12568_EDD', timeout: 1000
	
	def sqlUpdateAPC
		client = TinyTds::Client.new dataserver:'MLVUDPRJ01', database:'H12568_EDD', username: 'kshrestha/consilio', password: 'Gorkha999kkk',timeout: 1000
		groupIdentifier = @apc.GetGroupIdentifier
		update = "UPDATE EXT.allCustodianTopLevel  
		  					SET fkCustID = fkCustID + 1
		 					 	WHERE topLevelGuid like '%#{groupIdentifier}%'"
		  
		update_result = client.execute(update)
		 
		select = "SELECT fkCustID 
								FROM EXT.allCustodianTopLevel
		            WHERE topLevelGuid like '%#{groupIdentifier}%'"
		            

		select_result = client.execute(select)
		
	  select_result.each do |row|
	  	@sql_CustId = row["fkCustID"]
  	end  	
  	return @sql_CustId
  end

  def sqlUpdateRDO()
  	client = TinyTds::Client.new dataserver:'MLVUDPRJ01', database:'H12568_EDD', timeout: 1000
  	# custID = @intakeinformation.custodianID 
  	# rdo_update = "UPDATE Source.custodian
			# 							SET displayName = displayName + '_NEW_TEST_KUMAR'
			# 							WHERE custId IN ('#{custID}');"
		select = "SELECT displayName FROM Source.Custodian WHERE custID = '#{custID}';"
		select_result_custodianName = client.execute(select)

		rdo_update = "UPDATE Source.custodian
		SET displayName = displayName + '_NEW_TEST_KUMAR'
		WHERE custId IN ('114);"
  	update_result_rdo = client.execute(rdo_update)
  	
  end

end
