# rubocop:disable LineLength

require 'chef/provisioning'
require 'CSV'

###### Provisioning Variables ######

CSV_Path = "C:\\94Upgrade\\UKServers.csv"

# Provisioning Variables
ClusterName = 'HURONUKPROD01'.freeze
CreatePaths = 0 # if needing to create paths set this to 1
AttachedDrive = 'C:'.freeze
SQLDataDrive = 'D:'.freeze
RELSETUPONLY = 0
UPGRADE = 0 # If upgrading
Rel_Recommended = 0 # if needing to apply relativity recommended features, roles and optimization

########## Exe and MSI packages ##########
# # 9.4
RelativityVersion = '9.4'.freeze


# Databag Credentials
Rel_ServiceAcct = Chef::EncryptedDataBagItem.load('serviceaccounts', 'uk_prod_serviceaccountpassword', 'consiliopass123')['username']
Rel_ServiceAcct_Password = Chef::EncryptedDataBagItem.load('serviceaccounts', 'uk_prod_serviceaccountpassword', 'consiliopass123')['password']
SQL_ServiceAcct = Chef::EncryptedDataBagItem.load('serviceaccounts', 'uk_prod_serviceaccountpassword', 'consiliopass123')['username']
SQL_ServiceAcct_Password = Chef::EncryptedDataBagItem.load('serviceaccounts', 'uk_prod_serviceaccountpassword', 'consiliopass123')['password']
EDDSDBOPassword = Chef::EncryptedDataBagItem.load('serviceaccounts', 'uk_prod_eddsdbopassword', 'consiliopass123')['password']
WildCardPassword = Chef::EncryptedDataBagItem.load('wildcardcreds', 'wildcard-password', 'consiliopass123')['password']


DSQL_DB_BackupDir = "D:\\SYSTEM_DATA\\SYSTEM_01\\Backup"
DSQL_DB_LogsDir = "D:\\TLOG\\TLOG_01"
DSQL_DB_DataDir = "D:\\USER_DATA\\DATA_01"
DSQL_DB_FullTextDir = "D:\\USER_DATA\\DATA_01"

CAATIndexDir = "E:\\ContentAnalyst\\device-links\\caat"

Rest_User = 'SLP_UK_REL_A'
Rest_Pass = 'Awesome17!'

# Primary SQL and WMS Server Variables
psql_hostname = ""
psql_fqdn = ""
wms_hostname = ""
wms_fqdn = ""
cnv_hostname = ""

### Set Machine Batch to run_list ###
# If just want to build the machines set vms = 1 and others to 0

all = 0	      # To run all
p_sql = 0 	  # To just upgrade the Primary SQL component
dist_sql = 0 	# To just upgrade the Primary SQL component
web = 0 		  # To just upgrade web components
agt = 0 		  # To just upgrade agt components
inv_wms = 0		# To just upgrade the WMS component
anx = 1       # To just upgrade the Analytics component
inv_cnv = 0   # To install worker Conversion

### Get the node names from search
servernames = []    # collect all server names to get the node counts
psql_servers = []   # collect primary sql server from the servernames array
dsql_servers = []   # collect dist sql server from the servernames array
web_servers = []    # collect web servers from the servernames array
agt_servers = []    # collect agt servers from the servernames array
wms_servers = []    # collect wms servers from the servernames array
anx_servers = []    # collect anx servers from the servernames array
cnv_servers = []    # collect cnv servers from the servernames array

#CSV File that has the servernames and roles
#csv_file = "C:\\Users\\kxmoss\\Documents\\AA - Projects\\2016\\94_Upgrade\\ProdServers.csv"

### increment the node count for each role and add the server names to role array
CSV.foreach(CSV_Path) do | x,y |
  servernames << x

  if y == 'Web'
    web_servers.push(x)
  elsif (y == 'Agent') || (y == 'Conversion Agent Server')
    agt_servers << x
  elsif y == 'SQL - Distributed'
    dsql_servers << x
  elsif y == 'SQL - Primary'
    psql_servers << x
  elsif y == 'Analytics Server'
    anx_servers << x
  elsif y == 'Worker Manager Server'
    wms_servers << x
  elsif y == 'Conversion Agent Server (RSB)'
    cnv_servers << x
  else
    puts "There is no action to be performed for this item - Name: #{x} - Role: #{y}"
  end
end

### Set the node counts based on search
sqlnodes = psql_servers.count
distnodes = dsql_servers.count
webnodes = web_servers.count
anxnodes = anx_servers.count
agtnodes = agt_servers.count
wmsnodes = wms_servers.count

# Search for host name value  
psql_servers.each do | psql_server |
  psql_hostname = psql_server
  psql_fqdn = "#{psql_server}.consilio.com"
end

wms_servers.each do | wms_server |
  wms_hostname = wms_server
  wms_fqdn = "#{wms_server}.consilio.com"
  puts "WMS Server: #{wms_hostname}"
end  

cnv_servers.each do | cnv_server |
  cnv_hostname = cnv_server
  puts "Conversion Server: #{cnv_hostname}"
end  

######## REMOVE AFTER TESTING ########
puts "########################### SQL Node Count: #{sqlnodes}"
puts "########################### Dist Node Count: #{distnodes}"
puts "########################### Web Node Count: #{webnodes}"
puts "########################### AGT Node Count: #{agtnodes}"
puts "########################### WMS Node Count: #{wmsnodes}"
puts "########################### ANX Node Count: #{anxnodes}"
######## REMOVE AFTER TESTING ########

with_chef_server(
  'https://chef.consilio.com/organizations/consilio-dev',
  client_name: Chef::Config[:node_name],
  signing_key_filename: Chef::Config[:client_key]
) do # begin with chef server
  with_driver 'ssh' do # begin with driver

    ##########################################################
    # Before Upgrading, IIS and Agent services must be stopped
    ##########################################################
    if UPGRADE == 1

      puts 'Stopping Services...'

      machine_batch do # begin machine batch for secondary components (DistSQL, Web, WebRDC, Agt)

        web_servers.each do | web_server |
          puts "Stopping IIS service on: #{web_server}"
          machine "#{web_server}.consilio.com" do
            machine_options(
              transport_options: {
                is_windows: true,
                host: "#{web_server}.consilio.com",
                username: ENV['VRA_USER'],
                password: ENV['VRA_PASS']
              }
            )
            run_list ['relativity-scaled-automation-sri::upgrade_stop_iis_services']
            chef_environment '92_test'
          end
        end

        agt_servers.each do | agt_server |
          puts "Stopping Agent service on: #{agt_server}"
          machine "#{agt_server}.consilio.com" do
            machine_options(
              transport_options: {
                is_windows: true,
                host: "#{agt_server}.consilio.com",
                username: ENV['VRA_USER'],
                password: ENV['VRA_PASS']
              }
            )
            run_list ['relativity-scaled-automation-sri::upgrade_stop_agent_services']
            chef_environment '92_test'
          end
        end    

        action :converge
      end      
    end

    ##########################################################
    # Upgrading Primary SQL Server
    ##########################################################
    if p_sql == 1 || all == 1 # Begin if p_sql or all flag is set to 1

      # Primary SQL Server - Relativity Install outside of batch
      Chef::Log.info('Upgrading Primary SQL Server Software...')
      
      machine "#{psql_hostname}.consilio.com" do
        machine_options(
          transport_options: {
            is_windows: true,
            host: "#{psql_hostname}.consilio.com",
            username: ENV['VRA_USER'],
            password: ENV['VRA_PASS']
          }
        )
        run_list ['relativity-scaled-automation-sri']
        chef_environment '92_test'

        attribute %w(Relativity Source URL), RelativityInstallURL
        attribute %w(Relativity Source EXE), CoreInstallPackage
        attribute %w(Relativity Version), RelativityVersion
        attribute %w(Relativity SQLPrimary Install), 1
        attribute %w(Relativity Upgrade SQL), UPGRADE
        attribute %w(Relativity Setup Only), RELSETUPONLY
        attribute %w(Relativity Install RelativityInstance), ClusterName
        attribute %w(Relativity Install SQLUseWinAuth), 1
        attribute %w(Attached DriveLetter), AttachedDrive
        attribute %w(Relativity Database BackupDir), PSQL_DB_BackupDir
        attribute %w(Relativity Database LogsDir), PSQL_DB_LogsDir
        attribute %w(Relativity Database DataDir), PSQL_DB_DataDir
        attribute %w(Relativity Database FullTextDir), PSQL_DB_FullTextDir
        attribute %w(Relativity Install Dir), 'C:\\Program Files\\kCura Corporation\\Relativity\\'
        attribute %w(Relativity Install PrimaryInstance), psql_hostname
        attribute %w(Relativity SQLPrimary FileRepo), PSQL_FileRepo
        attribute %w(Relativity SQLPrimary EDDSFileShare), PSQL_EDDSFileShare
        attribute %w(Relativity SQLPrimary DTSearch), PSQL_DTSearch
        attribute %w(Relativity Relativity Service_Account), Rel_ServiceAcct
        attribute %w(Relativity Relativity Service_Account_Password), Rel_ServiceAcct_Password
        attribute %w(Relativity SQLServer Service_Account), SQL_ServiceAcct
        attribute %w(Relativity SQLServer Service_Account_Password), SQL_ServiceAcct_Password
        attribute %w(Relativity eddsdbo Password), EDDSDBOPassword
        attribute %w(Install CreatePaths), CreatePaths
        attribute %w(Install Recommended), Rel_Recommended

        action :converge
      end # End machine batch
    else
      puts '########################### No need to upgrade the Primary SQL server at this time...'
    end # End if p_sql or all flag is set to 1

    ############################################################
    # Prep Distributed SQL Server and Upgrade Relativity
    ############################################################
    if dist_sql == 1 || all == 1 # begin if for DistributedSQL

      # Distributed SQL Server - Relativity Upgrade
      Chef::Log.info('Upgrading Distributed SQL Server Software...')

      if distnodes >= 1 # begin if for distnodes >= 1
        dsql_servers.each do | dsql_server | # begin dsql_servers loop
          machine dsql_server do # begin machine batch for DistributedSQL 
            machine_options(
              transport_options: {
                is_windows: true,
                ip_address: dsql_server,
                username: ENV['VRA_USER'],
                password: ENV['VRA_PASS']
              }
            )
            run_list ['relativity-scaled-automation-sri']
            chef_environment '92_test'

            attribute %w(Relativity Source URL), RelativityInstallURL
            attribute %w(Relativity Source EXE), CoreInstallPackage
            attribute %w(Relativity Version), RelativityVersion
            attribute %w(Relativity DistributedSQL Install), 1
            attribute %w(Relativity Upgrade DIST), UPGRADE
            attribute %w(Relativity Setup Only), RELSETUPONLY
            attribute %w(Relativity Install RelativityInstance), ClusterName
            attribute %w(Relativity Install SQLUseWinAuth), 1
            attribute %w(Attached DriveLetter), AttachedDrive
            attribute %w(Relativity Database BackupDir), DSQL_DB_BackupDir
            attribute %w(Relativity Database LogsDir), DSQL_DB_LogsDir
            attribute %w(Relativity Database DataDir), DSQL_DB_DataDir
            attribute %w(Relativity Database FullTextDir), DSQL_DB_FullTextDir
            attribute %w(Relativity Install Dir), 'C:\\Program Files\\kCura Corporation\\Relativity\\'
            attribute %w(Relativity Install PrimaryInstance), psql_hostname
            attribute %w(Relativity DistributedSQL Instance), dsql_server
            attribute %w(Relativity Relativity Service_Account), Rel_ServiceAcct
            attribute %w(Relativity Relativity Service_Account_Password), Rel_ServiceAcct_Password
            attribute %w(Relativity SQLServer Service_Account), SQL_ServiceAcct
            attribute %w(Relativity SQLServer Service_Account_Password), SQL_ServiceAcct_Password
            attribute %w(Relativity eddsdbo Password), EDDSDBOPassword
            attribute %w(Install CreatePaths), CreatePaths
            attribute %w(Install Recommended), Rel_Recommended

            action :converge
          end # end machine batch for DistributedSQL
        end # end dsql_servers loop
      else # else for distnodes >= 1
        Chef::Log.info('No DistributedSQL Server Software Required...')
      end # end if for distnodes >= 1

    else # esle for DistributedSQL
      Chef::Log.info('No need to upgrade the DIST server at this time...')
    end # end if for DistributedSQL

    # Worker Conversion server, will upgrade Relativity Service bus agent
    # after the primary sql
    if inv_cnv == 1 || all == 1 # begin if for conversion

      machine_batch do # begin machine_batch for conversion
        puts "Conversion Server (In block): #{cnv_hostname}"
          machine cnv_hostname do # begin machine block for conversion
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: cnv_hostname,
              username: ENV['VRA_USER'],
              password: ENV['VRA_PASS']
            }
          )
          run_list ['relativity-scaled-automation-sri']
          chef_environment '92_test'

          attribute %w(Relativity Source URL), RelativityInstallURL
          attribute %w(Relativity Source EXE), CoreInstallPackage
          attribute %w(Relativity Version), RelativityVersion
          attribute %w(Relativity Agent Install), 1
          attribute %w(Relativity ServiceBus Install), 1
          attribute %w(Relativity Agent Defaults), 0
          attribute %w(Relativity Install SQLUseWinAuth), 1
          attribute %w(Relativity Setup Only), RELSETUPONLY
          attribute %w(Relativity Install RelativityInstance), ClusterName
          attribute %w(Relativity Install Dir), 'C:\\Program Files\\kCura Corporation\\Relativity\\'
          attribute %w(Relativity Install PrimaryInstance), psql_hostname
          attribute %w(Relativity Relativity Service_Account), Rel_ServiceAcct
          attribute %w(Relativity Relativity Service_Account_Password), Rel_ServiceAcct_Password
          attribute %w(Relativity SQLServer Service_Account), SQL_ServiceAcct
          attribute %w(Relativity SQLServer Service_Account_Password), SQL_ServiceAcct_Password
          attribute %w(Relativity eddsdbo Password), EDDSDBOPassword
          attribute %w(Install Recommended), Rel_Recommended

          action :converge
        end # end machine block for conversion
      end # end machine_batch for conversion                              
    end # end if for conversion

    ############################################################
    # Upgrade Web and Agent Servers
    ############################################################
    if agt == 1 || all == 1 # begin if for web and agent upgrade
      Chef::Log.info('Begin upgrade of Web and Agent Components...')

      machine_batch do # begin machine batch for agent upgrades
        # Upgrade Agent Servers
        if agtnodes >= 1 # begin if for agtnodes >= 1
          Chef::Log.info('Upgrading Agent Server Software...')
          agt_servers.each do | agt_server | # begin loop for agt_servers
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
              chef_environment '92_test'

              attribute %w(Relativity Source URL), RelativityInstallURL
              attribute %w(Relativity Source EXE), CoreInstallPackage
              attribute %w(Relativity Version), RelativityVersion
              attribute %w(Relativity Agent Install), 1
              attribute %w(Relativity Upgrade AGT), UPGRADE
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

              # action :converge
            end # end machine block for agt_servers
          end # end loop for agt_servers
        else # else for agtnodes >= 1
          Chef::Log.info('No Agent Server Software Required...')
        end # end if for agtnodes >= 1
      end # end machine batch for agent upgrades
    end # end if for agent upgrade

    if web == 1 || all == 1
      machine_batch do # begin machine batch for web upgrade
        # Upgrade Web Servers
        if webnodes >= 1 # begin if for webnodes >= 1
          Chef::Log.info('Upgrading Web Server Software...')
          web_servers.each do | web_server | # begin webserver loop
            machine web_server do # begin machine block for web_servers
              machine_options(
                transport_options: {
                  is_windows: true,
                  ip_address: web_server,
                  username: ENV['VRA_USER'],
                  password: ENV['VRA_PASS']
                }
              )
              run_list ['relativity-scaled-automation-sri']
              chef_environment '92_test'

              attribute %w(Relativity Source URL), RelativityInstallURL
              attribute %w(Relativity Source EXE), CoreInstallPackage
              attribute %w(Relativity Version), RelativityVersion
              attribute %w(Relativity Web Install), 1
              attribute %w(Relativity Upgrade Web), UPGRADE
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
              attribute %w(Consilio SSL PFXPassword), WildCardPassword
              attribute %w(Install Recommended), Rel_Recommended

              # action :converge
            end # end machine block for web_servers
          end # end webserver loop
        else # else for webnodes >= 1
          Chef::Log.info('No Web Server Upgrade Required...')
        end # end if for webnodes >= 1
      end # end machine batch for web upgrades     

    end # end if for web upgrade

    ############################################################
    # Upgrade Worker Manger/Queue Manager Server
    ############################################################
    if inv_wms == 1 || all == 1

      # Upgrade WMS Server
      Chef::Log.info('Upgrading Worker Manger Server and Queue Manager Software...')
      puts "WMS Server Block: #{wms_hostname}"
      machine wms_hostname do
        machine_options(
          transport_options: {
            is_windows: true,
            ip_address: wms_hostname,
            username: ENV['VRA_USER'],
            password: ENV['VRA_PASS']
          }
        )
        run_list ['relativity-scaled-automation-sri']
        chef_environment '92_test'

        attribute %w(Relativity InvariantSource URL), InvariantInstallURL
        attribute %w(Relativity InvariantSource EXE), InvariantInstallPackage
        attribute %w(Relativity Version), RelativityVersion
        attribute %w(Relativity InvariantDatabase Install), 1
        attribute %w(Relativity InvariantQueueManager Install), 1
        attribute %w(Relativity Setup Only), RELSETUPONLY
        attribute %w(Relativity Install RelativityInstance), ClusterName
        attribute %w(Relativity Install SQLUseWinAuth), 1
        attribute %w(Attached DriveLetter), AttachedDrive
        attribute %w(Relativity InvariantDatabase DataDir), DB_DataDir
        attribute %w(Relativity InvariantDatabase LogsDir), DB_DataDir
        attribute %w(Relativity Invariant QueueManagerInstallPath), 'C:\\Program Files\\kCura Corporation\\Invariant\\QueueManager\\'
        attribute %w(Relativity Install PrimaryInstance), psql_hostname
        attribute %w(Relativity Invariant SQLInstance), wms_hostname
        attribute %w(Relativity Invariant WorkerNetworkPath), INV_WorkerNetworkPath
        attribute %w(Relativity Invariant DTSearchPath), PSQL_DTSearch
        attribute %w(Relativity Invariant FilesharePath), INV_FileSharePath
        attribute %w(Relativity Install SQLUseWinAuth), 1
        attribute %w(Relativity Relativity Service_Account), Rel_ServiceAcct
        attribute %w(Relativity Relativity Service_Account_Password), Rel_ServiceAcct_Password
        attribute %w(Relativity SQLServer Service_Account), SQL_ServiceAcct
        attribute %w(Relativity SQLServer Service_Account_Password), SQL_ServiceAcct_Password
        attribute %w(Relativity eddsdbo Password), EDDSDBOPassword
        attribute %w(Install CreatePaths), CreatePaths
        attribute %w(Install Recommended), Rel_Recommended

        action :converge
      end
    else
      Chef::Log.info('No need to build the WMS server at this time...')
    end

    ############################################################
    # Upgrade Analytics Servers
    ############################################################
    if anx == 1 || all == 1 # begin if for Analytics upgrade

      # Analytics Server - Relativity Install
      Chef::Log.info('Upgrading Analytics Server Software...')

      anx_servers.each do | anx_server | # begin anx_servers loop
        machine anx_server do # begin machine block for anx_servers
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: anx_server,
              username: ENV['VRA_USER'],
              password: ENV['VRA_PASS']
            }
          )
          run_list ['relativity-scaled-automation-sri']
          chef_environment '92_test'

          attribute %w(Relativity Source AnalyticsURL), AnalyticsInstallURL
          attribute %w(Relativity Source MSI), AnalyticsInstallPackage
          attribute %w(Relativity Version), RelativityVersion
          attribute %w(Relativity Analytics Install), 1
          attribute %w(Relativity Setup Only), RELSETUPONLY
          attribute %w(Relativity Install RelativityInstance), ClusterName
          attribute %w(Relativity Analytics RestUser), Rest_User
          attribute %w(Relativity Analytics RestPassword), Rest_Pass
          attribute %w(Attached DriveLetter), AttachedDrive
          attribute %w(Relativity Analytics CAATIndexDir), CAATIndexDir
          attribute %w(Relativity Install PrimaryInstance), psql_hostname
          attribute %w(Relativity Relativity Service_Account), Rel_ServiceAcct
          attribute %w(Relativity Relativity Service_Account_Password), Rel_ServiceAcct_Password
          attribute %w(Relativity SQLServer Service_Account), SQL_ServiceAcct
          attribute %w(Relativity SQLServer Service_Account_Password), SQL_ServiceAcct_Password
          attribute %w(Relativity eddsdbo Password), EDDSDBOPassword
          attribute %w(Install CreatePaths), CreatePaths
          attribute %w(Install Recommended), Rel_Recommended

          action :converge
        end # end machine block for anx_servers
      end # end anx_servers loop
    else # else for Analytics upgrade
      Chef::Log.info('No Analytics Server to install at this time...')
    end # end if for Analytics upgrade

    ##########################################################
    # After Upgrading, IIS and Agent services must be started
    ##########################################################
    if UPGRADE == 1

      puts 'Starting Services...'

      machine_batch do # begin machine batch for secondary components (DistSQL, Web, WebRDC, Agt)

        web_servers.each do | web_server |
          puts "Starting IIS service on: #{web_server}"
          machine "#{web_server}.consilio.com" do
            machine_options(
              transport_options: {
                is_windows: true,
                host: "#{web_server}.consilio.com",
                username: ENV['VRA_USER'],
                password: ENV['VRA_PASS']
              }
            )
            run_list ['relativity-scaled-automation-sri::upgrade_start_iis_services']
            chef_environment '92_test'
          end
        end

        agt_servers.each do | agt_server |
          puts "Starting Agent service on: #{agt_server}"
          machine "#{agt_server}.consilio.com" do
            machine_options(
              transport_options: {
                is_windows: true,
                host: "#{agt_server}.consilio.com",
                username: ENV['VRA_USER'],
                password: ENV['VRA_PASS']
              }
            )
            run_list ['relativity-scaled-automation-sri::upgrade_start_agent_services']
            chef_environment '92_test'
          end
        end    

        action :converge
      end      
    end

  end # end with driver
end # end with chef server
