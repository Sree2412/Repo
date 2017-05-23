# rubocop:disable LineLength

require 'chef/provisioning'
require 'CSV'

# Provisioning Variables
RelativityVersion = '9.4'
ClusterName = 'knwldgexfer'
CampusCode = 'DEV'
Chef_Environment = 'knwldgexfer'
Chef_Server = 'https://chef.consilio.com/organizations/consilio-dev'
With_Driver = 'ssh'
RELSETUPONLY = 0
SkipStep = 1

### Set Machine Batch to run_list ###
# If just want to build the machines set vms = 1 and others to 0
vms = 0 # To just create the VMS

all = 0	      # To run all
p_sql = 0 	  # To just install the Primary SQL component
core = 0 		  # To just install core components or the 2 machine batch
inv_wms = 0		# To just install the WMS component ( this is within the core installs so if you run core and you don't want WMS set WMS = 0 else set it to 1 so that it will install)
anx = 1       # To just install the Analytics component ( this is within the core installs so if you run core and you don't want Analytics set anx = 0 else set it to 1 so that it will install)
inv_wrk = 0	  # To just install the Worker component
inv_cnv = 0   # To install worker Conversion

### Create arrays to house hostnames
servernames = []    # collect all server names to get the node counts
psql_servers = []   # collect primary sql server from the servernames array
dsql_servers = []   # collect dist sql server from the servernames array
web_servers = []    # collect web servers from the servernames array
rdc_servers = []    # collect web servers from the servernames array
agt_servers = []    # collect agt servers from the servernames array
wms_servers = []    # collect wms servers from the servernames array
wrk_servers = []    # collect wrk servers from the servernames array
anx_servers = []    # collect anx servers from the servernames array
cnv_servers = []    # collect cnv servers from the servernames array

# Path to CSV that has hostnames of servers
CSV_Path = "C:\\knowledgeshare\\TestServers.csv"

### increment the node count for each role and add the server names to role array
CSV.foreach(CSV_Path) do | x,y |
  servernames << x

  if y == 'Web'
    web_servers.push(x)
  elsif y == 'Web (Forms Auth)'
    rdc_servers.push(x)
  elsif (y == 'Agent') || (y == 'Conversion Agent Server')
    agt_servers << x
  elsif y == 'Dist SQL'
    dsql_servers << x
  elsif y == 'Primary SQL'
    psql_servers << x
  elsif y == 'Analytics'
    anx_servers << x
  elsif y == 'WMS'
    wms_servers << x
  elsif y == 'Worker'
    wrk_servers << x
  elsif y == 'Service Bus'
    cnv_servers << x
  else
    puts "There is no action to be performed for this item - Name: #{x} - Role: #{y}"
  end
end

### Set the node counts based on search
sqlnodes = psql_servers.count
distnodes = dsql_servers.count
webnodes = web_servers.count
rdcnodes = rdc_servers.count
anxnodes = anx_servers.count
agtnodes = agt_servers.count
wmsnodes = wms_servers.count
wrknodes = wrk_servers.count
wrkconvnodes = cnv_servers.count

# Variables for SQL Hosts requred for response files
psql_hostname = ""
psql_fqdn = ""
wms_hostname = ""
wms_fqdn = ""
cnv_hostname = ""

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
puts "########################### Web RDC Node Count: #{rdcnodes}"
puts "########################### AGT Node Count: #{agtnodes}"
puts "########################### WMS Node Count: #{wmsnodes}"
puts "########################### ANX Node Count: #{anxnodes}"
puts "########################### WRK Node Count: #{wrknodes}"
puts "########################### WRK Node Count: #{wrkconvnodes}"
######## REMOVE AFTER TESTING ########

#########################################################################
#### BEGIN PROVISIONING SCRIPT
#########################################################################
with_chef_server(
  Chef_Server,
  client_name: Chef::Config[:node_name],
  signing_key_filename: Chef::Config[:client_key]
) do # begin with chef server
  with_driver With_Driver do # begin with driver
    
    ############################################################
    # Prep SQL Primary Servers and Install Relativity
    ############################################################
    if p_sql == 1 || all == 1

      # Primary SQL Server - Relativity Install outside of batch
      if sqlnodes == 1
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
          chef_environment Chef_Environment
          run_list ['relativity-scaled-automation-sri::default']

          attribute %w(Relativity Version), RelativityVersion
          attribute %w(Relativity SQLPrimary Install), 1
          attribute %w(Relativity Setup Only), RELSETUPONLY
          attribute %w(Relativity Install RelativityInstance), ClusterName
          attribute %w(Relativity Install SQLUseWinAuth), 1
          attribute %w(Attached DriveLetter), AttachedDrive
          attribute %w(Relativity Install PrimaryInstance),psql_hostname
          attribute %w(Relativity SQLPrimary FileRepo), "\\\\#{psql_fqdn}\\FileShare"
          attribute %w(Relativity SQLPrimary EDDSFileShare),"\\\\#{psql_fqdn}\\EDDSFileShare"
          attribute %w(Relativity SQLPrimary DTSearch),"\\\\#{psql_fqdn}\\DTSearch"
          attribute %w(Relativity Skip Step), SkipStep

          action :converge
        end
      else
        Chef::Log.info('No Primary SQL Install Required...')
      end

    else
      puts 'No need to build the Primary SQL server at this time...'
    end

    ############################################################
    # Prep RSB Server and Install Relativity Agent
    ############################################################
    if RelativityVersion >= '9.4' &&  inv_cnv == 1 || all == 1 # if RelativityVersion is >= 9.4

      if wrkconvnodes == 1 # if work conversion node == 1

        machine cnv_hostname do # begin machin do
          machine_options(
            transport_options: {
              is_windows: true,
              host: cnv_hostname,
              username: ENV['VRA_USER'],
              password: ENV['VRA_PASS']
            }
          )
          chef_environment Chef_Environment
          run_list ['relativity-scaled-automation-sri::default']

          attribute %w(Relativity Version), RelativityVersion
          attribute %w(Relativity Agent Install), 1
          attribute %w(Relativity ServiceBus Install), 1
          attribute %w(Relativity Agent Defaults), 0
          attribute %w(Relativity Install SQLUseWinAuth), 1
          attribute %w(Relativity Setup Only), RELSETUPONLY
          attribute %w(Relativity Install RelativityInstance), ClusterName
          attribute %w(Relativity Install PrimaryInstance), psql_hostname
          attribute %w(Relativity Skip Step), SkipStep

          action :converge

        end # end machin do
      end # end if work conversion node == 1
    end # end if RelativityVersion is >= 9.4

    ############################################################
    # Prep Worker Manger/Queue Manager Server and Install Invariant
    ############################################################
    if inv_wms == 1 || all == 1
      Chef::Log.info('Installing Worker Manager Server...')

      # Invariant SQL and Worker Manager Server - Relativity Install
      if wmsnodes == 1
        Chef::Log.info('Installing Worker Manger Server Software...')
        machine wms_hostname do
          machine_options(
            transport_options: {
              is_windows: true,
              host: wms_hostname,
              username: ENV['VRA_USER'],
              password: ENV['VRA_PASS']
            }
          )
          chef_environment Chef_Environment
          run_list ['relativity-scaled-automation-sri::default']

          attribute %w(Relativity Version), RelativityVersion
          attribute %w(Relativity InvariantDatabase Install), 1
          attribute %w(Relativity InvariantQueueManager Install), 1
          attribute %w(Relativity Setup Only), RELSETUPONLY
          attribute %w(Relativity Install RelativityInstance), ClusterName
          attribute %w(Relativity Install SQLUseWinAuth), 1
          attribute %w(Attached DriveLetter), AttachedDrive
          attribute %w(Relativity Install PrimaryInstance), psql_hostname
          attribute %w(Relativity Invariant SQLInstance), wms_hostname
          attribute %w(Relativity Invariant WorkerNetworkPath), "\\\\#{wms_fqdn}\\InvariantNetworkShare"
          attribute %w(Relativity Invariant DTSearchPath), "\\\\#{wms_fqdn}\\DTSearch"
          attribute %w(Relativity Invariant FilesharePath), "\\\\#{wms_fqdn}\\FileShare"
          attribute %w(Relativity Skip Step), SkipStep

          action :converge
        end
      else
        Chef::Log.info('No Worker Manger Server Software Required...')
      end

    else
      puts 'WMS Server is not required...'
    end

    ############################################################
    # Prep Core Component Servers and Install Relativity
    ############################################################
    if core == 1 || all == 1
      Chef::Log.info('Begin install of Core Components...')

      machine_batch do # begin machine batch for secondary components (DistSQL, Web, WebRDC, Agt)
        # Distributed SQL Server Relativity Install
        if distnodes >= 1
          Chef::Log.info('Installing Distributed SQL Server Software...')
          dsql_servers.each do |dsql_server|
            dist_search = -> { search(:node, "name:#{ClusterName}-dist#{num}") } # ~FC003
            machine dsql_server do
              machine_options(
                transport_options: {
                  is_windows: true,
                  host: dsql_server,
                  username: ENV['VRA_USER'],
                  password: ENV['VRA_PASS']
                }
              )
              chef_environment Chef_Environment
              run_list ['relativity-scaled-automation-sri::default']

              attribute %w(Relativity Version), RelativityVersion
              attribute %w(Relativity DistributedSQL Install), 1
              attribute %w(Relativity Setup Only), RELSETUPONLY
              attribute %w(Relativity Install RelativityInstance), ClusterName
              attribute %w(Relativity Install SQLUseWinAuth), 1
              attribute %w(Attached DriveLetter), AttachedDrive
              attribute %w(Relativity Install PrimaryInstance), psql_hostname
              attribute %w(Relativity DistributedSQL Instance), dsql_server
              attribute %w(Relativity Skip Step), SkipStep

              # action :converge
            end
          end
        else
          Chef::Log.info('No Distributed SQL Server Software Required...')
        end

        # Primary Web Server (windows auth) - Relativity Install
        if webnodes >= 1
          Chef::Log.info('Installing Web Server Software...')
          web_servers.each do |web_server|
            machine web_server do
              machine_options(
                transport_options: {
                  is_windows: true,
                  host: web_server,
                  username: ENV['VRA_USER'],
                  password: ENV['VRA_PASS']
                }
              )
              chef_environment Chef_Environment
              run_list ['relativity-scaled-automation-sri::default']

              attribute %w(Relativity Version), RelativityVersion
              attribute %w(Relativity Web Install), 1
              attribute %w(Relativity Setup Only), RELSETUPONLY
              attribute %w(Relativity Install RelativityInstance), ClusterName
              attribute %w(Relativity Install SQLUseWinAuth), 1
              attribute %w(Relativity Web EnableWinAuth), 1
              attribute %w(Relativity Install PrimaryInstance), psql_hostname
              attribute %w(Relativity Skip Step), SkipStep

              # action :converge
            end
          end
        else
          Chef::Log.info('No Web Server Software Required...')
        end

        # Primary Web RDC (forms auth) - Relativity Install
        if rdcnodes >= 1
          Chef::Log.info('Installing Web RDC Server Software...')
          rdc_servers.each do |rdc_server|
            machine rdc_server do
              machine_options(
                transport_options: {
                  is_windows: true,
                  host: rdc_server,
                  username: ENV['VRA_USER'],
                  password: ENV['VRA_PASS']
                }
              )
              chef_environment Chef_Environment
              run_list ['relativity-scaled-automation-sri::default']

              attribute %w(Relativity Version), RelativityVersion
              attribute %w(Relativity Web Install), 1
              attribute %w(Relativity Setup Only), RELSETUPONLY
              attribute %w(Relativity Install RelativityInstance), ClusterName
              attribute %w(Relativity Install SQLUseWinAuth), 1
              attribute %w(Relativity Web EnableWinAuth), 0
              attribute %w(Relativity Install PrimaryInstance), psql_hostname
              attribute %w(Relativity Skip Step), SkipStep

              # action :converge
            end
          end
        else
          Chef::Log.info('No Web RDC Server Software Required...')
        end

        # Agent Server 1 - Relativity Install
        if agtnodes >= 1
          Chef::Log.info('Installing Agent Server Software...')
          agt_servers.each do |agt_server|
            machine agt_server do
              machine_options(
                transport_options: {
                  is_windows: true,
                  host: agt_server,
                  username: ENV['VRA_USER'],
                  password: ENV['VRA_PASS']
                }
              )
              chef_environment Chef_Environment
              run_list ['relativity-scaled-automation-sri::default']

              attribute %w(Relativity Version), RelativityVersion
              attribute %w(Relativity Agent Install), 1
              attribute %w(Relativity Setup Only), RELSETUPONLY
              attribute %w(Relativity Install RelativityInstance), ClusterName
              attribute %w(Relativity Install SQLUseWinAuth), 1
              attribute %w(Relativity Install PrimaryInstance), psql_hostname
              attribute %w(Relativity Skip Step), SkipStep

              # action :converge
            end
          end
        else
          Chef::Log.info('No Agent Server Software Required...')
        end

        action :converge
      end # end machine batch for secondary components (DistSQL, Web, WebRDC, Agt)

    else
      puts 'no core components needed at this time...'
    end

    ############################################################
    # Prep Invariant Worker and Conversion Servers and Install
    ############################################################
    if inv_wrk == 1 || all == 1

      machine_batch do ### begin machine batch to install worker components
        # Worker Servers (Processing/Imaging) - Relativity Install

        if wrknodes >= 1
          Chef::Log.info('Installing Processing/Imaging Worker Server Software...')
          wrk_servers.each do |wrk_server|
            machine wrk_server do
              machine_options(
                transport_options: {
                  is_windows: true,
                  host: wrk_server,
                  username: ENV['VRA_USER'],
                  password: ENV['VRA_PASS']
                }
              )
              chef_environment Chef_Environment
              run_list ['relativity-scaled-automation-sri::default']

              attribute %w(Relativity Version), RelativityVersion
              attribute %w(Relativity InvariantWorker Install), 1
              attribute %w(Relativity Setup Only), RELSETUPONLY
              attribute %w(Relativity Install RelativityInstance), ClusterName
              attribute %w(Relativity Install SQLUseWinAuth), 1
              attribute %w(Relativity Install PrimaryInstance), psql_hostname
              attribute %w(Relativity Invariant SQLInstance), wms_hostname
              attribute %w(Relativity Invariant WorkerNetworkPath),"\\\\#{wms_fqdn}\\InvariantNetworkShare"
              attribute %w(Relativity Skip Step), SkipStep

              action :converge
            end
          end
        else
          Chef::Log.info('No Processing/Imaging Worker Server Software Required...')
        end

        ########################################################
        ## Setup Worker conversion servers based on version
        ########################################################
        # Worker Servers (Conversion) - Relativity Install - If less than version 9.4
        if wrkconvnodes >= 1 && RelativityVersion < '9.4'
          Chef::Log.info('Installing Conversion Worker Server Software...')
                    
          wrkconvnodes.times do |num|
            machine "#{ClusterName}-wrkconv#{num}" do
              machine_options(
                transport_options: {
                  is_windows: true,
                  host: psql_hostname,
                  username: ENV['VRA_USER'],
                  password: ENV['VRA_PASS']
                }
              )
              chef_environment Chef_Environment
              run_list ['relativity-scaled-automation-sri::default']

              attribute %w(Relativity InvariantWorker Install), 1
              attribute %w(Relativity Invariant ConversionOnly), 1
              attribute %w(Relativity Install SQLUseWinAuth), 1
              attribute %w(Relativity Setup Only), RELSETUPONLY
              attribute %w(Relativity Install RelativityInstance), ClusterName
              attribute %w(Relativity Install PrimaryInstance), psql_hostname
              attribute %w(Relativity Invariant SQLInstance), wms_hostname
              attribute %w(Relativity Invariant WorkerNetworkPath), "\\\\#{wms_fqdn}\\InvariantNetworkShare"
              attribute %w(Relativity Skip Step), SkipStep

              action :converge
            end
          end

        else
          Chef::Log.info('No Conversion Worker Server Software Required...')
        end        
      end ### end machine batch to install worker components
    else
      puts 'Worker Components are not required...'
    end

    ############################################################
    # Prep Analytics Servers and Install Relativity
    ############################################################
    if anx == 1 || all == 1

      # Analytics Server - Relativity Install
      if anxnodes >= 1
        Chef::Log.info('Installing Analytics Server Software...')
        anx_servers.each do |anx_server|
          machine anx_server do
            machine_options(
              transport_options: {
                is_windows: true,
                host: anx_server,
                username: ENV['VRA_USER'],
                password: ENV['VRA_PASS']
              }
            )
            chef_environment Chef_Environment
            run_list ['relativity-scaled-automation-sri::default']

            attribute %w(Relativity Version), RelativityVersion
            attribute %w(Relativity Analytics Install), 1
            attribute %w(Relativity Setup Only), RELSETUPONLY
            attribute %w(Relativity Install RelativityInstance), ClusterName
            attribute %w(Relativity Analytics RestUser), 'SLT_REL2'
            attribute %w(Relativity Analytics RestPassword), 'P@ssword01'
            attribute %w(Attached DriveLetter), AttachedDrive
            attribute %w(Relativity Analytics CAATIndexDir), 'F:\\Analytics\\Indexes'
            attribute %w(Relativity Install PrimaryInstance), psql_hostname
            attribute %w(Relativity Skip Step), SkipStep

            action :converge
          end
        end
      else
        Chef::Log.info('No Analytics Server nodes found for installation...')
      end

    else
      puts 'Analytics not required...'
    end      

  end # end with driver
end # end with chef server
