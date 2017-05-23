# rubocop:disable LineLength

require 'chef/provisioning'
require 'CSV'

###### Provisioning Variables ######

CSV_Path = "C:\\HK\\HK_Servers.csv"

# Provisioning Variables
ClusterName = 'HK_Production'.freeze
CreatePaths = 0 # if needing to create paths set this to 1
AttachedDrive = 'C:'.freeze
SQLDataDrive = 'D:'.freeze
RELSETUPONLY = 0
UPGRADE = 0 # If upgrading

# # 9.4
RelativityVersion = '9.4'.freeze



CAATIndexDir = "D:\\Indexes"

Rest_User = 'SP_HK1_REL_A'
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
inv_wrk = 0   # To just install the worker component
anx = 1       # To just upgrade the Analytics component
inv_cnv = 0   # To install worker Conversion

### Get the node names from search
servernames = []    # collect all server names to get the node counts
psql_servers = []   # collect primary sql server from the servernames array
dsql_servers = []   # collect dist sql server from the servernames array
web_servers = []    # collect web servers from the servernames array
agt_servers = []    # collect agt servers from the servernames array
wms_servers = []    # collect wms servers from the servernames array
wrk_servers = []    # collect wrk servers from the servernames array
anx_servers = []    # collect anx servers from the servernames array
cnv_servers = []    # collect cnv servers from the servernames array

#CSV File that has the servernames and roles
#csv_file = "C:\\Users\\kxmoss\\Documents\\AA - Projects\\2016\\94_Upgrade\\ProdServers.csv"

### increment the node count for each role and add the server names to role array
CSV.foreach(CSV_Path) do | x,y |
  servernames << x

  if y == 'Web'
    web_servers.push(x)
  elsif (y == 'Agent')
    agt_servers << x
  elsif y == 'SQL - Distributed'
    dsql_servers << x
  elsif y == 'SQL - Primary'
    psql_servers << x
  elsif y == 'Analytics Server'
    anx_servers << x
  elsif y == 'SQL - Invariant'
    wms_servers << x
  elsif y == 'Invariant Worker'
    wrk_servers << x
  elsif y == 'Agent (Service Bus)'
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
wrknodes = wrk_servers.count

# Search for host name value  
psql_servers.each do | psql_server |
  psql_hostname = psql_server
  psql_fqdn = "#{psql_server}.consilio.com"
end


wms_servers.each do | wms_server |
  wms_hostname = wms_server
  wms_fqdn = "#{wms_server}.consilio.com"
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
puts "########################### WRK Node Count: #{wrknodes}"
######## REMOVE AFTER TESTING ########

with_chef_server(
  'https://chef.consilio.com/organizations/consilio',
  client_name: Chef::Config[:node_name],
  signing_key_filename: Chef::Config[:client_key]
) do # begin with chef server
  with_driver 'ssh' do # begin with driver  

    ##########################################################
    # Installing Primary SQL Server
    ##########################################################
    if p_sql == 1 || all == 1 # Begin if p_sql or all flag is set to 1

      # Primary SQL Server - Relativity Install outside of batch
      Chef::Log.info('Installing Primary SQL Server Software...')
      
      machine psql_hostname do
        machine_options(
          transport_options: {
            is_windows: true,
            host: psql_hostname,
            username: ENV['VRA_USER'],
            password: ENV['VRA_PASS']
          }
        )
        run_list ['relativity-scaled-automation-sri']
        chef_environment 'hk_relativity'

        attribute %w(Relativity Version), RelativityVersion
        attribute %w(Relativity SQLPrimary Install), 1
        attribute %w(Relativity Upgrade SQL), UPGRADE
        attribute %w(Relativity Setup Only), RELSETUPONLY
        attribute %w(Relativity Install RelativityInstance), ClusterName
        attribute %w(Relativity Install SQLUseWinAuth), 1
        attribute %w(Relativity Install PrimaryInstance), psql_hostname
      
        action :converge
      end # End machine batch
    else
      puts '########################### No need to upgrade the Primary SQL server at this time...'
    end # End if p_sql or all flag is set to 1

    ############################################################
    # Prep Distributed SQL Server and Install Relativity
    ############################################################
    if dist_sql == 1 || all == 1 # begin if for DistributedSQL

      # Distributed SQL Server - Relativity Install
      Chef::Log.info('Installing Distributed SQL Server Software...')

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
            chef_environment 'hk_relativity'

            attribute %w(Relativity Version), RelativityVersion
            attribute %w(Relativity DistributedSQL Install), 1
            attribute %w(Relativity Upgrade DIST), UPGRADE
            attribute %w(Relativity Setup Only), RELSETUPONLY
            attribute %w(Relativity Install RelativityInstance), ClusterName
            attribute %w(Relativity Install SQLUseWinAuth), 1
            attribute %w(Relativity Install PrimaryInstance), psql_hostname
            attribute %w(Relativity DistributedSQL Instance), dsql_server
            
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
          chef_environment 'hk_relativity'

          attribute %w(Relativity Version), RelativityVersion
          attribute %w(Relativity Agent Install), 1
          attribute %w(Relativity ServiceBus Install), 1
          attribute %w(Relativity Agent Defaults), 0
          attribute %w(Relativity Install SQLUseWinAuth), 1
          attribute %w(Relativity Setup Only), RELSETUPONLY
          attribute %w(Relativity Install RelativityInstance), ClusterName
          attribute %w(Relativity Install PrimaryInstance), psql_hostname
          
          action :converge
        end # end machine block for conversion
      end # end machine_batch for conversion                              
    end # end if for conversion

    ############################################################
    # Install Web and Agent Servers
    ############################################################
    if agt == 1 || all == 1 # begin if for web and agent upgrade
      Chef::Log.info('Begin upgrade of Web and Agent Components...')

      machine_batch do # begin machine batch for agent upgrades
        # Install Agent Servers
        if agtnodes >= 1 # begin if for agtnodes >= 1
          Chef::Log.info('Installing Agent Server Software...')
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
              chef_environment 'hk_relativity'

              attribute %w(Relativity Version), RelativityVersion
              attribute %w(Relativity Agent Install), 1
              attribute %w(Relativity Upgrade AGT), UPGRADE
              attribute %w(Relativity Setup Only), RELSETUPONLY
              attribute %w(Relativity Install RelativityInstance), ClusterName
              attribute %w(Relativity Install SQLUseWinAuth), 1
              attribute %w(Relativity Install PrimaryInstance), psql_hostname
              
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
        # Install Web Servers
        if webnodes >= 1 # begin if for webnodes >= 1
          Chef::Log.info('Installing Web Server Software...')
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
              chef_environment 'hk_relativity'

              attribute %w(Relativity Version), RelativityVersion
              attribute %w(Relativity Web Install), 1
              attribute %w(Relativity Upgrade Web), UPGRADE
              attribute %w(Relativity Setup Only), RELSETUPONLY
              attribute %w(Relativity Install RelativityInstance), ClusterName
              attribute %w(Relativity Install SQLUseWinAuth), 1
              attribute %w(Relativity Install PrimaryInstance), psql_hostname
              
              # action :converge
            end # end machine block for web_servers
          end # end webserver loop
        else # else for webnodes >= 1
          Chef::Log.info('No Web Server Install Required...')
        end # end if for webnodes >= 1
      end # end machine batch for web upgrades     

    end # end if for web upgrade

    ############################################################
    # Install Worker Manger/Queue Manager Server
    ############################################################
    if inv_wms == 1 || all == 1

      # Install WMS Server
      Chef::Log.info('Installing Worker Manger Server and Queue Manager Software...')

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
        chef_environment 'hk_relativity'

        attribute %w(Relativity Version), RelativityVersion
        attribute %w(Relativity InvariantDatabase Install), 1
        attribute %w(Relativity InvariantQueueManager Install), 1
        attribute %w(Relativity Setup Only), RELSETUPONLY
        attribute %w(Relativity Install RelativityInstance), ClusterName
        attribute %w(Relativity Install SQLUseWinAuth), 1
        attribute %w(Relativity Install PrimaryInstance), psql_hostname
        attribute %w(Relativity Invariant SQLInstance), wms_hostname
        attribute %w(Relativity Install SQLUseWinAuth), 1
        
        action :converge
      end
    else
      Chef::Log.info('No need to build the WMS server at this time...')
    end

    if inv_wrk == 1 || all == 1

      machine_batch do ### begin machine batch to install worker components
        # Worker Servers (Processing/Imaging) - Relativity Install

        if wrknodes >= 1
          Chef::Log.info('Installing Processing/Imaging Worker Server Software...')
          wrk_servers.each do |wrk_hostname|
            machine wrk_hostname do
              machine_options(
                transport_options: {
                  is_windows: true,
                  ip_address: wrk_hostname,
                  username: ENV['VRA_USER'],
                  password: ENV['VRA_PASS']
                }
              )
              run_list ['relativity-scaled-automation-sri']
              chef_environment 'hk_relativity'

              attribute %w(Relativity Version), RelativityVersion
              attribute %w(Relativity InvariantWorker Install), 1
              attribute %w(Relativity Setup Only), RELSETUPONLY
              attribute %w(Relativity Install RelativityInstance), ClusterName
              attribute %w(Relativity Install SQLUseWinAuth), 1
              attribute %w(Relativity Install PrimaryInstance),psql_hostname
              attribute %w(Relativity Invariant SQLInstance),wms_hostname

              action :converge
            end
          end
        else
          Chef::Log.info('No Processing/Imaging Worker Server Software Required...')
        end        
      end ### end machine batch to install worker components
    else
      puts 'Worker Components are not required...'
    end

    ############################################################
    # Install Analytics Servers
    ############################################################
    if anx == 1 || all == 1 # begin if for Analytics upgrade

      # Analytics Server - Relativity Install
      Chef::Log.info('Installing Analytics Server Software...')

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
          chef_environment 'hk_relativity'

          attribute %w(Relativity Version), RelativityVersion
          attribute %w(Relativity Analytics Install), 1
          attribute %w(Relativity Setup Only), RELSETUPONLY
          attribute %w(Relativity Install RelativityInstance), ClusterName
          attribute %w(Relativity Analytics RestUser), Rest_User
          attribute %w(Relativity Analytics RestPassword), Rest_Pass
          attribute %w(Relativity Analytics CAATIndexDir), CAATIndexDir
          attribute %w(Relativity Install PrimaryInstance), psql_hostname
          
          action :converge
        end # end machine block for anx_servers
      end # end anx_servers loop
    else # else for Analytics upgrade
      Chef::Log.info('No Analytics Server to install at this time...')
    end # end if for Analytics upgrade  

  end # end with driver
end # end with chef server
