# rubocop:disable LineLength

require 'chef/provisioning'

ClusterName = 'FR4_Cluster'.freeze
AttachedDrive = 'D:'.freeze
SQLDataDrive = 'D:'.freeze
RELSETUPONLY = 0
UPGRADE = 1


# 9.4
RelativityVersion = '9.4'.freeze

AdobeURL = 'https://fr4-packages.consilio.com/fr4nas00/tech/Software/AdobeReader/'.freeze
EDrawingsURL = 'https://fr4-packages.consilio.com/fr4nas00/tech/Software/eDrawingsViewer/'.freeze
JungumURL = 'https://fr4-packages.consilio.com/fr4nas00/tech/Software/Jungum/'.freeze
LotusNotesURL = 'https://fr4-packages.consilio.com/fr4nas00/tech/Software/LotusNotes/'.freeze
MSOfficeURL = 'https://fr4-packages.consilio.com/fr4nas00/tech/Software/MSOffice/'.freeze
MSVisioURL = 'https://fr4-packages.consilio.com/fr4nas00/tech/Software/MSVisio/'.freeze
MSProjectURL = 'https://fr4-packages.consilio.com/fr4nas00/tech/Software/MSProject/'.freeze

WildCardPassword = Chef::EncryptedDataBagItem.load('wildcardcreds', 'wildcard-password', 'consiliopass123')['password']

all =	# To run all
  p_sql = 0 # To just install the Primary SQL component
dist = 0
core = 0 		  # To just install core components or the 2 machine batch
inv_wms = 1		# To just install the WMS component ( this is within the core installs so if you run core and you don't want WMS set WMS = 0 else set it to 1 so that it will install)
anx = 1 # To just install the Analytics component ( this is within the core installs so if you run core and you don't want Analytics set anx = 0 else set it to 1 so that it will install)
inv_wrk = 0	# To just install the Worker component \
inv_cnv = 0 # To install worker Conversion

####### NODES ##########
##### SERVERS FOR FR4 ENVIRONMENT ####

# Primary SQL server
primary_sql_server_hostname = 'FR4VPDSQL10'
primary_sql_server = 'FR4VPDSQL10.consilio.com'

# Processing SQL server ( WMS/Queue Manager)
wms_server_hostname = 'FR4VPDSQL12'
wms_server = 'FR4VPDSQL12.consilio.com'

# Distributed SQL Server node
dist_sql_server_hostname = 'FR4VPDSQL11'
dist_sql_server = 'FR4VPDSQL11.consilio.com'

# front-end web server 1
web_server_01 = 'FR4VPWREWB01.consilio.com'

# front-end web server 2
web_server_02 = 'FR4VPWREWB02.consilio.com'

# import/export web server
web_server_03 = 'FR4VPWREWL01.consilio.com'

# Agent Server - dtSearch execution
agent_server_01 = 'FR4VPARESE01.consilio.com'

# Agent Server - Production
agent_server_02 = 'FR4VPAREAG01.consilio.com'

# Agent Server - OCR
agent_server_03 = 'FR4VPAREAG02.consilio.com'

# Agent Server - Environment Management
agent_server_04 = 'FR4VPAREAG03.consilio.com'

# Agent Server - dtIndex builds and Analytics monitor
agent_server_05 = 'FR4VPAREAG04.consilio.com'

# Processing Worker (Native Imaging)
worker_server_01 = 'FR4VPAREWK01.consilio.com'

# Processing Worker (Native Imaging)
worker_server_02 = 'FR4VPAREWK02.consilio.com'

# Conversion Worker
worker_server_03 = 'FR4VPAREWK03.consilio.com'

# Content Analyst server
analytics_server = 'FR4VPARECA01.consilio.com'

#########################################################################
#### BEGIN PROVISIONING SCRIPT
#########################################################################
with_chef_server(
  'https://chef.consilio.com/organizations/consilio',
  client_name: Chef::Config[:node_name],
  signing_key_filename: Chef::Config[:client_key]
) do # begin with chef server
  with_driver 'ssh' do # begin with driver
    if UPGRADE == 1

      puts 'Stopping Services...'

      machine_batch do # begin machine batch for secondary components (DistSQL, Web, WebRDC, Agt)
        # Web Server - Relativity Install
        Chef::Log.info('Installing Web Server Software...')

        machine web_server_01 do
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: web_server_01,
              username: ENV['VRA_USER'],
              password: ENV['VRA_PASS']
            }
          )
          run_list ['relativity-scaled-automation-sri::upgrade_stop_iis_services']
          chef_environment 'fr4'
        end

        machine web_server_02 do
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: web_server_02,
              username: ENV['VRA_USER'],
              password: ENV['VRA_PASS']
            }
          )
          run_list ['relativity-scaled-automation-sri::upgrade_stop_iis_services']
          chef_environment 'fr4'
        end

        machine web_server_03 do
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: web_server_03,
              username: ENV['VRA_USER'],
              password: ENV['VRA_PASS']
            }
          )
          run_list ['relativity-scaled-automation-sri::upgrade_stop_iis_services']
          chef_environment 'fr4'
        end

        # Agent Server - Relativity Install
        Chef::Log.info('Installing Agent Server Software...')

        machine agent_server_01 do
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: agent_server_01,
              username: ENV['VRA_USER'],
              password: ENV['VRA_PASS']
            }
          )
          run_list ['relativity-scaled-automation-sri::upgrade_stop_agent_services']
          chef_environment 'fr4'
        end

        machine agent_server_02 do
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: agent_server_02,
              username: ENV['VRA_USER'],
              password: ENV['VRA_PASS']
            }
          )
          run_list ['relativity-scaled-automation-sri::upgrade_stop_agent_services']
          chef_environment 'fr4'
        end

        machine agent_server_03 do
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: agent_server_03,
              username: ENV['VRA_USER'],
              password: ENV['VRA_PASS']
            }
          )
          run_list ['relativity-scaled-automation-sri::upgrade_stop_agent_services']
          chef_environment 'fr4'
        end

        machine agent_server_04 do
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: agent_server_04,
              username: ENV['VRA_USER'],
              password: ENV['VRA_PASS']
            }
          )
          run_list ['relativity-scaled-automation-sri::upgrade_stop_agent_services']
          chef_environment 'fr4'
        end

        machine agent_server_05 do
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: agent_server_05,
              username: ENV['VRA_USER'],
              password: ENV['VRA_PASS']
            }
          )
          run_list ['relativity-scaled-automation-sri::upgrade_stop_agent_services']
          chef_environment 'fr4'
        end

        action :converge
      end

    end

    ############################################################
    # Prep SQL Primary Servers and Install Relativity
    ############################################################
    if p_sql == 1 || all == 1

      # Primary SQL Server - Relativity Install outside of batch
      Chef::Log.info('Installing Primary SQL Server Software...')

      machine primary_sql_server do
        machine_options(
          transport_options: {
            is_windows: true,
            ip_address: primary_sql_server,
            username: ENV['VRA_USER'],
            password: ENV['VRA_PASS']
          }
        )
        run_list ['relativity-scaled-automation-sri']
        chef_environment 'fr4'

        attribute %w(Relativity Version), RelativityVersion
        attribute %w(Relativity SQLPrimary Install), 1
        attribute %w(Relativity Setup Only), RELSETUPONLY
        attribute %w(Relativity Install RelativityInstance), ClusterName
        attribute %w(Relativity Install SQLUseWinAuth), 1
        attribute %w(Attached DriveLetter), AttachedDrive

        action :converge
      end
    else
      Chef::Log.info('No need to build the Primary SQL server at this time...')
    end

    ############################################################
    # Prep Distributed SQL Server and Install Relativity
    ############################################################
    if dist == 1 || all == 1

      # Distributed SQL Server - Relativity Install
      Chef::Log.info('Installing Distributed SQL Server Software...')

      machine dist_sql_server do
        machine_options(
          transport_options: {
            is_windows: true,
            ip_address: dist_sql_server,
            username: ENV['VRA_USER'],
            password: ENV['VRA_PASS']
          }
        )
        run_list ['relativity-scaled-automation-sri']
        chef_environment 'fr4'

        attribute %w(Relativity Version), RelativityVersion
        attribute %w(Relativity DistributedSQL Install), 1
        attribute %w(Relativity Setup Only), RELSETUPONLY
        attribute %w(Relativity Install RelativityInstance), ClusterName
        attribute %w(Relativity Install SQLUseWinAuth), 1
        attribute %w(Attached DriveLetter), AttachedDrive

        action :converge
      end
    else
      Chef::Log.info('No need to build the DIST server at this time...')
    end

    ## Worker Conversion server, will install Relativity Service bus agent
    ## after the primary sql and distributed are done
    if inv_cnv == 1 || all == 1

      machine worker_server_03 do
        machine_options(
          transport_options: {
            is_windows: true,
            ip_address: worker_server_03,
            username: ENV['VRA_USER'],
            password: ENV['VRA_PASS']
          }
        )
        run_list ['relativity-scaled-automation-sri']
        chef_environment 'fr4'

        attribute %w(Relativity Version), RelativityVersion
        attribute %w(Relativity Agent Install), 1
        attribute %w(Relativity ServiceBus Install), 1
        attribute %w(Relativity Agent Defaults), 0
        attribute %w(Relativity Install SQLUseWinAuth), 1
        attribute %w(Relativity Setup Only), RELSETUPONLY
        attribute %w(Relativity Install RelativityInstance), ClusterName

        action :converge
      end

    end

    ############################################################
    # Prep Core Component Servers and Install Relativity
    ############################################################
    if core == 1 || all == 1
      Chef::Log.info('Begin install of Core Components...')

      ## For upgrades, Agents should install first, so this batch will go before Web Servers
      machine_batch do # begin machine batch for secondary components (Agents)
        # Agent Server - Relativity Install
        Chef::Log.info('Installing Agent Server Software...')

        machine agent_server_01 do
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: agent_server_01,
              username: ENV['VRA_USER'],
              password: ENV['VRA_PASS']
            }
          )
          run_list ['relativity-scaled-automation-sri']
          chef_environment 'fr4'

          attribute %w(Relativity Version), RelativityVersion
          attribute %w(Relativity Agent Install), 1
          attribute %w(Relativity Agent Defaults), 1
          attribute %w(Relativity Setup Only), RELSETUPONLY
          attribute %w(Relativity Install RelativityInstance), ClusterName
          attribute %w(Relativity Install SQLUseWinAuth), 1
          # action :converge
        end

        machine agent_server_02 do
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: agent_server_02,
              username: ENV['VRA_USER'],
              password: ENV['VRA_PASS']
            }
          )
          run_list ['relativity-scaled-automation-sri']
          chef_environment 'fr4'

          attribute %w(Relativity Version), RelativityVersion
          attribute %w(Relativity Agent Install), 1
          attribute %w(Relativity Agent Defaults), 1
          attribute %w(Relativity Setup Only), RELSETUPONLY
          attribute %w(Relativity Install RelativityInstance), ClusterName
          attribute %w(Relativity Install SQLUseWinAuth), 1

          # action :converge
        end

        machine agent_server_03 do
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: agent_server_03,
              username: ENV['VRA_USER'],
              password: ENV['VRA_PASS']
            }
          )
          run_list ['relativity-scaled-automation-sri']
          chef_environment 'fr4'

          attribute %w(Relativity Version), RelativityVersion
          attribute %w(Relativity Agent Install), 1
          attribute %w(Relativity Agent Defaults), 1
          attribute %w(Relativity Setup Only), RELSETUPONLY
          attribute %w(Relativity Install RelativityInstance), ClusterName
          attribute %w(Relativity Install SQLUseWinAuth), 1

          # action :converge
        end

        machine agent_server_04 do
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: agent_server_04,
              username: ENV['VRA_USER'],
              password: ENV['VRA_PASS']
            }
          )
          run_list ['relativity-scaled-automation-sri']
          chef_environment 'fr4'

          attribute %w(Relativity Version), RelativityVersion
          attribute %w(Relativity Agent Install), 1
          attribute %w(Relativity Agent Defaults), 1
          attribute %w(Relativity Setup Only), RELSETUPONLY
          attribute %w(Relativity Install RelativityInstance), ClusterName
          attribute %w(Relativity Install SQLUseWinAuth), 1

          # action :converge
        end

        machine agent_server_05 do
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: agent_server_05,
              username: ENV['VRA_USER'],
              password: ENV['VRA_PASS']
            }
          )
          run_list ['relativity-scaled-automation-sri']
          chef_environment 'fr4'

          attribute %w(Relativity Version), RelativityVersion
          attribute %w(Relativity Agent Install), 1
          attribute %w(Relativity Agent Defaults), 1
          attribute %w(Relativity Setup Only), RELSETUPONLY
          attribute %w(Relativity Install RelativityInstance), ClusterName
          attribute %w(Relativity Install SQLUseWinAuth), 1
          attribute %w(Relativity Install PrimaryInstance), primary_sql_server_hostname
          # action :converge
        end

        action :converge
      end # end machine batch for secondary components (Agents)

      ## Web servers to install after agents, mainly because for upgrades Agents should be isntalled first
      machine_batch do # begin machine batch for secondary components (Web, WebRDC)
        # Web Server - Relativity Install
        Chef::Log.info('Installing Web Server Software...')

        machine web_server_01 do
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: web_server_01,
              username: ENV['VRA_USER'],
              password: ENV['VRA_PASS']
            }
          )
          run_list ['relativity-scaled-automation-sri']
          chef_environment 'fr4'

          attribute %w(Relativity Version), RelativityVersion
          attribute %w(Relativity Web Install), 1
          attribute %w(Relativity Setup Only), RELSETUPONLY
          attribute %w(Relativity Install RelativityInstance), ClusterName
          attribute %w(Relativity Install SQLUseWinAuth), 1
          attribute %w(Relativity Web EnableWinAuth), 1
          attribute %w(Relativity Install PrimaryInstance), primary_sql_server_hostname

          # action :converge
        end

        machine web_server_02 do
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: web_server_02,
              username: ENV['VRA_USER'],
              password: ENV['VRA_PASS']
            }
          )
          run_list ['relativity-scaled-automation-sri']
          chef_environment 'fr4'

          attribute %w(Relativity Version), RelativityVersion
          attribute %w(Relativity Web Install), 1
          attribute %w(Relativity Setup Only), RELSETUPONLY
          attribute %w(Relativity Install RelativityInstance), ClusterName
          attribute %w(Relativity Install SQLUseWinAuth), 1
          attribute %w(Relativity Web EnableWinAuth), 1
          attribute %w(Relativity Install PrimaryInstance), primary_sql_server_hostname

          # action :converge
        end

        machine web_server_03 do
          machine_options(
            transport_options: {
              is_windows: true,
              ip_address: web_server_03,
              username: ENV['VRA_USER'],
              password: ENV['VRA_PASS']
            }
          )
          run_list ['relativity-scaled-automation-sri']
          chef_environment 'fr4'

          attribute %w(Relativity Version), RelativityVersion
          attribute %w(Relativity Web Install), 1
          attribute %w(Relativity Setup Only), RELSETUPONLY
          attribute %w(Relativity Install RelativityInstance), ClusterName
          attribute %w(Relativity Install SQLUseWinAuth), 1
          attribute %w(Relativity Web EnableWinAuth), 0
          attribute %w(Relativity Install PrimaryInstance), primary_sql_server_hostname

          # action :converge
        end

        action :converge
      end # end machine batch for secondary components (Web, WebRDC)

    else
      puts 'No Core components needed at this time...'
    end

    if UPGRADE == 1 ### Begin IF for Upgrade
      Chef::Log.info('No Upgrade required for Worker components...')
    else

      ############################################################
      # Prep Invariant Worker and Conversion Servers and Install
      ############################################################
      if inv_wrk == 1 || all == 1

        machine_batch do ### begin machine batch to install worker components
          # Worker Servers (Processing/Imaging) - Relativity Install
          Chef::Log.info('Installing Processing/Imaging Worker Server Software...')

          machine worker_server_01 do
            machine_options(
              transport_options: {
                is_windows: true,
                ip_address: worker_server_01,
                username: ENV['VRA_USER'],
                password: ENV['VRA_PASS']
              }
            )
            run_list ['relativity-scaled-automation-sri']
            chef_environment 'fr4'

            attribute %w(Relativity Version), RelativityVersion
            attribute %w(Relativity InvariantWorker Install), 1
            attribute %w(Relativity Setup Only), RELSETUPONLY
            attribute %w(Relativity Install RelativityInstance), ClusterName
            attribute %w(Relativity Install SQLUseWinAuth), 1
            attribute %w(Relativity Install PrimaryInstance), primary_sql_server_hostname
            attribute %w(Relativity Invariant SQLInstance), wms_server_hostname
            attribute %w(Relativity Invariant WorkerNetworkPath), "\\\\#{wms_server}.consilio.com\\InvariantShare"
            attribute %w(adobe source), AdobeURL
            attribute %w(edrawings source), EDrawingsURL
            attribute %w(jungum source), JungumURL
            attribute %w(lotusnotes source), LotusNotesURL
            attribute %w(msoffice source), MSOfficeURL
            attribute %w(msvisio source), MSVisioURL
            attribute %w(msproject source), MSProjectURL

            # action :converge
          end

          machine worker_server_02 do
            machine_options(
              transport_options: {
                is_windows: true,
                ip_address: worker_server_02,
                username: ENV['VRA_USER'],
                password: ENV['VRA_PASS']
              }
            )
            run_list ['relativity-scaled-automation-sri']
            chef_environment 'fr4'

            attribute %w(Relativity Version), RelativityVersion
            attribute %w(Relativity InvariantWorker Install), 1
            attribute %w(Relativity Setup Only), RELSETUPONLY
            attribute %w(Relativity Install RelativityInstance), ClusterName
            attribute %w(Relativity Install SQLUseWinAuth), 1
            attribute %w(Relativity Install PrimaryInstance), primary_sql_server_hostname
            attribute %w(Relativity Invariant SQLInstance), wms_server_hostname
            attribute %w(Relativity Invariant WorkerNetworkPath), "\\\\#{wms_server}.consilio.com\\InvariantShare"
            attribute %w(adobe source), AdobeURL
            attribute %w(edrawings source), EDrawingsURL
            attribute %w(jungum source), JungumURL
            attribute %w(lotusnotes source), LotusNotesURL
            attribute %w(msoffice source), MSOfficeURL
            attribute %w(msvisio source), MSVisioURL
            attribute %w(msproject source), MSProjectURL

            # action :converge
          end

          action :converge
        end ### end machine batch to install worker components

      else
        puts 'Worker Components are not required...'
      end

    end ### End IF for upgrades

    ############################################################
    # Prep Worker Manger/Queue Manager Server and Install Invariant
    ############################################################
    if inv_wms == 1 || all == 1

      # Install WMS Server outside of the batch
      Chef::Log.info('Installing Worker Manger Server and Queue Manager Software...')

      machine wms_server do
        machine_options(
          transport_options: {
            is_windows: true,
            ip_address: wms_server_hostname,
            username: ENV['VRA_USER'],
            password: ENV['VRA_PASS']
          }
        )
        run_list ['relativity-scaled-automation-sri']
        chef_environment 'fr4'

        attribute %w(Relativity Version), RelativityVersion
        attribute %w(Relativity InvariantDatabase Install), 1
        attribute %w(Relativity InvariantQueueManager Install), 1
        attribute %w(Relativity Setup Only), RELSETUPONLY
        attribute %w(Relativity Install RelativityInstance), ClusterName
        attribute %w(Relativity Install SQLUseWinAuth), 1
        attribute %w(Attached DriveLetter), AttachedDrive
        attribute %w(Relativity InvariantDatabase DataDir), "#{SQLDataDrive}\\USER_DATA\\DATA_01"
        attribute %w(Relativity InvariantDatabase LogsDir), "#{SQLDataDrive}\\TLOG\\TLOG_01"
        attribute %w(Relativity Install PrimaryInstance), primary_sql_server_hostname
        attribute %w(Relativity Invariant SQLInstance), wms_server_hostname
        attribute %w(Relativity Invariant WorkerNetworkPath), "\\\\#{wms_server}.consilio.com\\InvariantShare"
        attribute %w(Relativity Invariant DTSearchPath), '\\\\fr4nas08\\dtsearch_01\\'
        attribute %w(Relativity Invariant FilesharePath), '\\\\fr4nas05\\reldoc_repos_01'
        attribute %w(Relativity Install SQLUseWinAuth), 1

        action :converge
      end
    else
      Chef::Log.info('No need to build the WMS server at this time...')
    end

    ############################################################
    # Prep Analytics Servers and Install Relativity
    ############################################################
    if anx == 1 || all == 1

      # Analytics Server - Relativity Install
      Chef::Log.info('Installing Analytics Server Software...')

      machine analytics_server do
        machine_options(
          transport_options: {
            is_windows: true,
            ip_address: analytics_server,
            username: ENV['VRA_USER'],
            password: ENV['VRA_PASS']
          }
        )
        run_list ['relativity-scaled-automation-sri']
        chef_environment 'fr4'

        attribute %w(Relativity Version), RelativityVersion
        attribute %w(Relativity Analytics Install), 1
        attribute %w(Relativity Setup Only), RELSETUPONLY
        attribute %w(Relativity Install RelativityInstance), ClusterName
        attribute %w(Relativity Analytics RestUser), 'sp_fr4_rel_a'
        attribute %w(Relativity Analytics RestPassword), 'P@ssword01'
        attribute %w(Attached DriveLetter), AttachedDrive
        attribute %w(Relativity Analytics CAATIndexDir), "#{AttachedDrive}\\Analytics\\Indexes"
        attribute %w(Relativity Install PrimaryInstance), primary_sql_server_hostname

        action :converge
      end
    else
      Chef::Log.info('No Analytics Server to install at this time...')
    end
  end # end with driver
end # end with chef server
