
describe "Importing test data to the Relativity Smoke Workspace" do

 	context 'Importing test data using the WorkspaceImportApp' do
    it "Should import the test data file in to the specified workspace" do
    	# exec "post-install-import -mapping-file <mapping file path> -data-file <data file path> [-url <import API URL>] 
    	# [-username <Relativity username>] [-password <Relativity password>] [-workspace <workspace name>] [-workspaceID <workspace artifact ID>]	"
      
      exec ('spec\\WorkspaceImportApp\\post-install-import -mapping-file "C:\\GitHub\\QA\\Relativity\\spec\\SmokeTestDataImport\\Post-installation verification test data\\Salt-v-Pepper-kCura-Starter-Template.kwe" -data-file "C:\\GitHub\\QA\\Relativity\\spec\\SmokeTestDataImport\\Post-installation verification test data\\Salt-v-Pepper (US date format).dat" -url https://mtpctscid696.consilio.com/Relativitywebapi/ -username Smokeuser@kcura.com -password Password2! -workspaceID 1016296')
      #exec ("echo 'hi'")
    end

	end 

 
end 