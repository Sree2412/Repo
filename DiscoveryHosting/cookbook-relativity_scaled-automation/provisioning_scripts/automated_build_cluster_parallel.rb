# rubocop:disable LineLength

require 'chef/provisioning'

# Provisioning Variables
ClusterName = 'KM-TestWrk1'.freeze
AttachedDrive = 'F:'.freeze
SQLDataDrive = 'F:'.freeze
RELSETUPONLY = 1

########## Exe and MSI packages ##########
# # 9.4
RelativityVersion = '9.4'.freeze

# # 9.3
# RelativityVersion = '9.3'
# CoreInstallPackage = 'GOLD_9.3.297.13_Relativity.exe'
# InvariantInstallPackage = 'GOLD_4.3.297.1_Invariant.exe'
# AnalyticsInstallPackage = '9.3.297.13_Relativity_Analytics_Server.msi'

# 9.2
# RelativityVersion = '9.2'
# CoreInstallPackage = 'GOLD_9.2.237.3_Relativity.exe'
# InvariantInstallPackage = 'GOLD_4.2.237.7_Invariant.exe'
# AnalyticsInstallPackage = 'GOLD_9.2.237.3_Relativity_Analytics_Server.msi'

### Set Machine Batch to run_list ###
# If just want to build the machines set vms = 1 and others to 0
vms = 0 # To just create the VMS

all = 0	      # To run all
p_sql = 0 	  # To just install the Primary SQL component
core = 0 		  # To just install core components or the 2 machine batch
inv_wms = 0		# To just install the WMS component ( this is within the core installs so if you run core and you don't want WMS set WMS = 0 else set it to 1 so that it will install)
anx = 0       # To just install the Analytics component ( this is within the core installs so if you run core and you don't want Analytics set anx = 0 else set it to 1 so that it will install)
inv_wrk = 1	  # To just install the Worker component
inv_cnv = 0   # To install worker Conversion

####### NODES ##########
### Set the node counts based on what Tier environment needed ###

sqlnodes = 1
distnodes = 0
webnodes = 1
rdcnodes = 1
anxnodes = 1
agtnodes =1
wmsnodes = 1
wrknodes = 1
wrkconvnodes = 1 # for 9.4 this would be the RSB node
haproxynode = 0

# Search for host name value for SQL servers
sql_search = -> { search(:node, "name:#{ClusterName}-sql") } # ~FC003
wqu_search = -> { search(:node, "name:#{ClusterName}-wms") } # ~FC003

#########################################################################
#### BEGIN PROVISIONING SCRIPT
#########################################################################
with_chef_server(
  'https://chef.consilio.com/organizations/consilio-dev',
  client_name: Chef::Config[:node_name],
  signing_key_filename: Chef::Config[:client_key]
) do # begin with chef server
  with_driver 'vra:https://cloud.consilio.com' do # begin with driver
    ############################################################
    # Setup VMs for Cluster
    ############################################################
    if vms == 1
      puts "Build VM's...'"
      machine_batch do # begin machine batch to create vms for relativity environment
        # Primary SQL Server
        if sqlnodes == 1
          Chef::Log.info('Create SQL Node...')
          machine "#{ClusterName}-sql" do
            tags 'Relativity', 'DB', 'MS-SQL'
            machine_options(
              bootstrap_options: {
                catalog_id: '2f7a97cd-bff0-4408-b26f-2750344ec35e',
                subtenant_id: '3de5fbd7-8968-495a-ac2b-93b731b3a729',
                cpus: 2,
                memory: 8192,
                requested_for: ENV['VRA_USER'],
                lease_days: 14
              },
              transport_options: {
                is_windows: true,
                username: ENV['KT_USER'],
                password: ENV['KT_PASS']
              }
            )
          end
        else
          Chef::Log.info('No SQL Node Required...')
        end

        # Distributed SQL Server
        if distnodes >= 1
          Chef::Log.info('Create Distributed SQL Node...')
          distnodes.times do |num|
            machine "#{ClusterName}-dist#{num}" do
              tags 'Relativity', 'DB', 'MS-SQL'
              machine_options(
                bootstrap_options: {
                  catalog_id: '2f7a97cd-bff0-4408-b26f-2750344ec35e',
                  subtenant_id: '3de5fbd7-8968-495a-ac2b-93b731b3a729',
                  cpus: 2,
                  memory: 8192,
                  requested_for: ENV['VRA_USER'],
                  lease_days: 14
                },
                transport_options: {
                  is_windows: true,
                  username: ENV['KT_USER'],
                  password: ENV['KT_PASS']
                }
              )
            end
          end
        else
          Chef::Log.info('No Distributed SQL Node Required...')
        end

        # Web Servers (windows auth)
        if webnodes >= 1
          Chef::Log.info('Create Web Node...')
          webnodes.times do |num|
            machine "#{ClusterName}-web#{num}" do
              tags 'Relativity', 'Web', 'IIS'
              machine_options(
                bootstrap_options: {
                  catalog_id: '2f7a97cd-bff0-4408-b26f-2750344ec35e',
                  subtenant_id: '3de5fbd7-8968-495a-ac2b-93b731b3a729',
                  cpus: 1,
                  memory: 4096,
                  requested_for: ENV['VRA_USER'],
                  lease_days: 14
                },
                transport_options: {
                  is_windows: true,
                  username: ENV['KT_USER'],
                  password: ENV['KT_PASS']
                }
              )
            end
          end
        else
          Chef::Log.info('No Web Node Required...')
        end       

        # Web Server RDC
        if rdcnodes >= 1
          Chef::Log.info('Create Web RDC Node...')
          rdcnodes.times do |num|
            machine "#{ClusterName}-rdc#{num}" do
              tags 'Relativity', 'Web', 'IIS'
              machine_options(
                bootstrap_options: {
                  catalog_id: '2f7a97cd-bff0-4408-b26f-2750344ec35e',
                  subtenant_id: '3de5fbd7-8968-495a-ac2b-93b731b3a729',
                  cpus: 1,
                  memory: 4096,
                  requested_for: ENV['VRA_USER'],
                  lease_days: 14
                },
                transport_options: {
                  is_windows: true,
                  username: ENV['KT_USER'],
                  password: ENV['KT_PASS']
                }
              )
            end
          end
        else
          Chef::Log.info('No Web RDC Node Required...')
        end

        # Agent Servers
        if agtnodes >= 1
          Chef::Log.info('Create Agent Node...')
          agtnodes.times do |num|
            machine "#{ClusterName}-agt#{num}" do
              tags 'Relativity', 'Agent'
              machine_options(
                bootstrap_options: {
                  catalog_id: '2f7a97cd-bff0-4408-b26f-2750344ec35e',
                  subtenant_id: '3de5fbd7-8968-495a-ac2b-93b731b3a729',
                  cpus: 1,
                  memory: 4096,
                  requested_for: ENV['VRA_USER'],
                  lease_days: 14
                },
                transport_options: {
                  is_windows: true,
                  username: ENV['KT_USER'],
                  password: ENV['KT_PASS']
                }
              )
            end
          end
        else
          Chef::Log.info('No Agent Node Required...')
        end

        # Invariant SQL and Worker Manager Server
        if wmsnodes == 1
          Chef::Log.info('Create Worker Manager Server Node...')
          wmsnodes.times do |num|
            machine "#{ClusterName}-wms" do
              tags 'Relativity', 'WorkerSQL', 'MS-SQL'
              machine_options(
                bootstrap_options: {
                  catalog_id: '2f7a97cd-bff0-4408-b26f-2750344ec35e',
                  subtenant_id: '3de5fbd7-8968-495a-ac2b-93b731b3a729',
                  cpus: 1,
                  memory: 4096,
                  requested_for: ENV['VRA_USER'],
                  lease_days: 14
                },
                transport_options: {
                  is_windows: true,
                  username: ENV['KT_USER'],
                  password: ENV['KT_PASS']
                }
              )
            end
          end
        else
          Chef::Log.info('No Worker Manager Server Node Required...')
        end

        # Worker Servers (Processing/Imaging)
        if wrknodes >= 1
          Chef::Log.info('Create Processing/Imaging Worker Server Node...')
          wrknodes.times do |num|
            machine "#{ClusterName}-wrk#{num}" do
              tags 'Relativity', 'Worker'
              machine_options(
                bootstrap_options: {
                  catalog_id: '2f7a97cd-bff0-4408-b26f-2750344ec35e',
                  subtenant_id: '3de5fbd7-8968-495a-ac2b-93b731b3a729',
                  cpus: 1,
                  memory: 4096,
                  requested_for: ENV['VRA_USER'],
                  lease_days: 14
                },
                transport_options: {
                  is_windows: true,
                  username: ENV['KT_USER'],
                  password: ENV['KT_PASS']
                }
              )
            end
          end
        else
          Chef::Log.info('No Processing/Imaging Worker Server Node Required...')
        end

        ConversionServer = ''       

        # Worker Servers (Conversion)
        if wrkconvnodes >= 1
          Chef::Log.info('Create Conversion Worker Server Node...')
          wrkconvnodes.times do |num|

            if RelativityVersion >= '9.4'
              ConversionServer = "#{ClusterName}-rsb"
            else
              ConversionServer = "#{ClusterName}-wrkconv#{num}"
            end

            machine ConversionServer do
              tags 'Relativity', 'Worker'
              machine_options(
                bootstrap_options: {
                  catalog_id: '2f7a97cd-bff0-4408-b26f-2750344ec35e',
                  subtenant_id: '3de5fbd7-8968-495a-ac2b-93b731b3a729',
                  cpus: 1,
                  memory: 4096,
                  requested_for: ENV['VRA_USER'],
                  lease_days: 14
                },
                transport_options: {
                  is_windows: true,
                  username: ENV['KT_USER'],
                  password: ENV['KT_PASS']
                }
              )
            end
          end
        else
          Chef::Log.info('No Conversion Worker Server Node Required...')
        end

        # Analytics Servers
        if anxnodes >= 1
          Chef::Log.info('Create Analytics Node...')
          anxnodes.times do |num|
            machine "#{ClusterName}-anx#{num}" do
              tags 'Relativity', 'Analytics'
              machine_options(
                bootstrap_options: {
                  catalog_id: '2f7a97cd-bff0-4408-b26f-2750344ec35e',
                  subtenant_id: '3de5fbd7-8968-495a-ac2b-93b731b3a729',
                  cpus: 1,
                  memory: 4096,
                  requested_for: ENV['VRA_USER'],
                  lease_days: 14
                },
                transport_options: {
                  is_windows: true,
                  username: ENV['KT_USER'],
                  password: ENV['KT_PASS']
                }
              )
            end
          end
        else
          Chef::Log.info('No Analytics Node Required...')
        end

        # HAProxy Server (Load Balancing)
        if haproxynode == 1
          Chef::Log.info('Create HAProxy Node...')
          machine "#{ClusterName}-haplb" do
            tags 'Relativity', 'HAProxy'
            machine_options(
              bootstrap_options: {
                catalog_id: 'a4bbb0f7-3aff-4382-98bb-8f354664645a',
                subtenant_id: '3de5fbd7-8968-495a-ac2b-93b731b3a729',
                cpus: 1,
                memory: 4096,
                requested_for: ENV['VRA_USER'],
                lease_days: 14
              },
              transport_options: {
                is_windows: false,
                username: ENV['KT_USER'],
                password: ENV['KT_PASS']
              }
            )
          end
        else
          Chef::Log.info('No HAProxy Node Required...')
        end

        # action :converge
      end # end machine batch

    else
      puts 'No need to build VMs at this time...'
    end

    ############################################################
    # Prep SQL Primary Servers and Install Relativity
    ############################################################
    if p_sql == 1 || all == 1

      # Primary SQL Server - Relativity Install outside of batch
      if sqlnodes == 1
        Chef::Log.info('Installing Primary SQL Server Software...')
        machine "#{ClusterName}-sql" do
          machine_options(
            transport_options: {
              is_windows: true,
              username: ENV['KT_USER'],
              password: ENV['KT_PASS']
            }
          )
          run_list ['relativity-scaled-automation-sri::default']

          attribute %w(Relativity Source URL), RelativityInstallURL
          attribute %w(Relativity Source EXE), CoreInstallPackage
          attribute %w(Relativity Version), RelativityVersion
          attribute %w(Relativity SQLPrimary Install), 1
          attribute %w(Relativity Upgrade SQL), UPGRADE
          attribute %w(Relativity Setup Only), RELSETUPONLY
          attribute %w(Relativity Install RelativityInstance), ClusterName
          attribute %w(Relativity Install SQLUseWinAuth), 1
          attribute %w(Attached DriveLetter), AttachedDrive
          attribute %w(Relativity Install PrimaryInstance),
                    lazy {
                      sql_search.call[0]['hostname']
                    }
          attribute %w(Relativity SQLPrimary FileRepo),
                    lazy {
                      "\\\\#{sql_search.call[0]['fqdn']}\\FileShare"
                    }
          attribute %w(Relativity SQLPrimary EDDSFileShare),
                    lazy {
                      "\\\\#{sql_search.call[0]['fqdn']}\\EDDSFileShare"
                    }
          attribute %w(Relativity SQLPrimary DTSearch),
                    lazy {
                      "\\\\#{sql_search.call[0]['fqdn']}\\DTSearch"
                    }

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

        machine "#{ClusterName}-rsb" do # begin machin do
          machine_options(
            transport_options: {
              is_windows: true,
              username: ENV['KT_USER'],
              password: ENV['KT_PASS']
            }
          )
          run_list ['relativity-scaled-automation-sri::default']

          attribute %w(Relativity Version), RelativityVersion
          attribute %w(Relativity Agent Install), 1
          attribute %w(Relativity ServiceBus Install), 1
          attribute %w(Relativity Agent Defaults), 0
          attribute %w(Relativity Install SQLUseWinAuth), 1
          attribute %w(Relativity Setup Only), RELSETUPONLY
          attribute %w(Relativity Install RelativityInstance), ClusterName
          attribute %w(Relativity Install PrimaryInstance),
                    lazy {
                      sql_search.call[0]['hostname']
                    }

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
        machine "#{ClusterName}-wms" do
          machine_options(
            transport_options: {
              is_windows: true,
              username: ENV['KT_USER'],
              password: ENV['KT_PASS']
            }
          )
          run_list ['relativity-scaled-automation-sri::default']

          attribute %w(Relativity Version), RelativityVersion
          attribute %w(Relativity InvariantDatabase Install), 1
          attribute %w(Relativity InvariantQueueManager Install), 1
          attribute %w(Relativity Upgrade WMS), UPGRADE
          attribute %w(Relativity Setup Only), RELSETUPONLY
          attribute %w(Relativity Install RelativityInstance), ClusterName
          attribute %w(Relativity Install SQLUseWinAuth), 1
          attribute %w(Attached DriveLetter), AttachedDrive
          attribute %w(Relativity Install PrimaryInstance),
                    lazy {
                      sql_search.call[0]['hostname']
                    }
          attribute %w(Relativity Invariant SQLInstance),
                    lazy {
                      wqu_search.call[0]['hostname']
                    }
          attribute %w(Relativity Invariant WorkerNetworkPath),
                    lazy {
                      "\\\\#{wqu_search.call[0]['fqdn']}\\InvariantNetworkShare"
                    }
          attribute %w(Relativity Invariant DTSearchPath),
                    lazy {
                      "\\\\#{sql_search.call[0]['fqdn']}\\DTSearch"
                    }
          attribute %w(Relativity Invariant FilesharePath),
                    lazy {
                      "\\\\#{sql_search.call[0]['fqdn']}\\FileShare"
                    }

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
          distnodes.times do |num|
            dist_search = -> { search(:node, "name:#{ClusterName}-dist#{num}") } # ~FC003
            machine "#{ClusterName}-dist#{num}" do
              machine_options(
                transport_options: {
                  is_windows: true,
                  username: ENV['KT_USER'],
                  password: ENV['KT_PASS']
                }
              )
              run_list ['relativity-scaled-automation-sri::default']

              attribute %w(Relativity Version), RelativityVersion
              attribute %w(Relativity DistributedSQL Install), 1
              attribute %w(Relativity Upgrade DIST), UPGRADE
              attribute %w(Relativity Setup Only), RELSETUPONLY
              attribute %w(Relativity Install RelativityInstance), ClusterName
              attribute %w(Relativity Install SQLUseWinAuth), 1
              attribute %w(Attached DriveLetter), AttachedDrive
              attribute %w(Relativity Install PrimaryInstance),
                        lazy {
                          sql_search.call[0]['hostname']
                        }
              attribute %w(Relativity DistributedSQL Instance),
                        lazy {
                          dist_search.call[0]['hostname']
                        }

              # action :converge
            end
          end
        else
          Chef::Log.info('No Distributed SQL Server Software Required...')
        end

        # Primary Web Server (windows auth) - Relativity Install
        if webnodes >= 1
          Chef::Log.info('Installing Web Server Software...')
          webnodes.times do |num|
            machine "#{ClusterName}-web#{num}" do
              machine_options(
                transport_options: {
                  is_windows: true,
                  username: ENV['KT_USER'],
                  password: ENV['KT_PASS']
                }
              )
              run_list ['relativity-scaled-automation-sri::default']

              attribute %w(Relativity Version), RelativityVersion
              attribute %w(Relativity Web Install), 1
              attribute %w(Relativity Upgrade Web), UPGRADE
              attribute %w(Relativity Setup Only), RELSETUPONLY
              attribute %w(Relativity Install RelativityInstance), ClusterName
              attribute %w(Relativity Install SQLUseWinAuth), 1
              attribute %w(Relativity Web EnableWinAuth), 1
              attribute %w(Relativity Install PrimaryInstance),
                        lazy {
                          sql_search.call[0]['hostname']
                        }

              # action :converge
            end
          end
        else
          Chef::Log.info('No Web Server Software Required...')
        end

        # Primary Web RDC (forms auth) - Relativity Install
        if rdcnodes >= 1
          Chef::Log.info('Installing Web RDC Server Software...')
          rdcnodes.times do |num|
            machine "#{ClusterName}-rdc#{num}" do
              machine_options(
                transport_options: {
                  is_windows: true,
                  username: ENV['KT_USER'],
                  password: ENV['KT_PASS']
                }
              )
              run_list ['relativity-scaled-automation-sri::default']

              attribute %w(Relativity Version), RelativityVersion
              attribute %w(Relativity Web Install), 1
              attribute %w(Relativity Upgrade Web), UPGRADE
              attribute %w(Relativity Setup Only), RELSETUPONLY
              attribute %w(Relativity Install RelativityInstance), ClusterName
              attribute %w(Relativity Install SQLUseWinAuth), 1
              attribute %w(Relativity Web EnableWinAuth), 0
              attribute %w(Relativity Install PrimaryInstance),
                        lazy {
                          sql_search.call[0]['hostname']
                        }

              # action :converge
            end
          end
        else
          Chef::Log.info('No Web RDC Server Software Required...')
        end

        # Agent Server 1 - Relativity Install
        if agtnodes >= 1
          Chef::Log.info('Installing Agent Server Software...')
          agtnodes.times do |num|
            machine "#{ClusterName}-agt#{num}" do
              machine_options(
                transport_options: {
                  is_windows: true,
                  username: ENV['KT_USER'],
                  password: ENV['KT_PASS']
                }
              )
              run_list ['relativity-scaled-automation-sri::default']

              attribute %w(Relativity Version), RelativityVersion
              attribute %w(Relativity Agent Install), 1
              attribute %w(Relativity Agent Defaults), 1
              attribute %w(Relativity Upgrade AGT), UPGRADE
              attribute %w(Relativity Setup Only), RELSETUPONLY
              attribute %w(Relativity Install RelativityInstance), ClusterName
              attribute %w(Relativity Install SQLUseWinAuth), 1
              attribute %w(Relativity Install PrimaryInstance),
                        lazy {
                          sql_search.call[0]['hostname']
                        }

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
          wrknodes.times do |num|
            machine "#{ClusterName}-wrk#{num}" do
              machine_options(
                transport_options: {
                  is_windows: true,
                  username: ENV['KT_USER'],
                  password: ENV['KT_PASS']
                }
              )
              run_list ['relativity-scaled-automation-sri::default']

              attribute %w(Relativity Version), RelativityVersion
              attribute %w(Relativity InvariantWorker Install), 1
              attribute %w(Relativity Setup Only), RELSETUPONLY
              attribute %w(Relativity Install RelativityInstance), ClusterName
              attribute %w(Relativity Install SQLUseWinAuth), 1
              attribute %w(Relativity Install PrimaryInstance),
                        lazy {
                          sql_search.call[0]['hostname']
                        }
              attribute %w(Relativity Invariant SQLInstance),
                        lazy {
                          wqu_search.call[0]['hostname']
                        }
              attribute %w(Relativity Invariant WorkerNetworkPath),
                        lazy {
                          "\\\\#{wqu_search.call[0]['fqdn']}\\InvariantNetworkShare"
                        }

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
                  username: ENV['KT_USER'],
                  password: ENV['KT_PASS']
                },
                convergence_options: {
                  chef_version: '12.7.2'
                }
              )
              run_list ['relativity-scaled-automation-sri::default']

              attribute %w(Relativity InvariantWorker Install), 1
              attribute %w(Relativity Invariant ConversionOnly), 1
              attribute %w(Relativity Install SQLUseWinAuth), 1
              attribute %w(Relativity Setup Only), RELSETUPONLY
              attribute %w(Relativity Install RelativityInstance), ClusterName
              attribute %w(Relativity Install PrimaryInstance),
                        lazy {
                          sql_search.call[0]['hostname']
                        }
              attribute %w(Relativity Invariant SQLInstance),
                        lazy {
                          wqu_search.call[0]['hostname']
                        }
              attribute %w(Relativity Invariant WorkerNetworkPath),
                        lazy {
                          "\\\\#{wqu_search.call[0]['fqdn']}\\InvariantNetworkShare"
                        }

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
        anxnodes.times do |num|
          machine "#{ClusterName}-anx#{num}" do
            machine_options(
              transport_options: {
                is_windows: true,
                username: ENV['KT_USER'],
                password: ENV['KT_PASS']
              }
            )
            run_list ['relativity-scaled-automation-sri::default']

            attribute %w(Relativity Version), RelativityVersion
            attribute %w(Relativity Analytics Install), 1
            attribute %w(Relativity Upgrade ANX), UPGRADE
            attribute %w(Relativity Setup Only), RELSETUPONLY
            attribute %w(Relativity Install RelativityInstance), ClusterName
            attribute %w(Relativity Install PrimaryInstance),
                      lazy {
                        sql_search.call[0]['hostname']
                      }

            action :converge
          end
        end
      else
        Chef::Log.info('No Analytics Server nodes found for installation...')
      end

    else
      puts 'Analytics not required...'
    end   

    # Create Load Balancer
    if haproxynode == 1
      Chef::Log.info('Installing HAProxy Server Software...')
      machine "#{ClusterName}-haplb" do
        machine_options(
          transport_options: {
            is_windows: false,
            username: ENV['KT_USER'],
            password: ENV['KT_PASS']
          }
        )
        run_list ['relativity-scaled-automation-sri::default']

        attribute %w(Relativity HAProxy Install), 1
        attribute %w(Relativity ClusterName), ClusterName

        action :converge
      end
    else
      Chef::Log.info('No HAProxy Server Software Required...')
    end
  end # end with driver
end # end with chef server
