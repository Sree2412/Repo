# rubocop:disable LineLength

require 'chef/provisioning'
require 'CSV'

chef_server_url = 'https://chef.consilio.com/organizations/consilio'
###### Provisioning Variables ######

CSV_Path = "C:\\94Upgrade\\USProdServers.csv"

# Provisioning Variables
ClusterName = 'us_relativity'.freeze
CreatePaths = 0 # if needing to create paths set this to 1
AttachedDrive = 'F:'.freeze
SQLDataDrive = 'F:'.freeze
RELSETUPONLY = 1
UPGRADE = 0 # If upgrading
Skip = 0 # Set this to 1 if you want to skip all prerequisites
SkipResponse = 0 # Set this to skip the response file
Rel_Recommended = 1 # if needing to apply relativity recommended features, roles and optimization
Chef_Environment = 'us_relativity'

# # 9.4
RelativityVersion = '9.4'.freeze


CAATIndexDir = 'F:\\Analytics\\Indexes'
Rest_User = 'v3relsvc'
Rest_Pass = 'Awesome17!'

### Set Machine Batch to run_list ###
# If just want to build the machines set vms = 1 and others to 0

all = 0	      # To run all
p_sql = 0 	  # To just upgrade the Primary SQL component
dist_sql = 0 	# To just upgrade the Primary SQL component
web = 0 		  # To just upgrade web components
agt = 1 		  # To just upgrade agt components
inv_wms = 0		# To just upgrade the WMS component
inv_wrk = 0   # To just install the worker component
anx = 0       # To just upgrade the Analytics component
inv_cnv = 0   # To install worker Conversion

### Get the node names from search
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

#CSV File that has the servernames and roles
#csv_file = "C:\\Users\\kxmoss\\Documents\\AA - Projects\\2016\\94_Upgrade\\ProdServers.csv"

### increment the node count for each role and add the server names to role array
CSV.foreach(CSV_Path) do | x,y |
  servernames << x

  if y == 'Web'
    web_servers.push(x)
  elsif (y == 'Web - RDC')
    rdc_servers << x
  elsif (y == 'Agent')
    agt_servers << x
  elsif y == 'SQL - Distributed'
    dsql_servers << x
  elsif y == 'SQL - Primary'
    psql_servers << x
  elsif y == 'Analytics Server'
    anx_servers << x
  elsif y == 'Worker Manager Server'
    wms_servers << x
  elsif y == 'Worker'
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
rdcnodes = rdc_servers.count
anxnodes = anx_servers.count
agtnodes = agt_servers.count
wmsnodes = wms_servers.count
wrknodes = wrk_servers.count

# Primary SQL and WMS Server Variables
psql_hostname = ""
psql_fqdn = ""
wms_hostname = ""
wms_fqdn = ""
cnv_hostname = ""

# Search for host name value  
psql_servers.each do | psql_server |
  psql_hostname = psql_server
  psql_fqdn = "#{psql_server}.consilio.com"
  puts "#### PRIMARY SQL SERVER: #{psql_hostname} ####"
end

wms_servers.each do | wms_server |
  wms_hostname = wms_server
  wms_fqdn = "#{wms_server}.consilio.com"
  puts "#### WORKER MANAGER SERVER: #{wms_hostname} ####"
end  

cnv_servers.each do | cnv_server |
  cnv_hostname = cnv_server
  puts "Conversion Server: #{cnv_hostname}"
end  

# Search for host name value for SQL servers
sql_search = -> { search(:node, "name:#{psql_hostname}") } # ~FC003
wqu_search = -> { search(:node, "name:#{wms_hostname}") } # ~FC003

######## REMOVE AFTER TESTING ########
puts "########################### SQL Node Count: #{sqlnodes}"
puts "########################### Dist Node Count: #{distnodes}"
puts "########################### Web Node Count: #{webnodes}"
puts "########################### Web Node Count: #{rdcnodes}"
puts "########################### AGT Node Count: #{agtnodes}"
puts "########################### WMS Node Count: #{wmsnodes}"
puts "########################### ANX Node Count: #{anxnodes}"
puts "########################### WRK Node Count: #{wrknodes}"
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
    if agt == 1 || all == 1 # begin if for web and agent upgrade
      Chef::Log.info('Begin upgrade of Web and Agent Components...')

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

              attribute %w(Relativity Version), RelativityVersion
              attribute %w(Relativity Agent Install), 1
              attribute %w(Relativity Upgrade AGT), UPGRADE
              attribute %w(Relativity Setup Only), RELSETUPONLY
              attribute %w(Relativity Install RelativityInstance), ClusterName
              attribute %w(Relativity Install SQLUseWinAuth), 1
              attribute %w(Relativity Install PrimaryInstance), psql_hostname
              attribute %w(Install Recommended), Rel_Recommended

              action :converge
            end # end machine block for agt_servers
          end # end loop for agt_servers
        else # else for agtnodes >= 1
          Chef::Log.info('No Agent Server Software Required...')
        end # end if for agtnodes >= 1
      end # end machine batch for agent upgrades
    end # end if for agent upgrade    

    if UPGRADE == 0
      ############################################################
      # Prep Invariant Worker and Conversion Servers and Install
      ############################################################
      if inv_wrk == 1 || all == 1

        machine_batch do ### begin machine batch to install worker components
          # Worker Servers (Processing/Imaging) - Relativity Install

          if wrknodes >= 1
            Chef::Log.info('Installing Processing/Imaging Worker Server Software...')
            wrk_servers.each do | wrk_server |
              machine wrk_server do # begin machine block for wrk_servers
                machine_options(
                  transport_options: {
                    is_windows: true,
                    ip_address: wrk_server,
                    username: ENV['VRA_USER'],
                    password: ENV['VRA_PASS']
                  }
                )
                run_list ['relativity-scaled-automation-sri::default']
                chef_environment Chef_Environment

                attribute %w(Relativity Version), RelativityVersion
                attribute %w(Relativity InvariantWorker Install), 1
                attribute %w(Relativity Setup Only), RELSETUPONLY
                attribute %w(Relativity Install RelativityInstance), ClusterName
                attribute %w(Relativity Install SQLUseWinAuth), 1
                attribute %w(Relativity Install PrimaryInstance), psql_hostname
                attribute %w(Relativity Invariant SQLInstance), wms_hostname
                attribute %w(Install Recommended), Rel_Recommended
                attribute %w(Relativity Skip ResponseFile), SkipResponse                

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
    end

  end # end with driver
end # end with chef server
