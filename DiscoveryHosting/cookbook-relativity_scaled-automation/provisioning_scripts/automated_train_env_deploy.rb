# rubocop:disable LineLength

require 'chef/provisioning'

ClusterName = 'Relativity_Training'.freeze
AttachedDrive = 'S:'.freeze
SQLDataDrive = 'D:'.freeze

########## Exe and MSI packages ##########
# # 9.3
RelativityVersion = '9.3'.freeze
CoreInstallPackage = 'GOLD_9.3.297.13_Relativity.exe'.freeze
InvariantInstallPackage = 'GOLD_4.3.297.1_Invariant.exe'.freeze
AnalyticsInstallPackage = '9.3.297.13_Relativity_Analytics_Server.msi'.freeze

all = 1	# To run all
p_sql = 0 	  # To just install the Primary SQL component
core = 0 		  # To just install core components or the 2 machine batch
inv_wms = 0		# To just install the WMS component ( this is within the core installs so if you run core and you don't want WMS set WMS = 0 else set it to 1 so that it will install)
anx = 0 # To just install the Analytics component ( this is within the core installs so if you run core and you don't want Analytics set anx = 0 else set it to 1 so that it will install)
inv_wrk = 0	# To just install the Worker component \

##### SERVERS FOR PERMANINT TEST ENVIRONMENT ####

# Primary SQL server
primary_sql_server_hostname = 'MTPVTDSQL01'
primary_sql_server = 'MTPVTDSQL01.consilio.com'

# Processing SQL server ( WMS/Queue Manager)
wms_server_hostname = 'MTPVTDSQL02'
wms_server = 'MTPVTDSQL02.consilio.com'

# front-end web server 1
web_server_01 = 'MTPVTSREWB01.consilio.com'

# front-end web server 2
web_server_02 = 'MTPVTSREWB02.consilio.com'

# Agent Server - dtSearch execution
agent_server_01 = 'MTPVTSREAG01.consilio.com'

# Processing Worker (Native Imaging)
worker_server_01 = 'MTPVTSREWK01.consilio.com'

# Content Analyst server
analytics_server = 'MTPVTSRECA01.consilio.com'

with_chef_server(
  'https://chef.consilio.com/organizations/consilio',
  client_name: Chef::Config[:node_name],
  signing_key_filename: Chef::Config[:client_key]
) do # begin with chef server
  with_driver 'ssh' do # begin with driver
    if p_sql == 1 || all == 1

      # Primary SQL Server - Relativity Install outside of batch
      Chef::Log.info('Installing Primary SQL Server Software...')

      machine primary_sql_server do
        machine_options(
          transport_options: {
            is_windows: true,
            ip_address: primary_sql_server,
            username: ENV['VRA_USER'],
            password: '%$Wailepo1$%'
          }
        )
        run_list ['relativity-scaled-automation-sri']
        chef_environment 'relativity_training'

        attribute %w(Relativity SQLPrimary Install), 1
        attribute %w(Relativity SQLPrimary FileRepo), "\\\\#{primary_sql_server}\\FileShare"
        attribute %w(Relativity SQLPrimary EDDSFileShare), "\\\\#{primary_sql_server}\\EDDSFileShare"
        attribute %w(Relativity SQLPrimary DTSearch), "\\\\#{primary_sql_server}\\DTSearch"
        attribute %w(Relativity Install Dir), 'C:\\Program Files\\kCura Corporation\\Relativity\\'
        attribute %w(Relativity Install PrimaryInstance), primary_sql_server_hostname
        attribute %w(Relativity Install RelativityInstance), ClusterName
        attribute %w(Relativity Install SQLUseWinAuth), 1
        attribute %w(Relativity Source EXE), CoreInstallPackage
        attribute %w(Attached DriveLetter), AttachedDrive
        attribute %w(Relativity Database BackupDir), "#{SQLDataDrive}\\Backup"
        attribute %w(Relativity Database LogsDir), "#{SQLDataDrive}\\TLOG\\TLOG_01"
        attribute %w(Relativity Database DataDir), "#{SQLDataDrive}\\USER_DATA\\DATA_01"
        attribute %w(Relativity Database FullTextDir), "#{SQLDataDrive}\\NDF\\NDF_01"

        action :converge
      end
    else
      Chef::Log.info('No need to build the Primary SQL server at this time...')
    end

    if inv_wms == 1 || all == 1

      # Install WMS Server outside of the batch
      Chef::Log.info('Installing Worker Manger Server and Queue Manager Software...')

      machine wms_server do
        machine_options(
          transport_options: {
            is_windows: true,
            ip_address: wms_server,
            host: wms_server,
            # port: 5985,
            username: ENV['VRA_USER'],
            password: '%$Wailepo1$%'
          }
        )
        run_list ['relativity-scaled-automation-sri']
        chef_environment 'relativity_training'

        attribute %w(Relativity InvariantDatabase Install), 1
        attribute %w(Attached DriveLetter), AttachedDrive
        attribute %w(Relativity InvariantDatabase DataDir), "#{SQLDataDrive}\\USER_DATA\\DATA_01"
        attribute %w(Relativity InvariantDatabase LogsDir), "#{SQLDataDrive}\\TLOG\\TLOG_01"
        attribute %w(Relativity InvariantQueueManager Install), 1
        attribute %w(Relativity Invariant SQLInstance), wms_server_hostname
        attribute %w(Relativity Invariant WorkerNetworkPath), "\\\\#{wms_server}\\InvariantNetworkShare"
        attribute %w(Relativity Invariant DTSearchPath), "\\\\#{primary_sql_server}\\DTSearch"
        attribute %w(Relativity Invariant FilesharePath), "\\\\#{primary_sql_server}\\FileShare"
        attribute %w(Relativity Invariant QueueManagerInstallPath), 'C:\\Program Files\\kCura Corporation\\Invariant\\QueueManager\\'
        attribute %w(Relativity Install PrimaryInstance), primary_sql_server_hostname
        attribute %w(Relativity Install SQLUseWinAuth), 1
        attribute %w(Relativity InvariantSource EXE), InvariantInstallPackage
        attribute %w(Relativity Version), RelativityVersion
      end
    else
      Chef::Log.info('No need to build the WMS server at this time...')
    end

    ######################################################
    # Install Core Components
    ######################################################
    if core == 1 || all == 1
      Chef::Log.info('Begin install of Core Components...')

      machine_batch do # begin machine batch for secondary components (DistSQL, Web, WebRDC, Agt)
        # Web Server - Relativity Install
        Chef::Log.info('Installing Web Server Software...')

        machine web_server_01 do
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: web_server_01,
              username: ENV['VRA_USER'],
              password: '%$Wailepo1$%'
            }
          )
          run_list ['relativity-scaled-automation-sri']
          chef_environment 'relativity_training'

          attribute %w(Relativity Web Install), 1
          attribute %w(Relativity Web EnableWinAuth), 1
          attribute %w(Relativity Install Dir), 'C:\\Program Files\\kCura Corporation\\Relativity\\'
          attribute %w(Relativity Install PrimaryInstance), primary_sql_server_hostname
          attribute %w(Relativity Install RelativityInstance), ClusterName
          attribute %w(Relativity Install SQLUseWinAuth), 1
          attribute %w(Relativity Source EXE), CoreInstallPackage
          attribute %w(Relativity Version), RelativityVersion

          action :converge
        end

        machine web_server_02 do
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: web_server_02,
              username: ENV['VRA_USER'],
              password: '%$Wailepo1$%'
            }
          )
          run_list ['relativity-scaled-automation-sri']
          chef_environment 'relativity_training'

          attribute %w(Relativity Web Install), 1
          attribute %w(Relativity Web EnableWinAuth), 1
          attribute %w(Relativity Install Dir), 'C:\\Program Files\\kCura Corporation\\Relativity\\'
          attribute %w(Relativity Install PrimaryInstance), primary_sql_server_hostname
          attribute %w(Relativity Install RelativityInstance), ClusterName
          attribute %w(Relativity Install SQLUseWinAuth), 1
          attribute %w(Relativity Source EXE), CoreInstallPackage
          attribute %w(Relativity Version), RelativityVersion
        end

        # Agent Server - Relativity Install
        Chef::Log.info('Installing Agent Server Software...')

        machine agent_server_01 do
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: agent_server_01,
              host: agent_server_01,
              # port: 5985,
              username: ENV['VRA_USER'],
              password: '%$Wailepo1$%'
            }
          )
          run_list ['relativity-scaled-automation-sri']
          chef_environment 'relativity_training'

          attribute %w(Relativity Agent Install), 1
          attribute %w(Relativity Agent Defaults), 1
          attribute %w(Relativity Install Dir), 'C:\\Program Files\\kCura Corporation\\Relativity\\'
          attribute %w(Relativity Install PrimaryInstance), primary_sql_server_hostname
          attribute %w(Relativity Install RelativityInstance), ClusterName
          attribute %w(Relativity Install SQLUseWinAuth), 1
          attribute %w(Relativity Source EXE), CoreInstallPackage
          attribute %w(Relativity Version), RelativityVersion
        end

        action :converge
      end # end machine batch for secondary components (DistSQL, Web, WebRDC, Agt, Anx, WMS)

    else
      puts 'No Core components needed at this time...'
    end

    if inv_wrk == 1 || all == 1

      machine_batch do ### begin machine batch to install worker components
        # Worker Servers (Processing/Imaging) - Relativity Install
        Chef::Log.info('Installing Processing/Imaging Worker Server Software...')

        machine worker_server_01 do
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: worker_server_01,
              host: worker_server_01,
              # port: 5985,
              username: ENV['VRA_USER'],
              password: '%$Wailepo1$%'
            }
          )
          run_list ['relativity-scaled-automation-sri']
          chef_environment 'relativity_training'

          attribute %w(Relativity InvariantWorker Install), 1
          attribute %w(Relativity InvariantQueueManager Install), 0
          attribute %w(Relativity Invariant SQLInstance), wms_server
          attribute %w(Relativity Invariant WorkerNetworkPath), "\\\\#{wms_server}\\InvariantNetworkShare"
          attribute %w(Relativity Invariant QueueManagerInstallPath), 'C:\\Program Files\\kCura Corporation\\Invariant\\QueueManager\\'
          attribute %w(Relativity Invariant WorkerInstallPath), 'C:\\Program Files\\kCura Corporation\\Invariant\\Worker\\'
          attribute %w(Relativity Install PrimaryInstance), primary_sql_server_hostname
          attribute %w(Relativity Install SQLUseWinAuth), 1
          attribute %w(Relativity InvariantSource EXE), InvariantInstallPackage
          attribute %w(Relativity Version), RelativityVersion
        end

        action :converge
      end ### end machine batch to install worker components
    else
      puts 'Worker Components are not required...'
    end

    if anx == 1 || all == 1

      # Analytics Server - Relativity Install
      Chef::Log.info('Installing Analytics Server Software...')

      machine analytics_server do
        machine_options(
          transport_options: {
            is_windows: true,
            ip_address: analytics_server,
            host: analytics_server,
            # port: 5985,
            username: ENV['VRA_USER'],
            password: '%$Wailepo1$%'
          }
        )
        run_list ['relativity-scaled-automation-sri']
        chef_environment 'relativity_training'

        attribute %w(Relativity Analytics Install), 1
        attribute %w(Relativity Install PrimaryInstance), primary_sql_server_hostname
        attribute %w(Attached DriveLetter), AttachedDrive
        attribute %w(Relativity Analytics CAATIndexDir), "#{AttachedDrive}\\Analytics\\Indexes"
        attribute %w(Relativity Analytics RestUser), 'SLT_REL2'
        attribute %w(Relativity Analytics RestPassword), 'P@ssword01'
        attribute %w(Relativity Source MSI), AnalyticsInstallPackage
        attribute %w(Relativity Version), RelativityVersion

        action :converge
      end
    else
      Chef::Log.info('No Analytics Server to install at this time...')
    end
  end # end with driver
end # end with chef server
