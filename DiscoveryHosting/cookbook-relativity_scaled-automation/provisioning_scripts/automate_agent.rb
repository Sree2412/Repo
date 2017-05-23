# rubocop:disable LineLength

require 'chef/provisioning'
require 'CSV'

chef_server_url = 'https://chef.consilio.com/organizations/consilio'
###### Provisioning Variables ######

CSV_Path = "C:\\94Upgrade\\USProdServers.csv"

# Provisioning Variables
ClusterName = 'us_relativity'.freeze
RELSETUPONLY = 0
Rel_Recommended = 0 # if needing to apply relativity recommended features, roles and optimization
Chef_Environment = 'us_relativity'
SkipStep = 0
SkipResponse = 0

########## Exe and MSI packages ##########
# # 9.4
RelativityVersion = '9.4'.freeze
RelativityInstallURL = 'https://packages.consilio.com/hlnas00/tech/Software/Relativity/9.4/'.freeze
InvariantInstallURL = 'https://packages.consilio.com/hlnas00/tech/Software/Relativity/9.4/'.freeze
AnalyticsInstallURL = 'https://packages.consilio.com/hlnas00/tech/Software/Relativity/9.4/'.freeze

CoreInstallPackage = '9.4.378.21_Relativity_Installation_Package.exe'.freeze
InvariantInstallPackage = 'Relativity_9.4.378.21_-_Invariant_4.4.378.5_Processing_Installation_Package.exe'.freeze
AnalyticsInstallPackage = 'Relativity_9.4.378.21_Analytics_Server.msi'.freeze

# Databag Credentials
Rel_ServiceAcct = Chef::EncryptedDataBagItem.load('serviceaccounts', 'us-serviceaccount', 'consiliopass123')['username']
Rel_ServiceAcct_Password = Chef::EncryptedDataBagItem.load('serviceaccounts', 'us-serviceaccount', 'consiliopass123')['password']
SQL_ServiceAcct = Chef::EncryptedDataBagItem.load('serviceaccounts', 'us-serviceaccount', 'consiliopass123')['username']
SQL_ServiceAcct_Password = Chef::EncryptedDataBagItem.load('serviceaccounts', 'us-serviceaccount', 'consiliopass123')['password']
EDDSDBOPassword = Chef::EncryptedDataBagItem.load('serviceaccounts', 'us_eddsdbopassword', 'consiliopass123')['password']

### Get the node names from search
servernames = []    # collect all server names to get the node counts
psql_servers = []   # collect primary sql server from the servernames array
agt_servers = []    # collect agt servers from the servernames array

#CSV File that has the servernames and roles
#csv_file = "C:\\Users\\kxmoss\\Documents\\AA - Projects\\2016\\94_Upgrade\\ProdServers.csv"

### increment the node count for each role and add the server names to role array
CSV.foreach(CSV_Path) do | x,y |
  servernames << x

  if (y == 'Agent')
    agt_servers << x
  elsif y == 'SQL - Primary'
    psql_servers << x  
  else
    puts "There is no action to be performed for this item - Name: #{x} - Role: #{y}"
  end
end

### Set the node counts based on search
agtnodes = agt_servers.count

# Primary SQL and WMS Server Variables
psql_hostname = ""
psql_fqdn = ""

# Search for host name value  
psql_servers.each do | psql_server |
  psql_hostname = psql_server
  psql_fqdn = "#{psql_server}.consilio.com"
  puts "#### PRIMARY SQL SERVER: #{psql_hostname} ####"
end

######## REMOVE AFTER TESTING ########
puts "########################### AGT Node Count: #{agtnodes}"
######## REMOVE AFTER TESTING ########

with_chef_server(
  chef_server_url,
  client_name: Chef::Config[:node_name],
  signing_key_filename: Chef::Config[:client_key]
) do # begin with chef server
  with_driver 'ssh' do # begin with driver  

    ############################################################
    # Upgrade Web and Agent Servers
    ############################################################
    machine_batch do # begin machine batch for agent upgrades
      # Upgrade Agent Servers
      if agtnodes >= 1 # begin if for agtnodes >= 1
        Chef::Log.info('Upgrading Agent Server Software...')
        agt_servers.each do | agt_server | # begin loop for agt_servers
          puts "###### AGENT SERVER: #{agt_server}"
          machine agt_server do # begin machine block for agt_servers
            machine_options(
              transport_options: {
                is_windows: true,
                ip_address: agt_server,
                username: ENV['VRA_USER'],
                password: ENV['VRA_PASS']
              }
            )
            run_list ['relativity-scaled-automation-sri']              
            chef_environment Chef_Environment

            attribute %w(Relativity Source URL), RelativityInstallURL
            attribute %w(Relativity Source EXE), CoreInstallPackage
            attribute %w(Relativity Version), RelativityVersion
            attribute %w(Relativity Agent Install), 1
            attribute %w(Relativity Setup Only), RELSETUPONLY
            attribute %w(Relativity Install RelativityInstance), ClusterName
            attribute %w(Relativity Install SQLUseWinAuth), 1
            attribute %w(Relativity Install Dir), 'C:\\Program Files\\kCura Corporation\\Relativity\\'
            attribute %w(Relativity Install PrimaryInstance), psql_hostname
            attribute %w(Relativity Relativity Service_Account), Rel_ServiceAcct
            attribute %w(Relativity Relativity Service_Account_Password), Rel_ServiceAcct_Password
            attribute %w(Relativity SQLServer Service_Account), SQL_ServiceAcct
            attribute %w(Relativity SQLServer Service_Account_Password), SQL_ServiceAcct_Password
            attribute %w(Relativity eddsdbo Password), EDDSDBOPassword
            attribute %w(Install Recommended), Rel_Recommended
            attribute %w(Relativity Skip Step), SkipStep
            attribute %w(Relativity Skip ResponseFile), SkipResponse

            action :converge
          end # end machine block for agt_servers
        end # end loop for agt_servers
      end # end if for agtnodes >= 1
    end # end machine batch for agent upgrades   
  end # end with driver
end # end with chef server
