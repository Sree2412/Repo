
# dot net version
default['dotnetframework']['version'] = '4.5.1'

# Relativity Version
default['Relativity']['Version'] = ''

# This is the default install directory
# override if you wish to install in different location
default['Relativity']['Install']['Dir'] = 'C:\\Program Files\\kCura Corporation\\Relativity\\'

# SQL Server Primary instance name
default['Relativity']['Install']['PrimaryInstance'] = ""

# The name of the Relativity instance.
default['Relativity']['Install']['RelativityInstance'] = ""

# only overide to 0 if you do not want the
# creation of the database objects to be
# completed by the logged in user
default['Relativity']['Install']['SQLUseWinAuth'] = 1

# Data bag password
default['Relativity']['DataBag']['Password'] = 'consiliopass123'

# misc
default['Relativity']['Setup']['Only'] = 0
default['Relativity']['Cluster']['Name'] = ''
default['Install']['SQL']['AppServer'] = 0
default['Install']['WEB']['AppServer'] = 0
default['Install']['CreatePaths'] = 1
default['Relativity']['Skip']['Step'] = 0

default['consilio']['campus_code'] = 'DEV'

case node['consilio']['campus_code']

when 'ITAR'

  # Relativity Installers
  default['Relativity']['Source']['URL'] = 'https://packages.consilio.com/hlnas00/tech/Software/Relativity/9.4/'
  default['Relativity']['Source']['EXE'] = 'Relativity_9.4.321.2_Installation_Package.exe'
  # Analytics Installers
  default['Relativity']['Source']['AnalyticsURL'] = 'https://packages.consilio.com/hlnas00/tech/Software/Relativity/9.4/'
  default['Relativity']['Source']['AnalyticsMSI'] = '9.4.321.2_Relativity_Analytics_Server.msi'
  default['Consilio']['SSL']['ANXCert'] = 'http://packages.consilio.com/hlnas00/tech/Software/WildCard/AnxCert.pfx'
  # Invariant Installers
  default['Relativity']['InvariantSource']['URL'] = 'https://packages.consilio.com/hlnas00/tech/Software/Relativity/9.4/'
  default['Relativity']['InvariantSource']['EXE'] = 'Relativity_9.4.321.2_Processing_Installation_Package_-_Invariant_4.4.315.2.exe'

    # Servivce Accounts
  default['Relativity']['Relativity']['Service_Account'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'itar_serviceaccountpassword', 'consiliopass123')['username']
  default['Relativity']['Relativity']['Service_Account_Password'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'itar_serviceaccountpassword', 'consiliopass123')['password']
  default['Relativity']['SQLServer']['Service_Account'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'itar_serviceaccountpassword', 'consiliopass123')['username']
  default['Relativity']['SQLServer']['Service_Account_Password'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'itar_serviceaccountpassword', 'consiliopass123')['password']

  # EDDSDBO user password
  default['Relativity']['eddsdbo']['Password'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'itar_eddsdbopassword', 'consiliopass123')['password']

  ################### COMMON DATABASE PROPERTIES #######################
  ### The following properites are required when installing Primary Database
  ######################################################################

  # Backup, Logs, Data and FullText directories
  default['Relativity']['Database']['BackupDir'] = "D:\\USER_DATA" 
  default['Relativity']['Database']['LogsDir'] = "L:\\TLOG" 
  default['Relativity']['Database']['DataDir'] = "D:\\USER_DATA"
  default['Relativity']['Database']['FullTextDir'] = "D:\\USER_DATA"

  # FileRepo, EDDSFileShare and DTSearch Paths
  default['Relativity']['SQLPrimary']['FileRepo'] = '\\\\hlnas08\\reldoc_repo_2\\'
  default['Relativity']['SQLPrimary']['EDDSFileShare'] = '\\\\hlnas08\\reldoc_repo_2\\EDDS\\'
  default['Relativity']['SQLPrimary']['DTSearch'] = '\\\\hlnas08\\dt_search_storage_2\\'

  ##### INVARIANT LOCAL DIRECTORIES FOR INSTALL #####
  # Target directory for the database log (.ldf) files.
  default['Relativity']['InvariantDatabase']['LogsDir'] = "L:\\TLOG"

  # Target directory for the database data (.mdf) files.
  default['Relativity']['InvariantDatabase']['DataDir'] = "D:\\USER_DATA"

  # #### INVARIANT NETWORK DIRECTORIES FOR INSTALL
  # Invariant Network Path
  default['Relativity']['Invariant']['WorkerNetworkPath'] = "\\\\mlvtdsql39\\InvariantWorker"

  # Invariant DTsearch Path
  default['Relativity']['Invariant']['DTSearchPath'] = '\\\\hlnas08\\dt_search_storage_2\\'

  # Invariant Fileshare for data
  default['Relativity']['Invariant']['FilesharePath'] = "\\\\mlvtdsql39\\InvariantWorker"

when 'FR4'

  # Relativity Installers
  default['Relativity']['Source']['URL'] = 'https://fr4-packages.consilio.com/fr4nas00/tech/Software/Relativity/'
  default['Relativity']['Source']['EXE'] = 'Relativity_9.4.254.2_Installation_Package.exe'
  # Analytics Installers
  default['Relativity']['Source']['AnalyticsURL'] = 'https://fr4-packages.consilio.com/fr4nas00/tech/Software/Relativity/'
  default['Relativity']['Source']['AnalyticsMSI'] = '9.4.254.2_Relativity_Analytics_Server.msi'
  default['Consilio']['SSL']['ANXCert'] = 'http://packages.consilio.com/hlnas00/tech/Software/WildCard/AnxCert.pfx'
  # Invariant Installers
  default['Relativity']['InvariantSource']['URL'] = 'https://fr4-packages.consilio.com/fr4nas00/tech/Software/Invariant/'
  default['Relativity']['InvariantSource']['EXE'] = 'Relativity_9.4.254.2_Processing_Package_Invariant_4.4.273.3.exe'

    # Servivce Accounts
  default['Relativity']['Relativity']['Service_Account'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'fr4-serviceaccount', 'consiliopass123')['username']
  default['Relativity']['Relativity']['Service_Account_Password'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'fr4-serviceaccount', 'consiliopass123')['password']
  default['Relativity']['SQLServer']['Service_Account'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'fr4-sqlserviceaccount', 'consiliopass123')['username']
  default['Relativity']['SQLServer']['Service_Account_Password'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'fr4-sqlserviceaccount', 'consiliopass123')['password']

  # EDDSDBO user password
  default['Relativity']['eddsdbo']['Password'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'train-eddsdbopassword', 'consiliopass123')['password']

  default['Attached']['DriveLetter'] = 'F:'

  ################### COMMON DATABASE PROPERTIES #######################
  ### The following properites are required when installing Primary Database
  ######################################################################

  # Backup, Logs, Data and FullText directories
  default['Relativity']['Database']['BackupDir'] = "#{node['Attached']['DriveLetter']}\\Backup"  
  default['Relativity']['Database']['LogsDir'] = "#{node['Attached']['DriveLetter']}\\TLOG\\TLOG_01"  
  default['Relativity']['Database']['DataDir'] = "#{node['Attached']['DriveLetter']}\\USER_DATA\\DATA_01"  
  default['Relativity']['Database']['FullTextDir'] = "#{node['Attached']['DriveLetter']}\\NDF\\NDF_01"


  # FileRepo, EDDSFileShare and DTSearch Paths
  default['Relativity']['SQLPrimary']['FileRepo'] = '\\\\fr4nas05\\reldoc_repos_01'
  default['Relativity']['SQLPrimary']['EDDSFileShare'] = '\\\\fr4nas05\\reldoc_repos_01\\EDDS'
  default['Relativity']['SQLPrimary']['DTSearch'] = '\\\\fr4nas08\\dtsearch_01\\'

  ##### INVARIANT LOCAL DIRECTORIES FOR INSTALL #####
  # Target directory for the database log (.ldf) files.
  default['Relativity']['InvariantDatabase']['LogsDir'] = "#{node['Attached']['DriveLetter']}\\TLOG\\TLOG_01" 

  # Target directory for the database data (.mdf) files.
  default['Relativity']['InvariantDatabase']['DataDir'] = "#{node['Attached']['DriveLetter']}\\USER_DATA\\DATA_01" 

  # #### INVARIANT NETWORK DIRECTORIES FOR INSTALL
  # Invariant Network Path
  default['Relativity']['Invariant']['WorkerNetworkPath'] = "\\\\HK1VPDSQL12\\InvariantWorkerShare\\"

  # Invariant DTsearch Path
  default['Relativity']['Invariant']['DTSearchPath'] = "\\\\fr4nas08\\dtsearch_01\\"

  # Invariant Fileshare for data
  default['Relativity']['Invariant']['FilesharePath'] = '\\\\fr4nas05\\reldoc_repos_01'

when 'HK1'

  # Relativity Installers
  default['Relativity']['Source']['URL'] = 'https://hk1-packages.consilio.com/hk1nas00/tech/Software/Relativity/'
  default['Relativity']['Source']['EXE'] = 'Relativity_9.4.346.43_Installation_Package.exe'
  # Analytics Installers
  default['Relativity']['Source']['AnalyticsURL'] = 'https://hk1-packages.consilio.com/hk1nas00/tech/Software/Relativity/'
  default['Relativity']['Source']['AnalyticsMSI'] = '9.4.346.43_Relativity_Analytics_Server.msi'
  default['Consilio']['SSL']['ANXCert'] = 'http://packages.consilio.com/hlnas00/tech/Software/WildCard/AnxCert.pfx'
  # Invariant Installers
  default['Relativity']['InvariantSource']['URL'] = 'https://hk1-packages.consilio.com/hk1nas00/tech/Software/Relativity/'
  default['Relativity']['InvariantSource']['EXE'] = 'Relativity_9.4.346.43_-_Invariant_4.4.345.32_Processing_Installation_Package.exe'

    # Servivce Accounts
  default['Relativity']['Relativity']['Service_Account'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'hk_serviceaccountpassword', 'consiliopass123')['username']
  default['Relativity']['Relativity']['Service_Account_Password'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'hk_serviceaccountpassword', 'consiliopass123')['password']
  default['Relativity']['SQLServer']['Service_Account'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'hk_serviceaccountpassword', 'consiliopass123')['username']
  default['Relativity']['SQLServer']['Service_Account_Password'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'hk_serviceaccountpassword', 'consiliopass123')['password']

  # EDDSDBO user password
  default['Relativity']['eddsdbo']['Password'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'hk_eddsdbopassword', 'consiliopass123')['password']

  ################### COMMON DATABASE PROPERTIES #######################
  ### The following properites are required when installing Primary Database
  ######################################################################

  # Backup, Logs, Data and FullText directories
  default['Relativity']['Database']['BackupDir'] = "B:\\BACKUPS"
  default['Relativity']['Database']['LogsDir'] = "D:\\TLOG\\TLOG_01"
  default['Relativity']['Database']['DataDir'] = "D:\\USER_DATA\\DATA_01"
  default['Relativity']['Database']['FullTextDir'] = "D:\\NDF\\NDF_01"

  # FileRepo, EDDSFileShare and DTSearch Paths
  default['Relativity']['SQLPrimary']['FileRepo'] = '\\\\hk1nas01\\reldoc_repos_01\\'
  default['Relativity']['SQLPrimary']['EDDSFileShare'] = '\\\\hk1nas01\\reldoc_repos_01\\EDDS\\'
  default['Relativity']['SQLPrimary']['DTSearch'] = '\\\\hk1nas01\\dtsearch_01\\'

  ##### INVARIANT LOCAL DIRECTORIES FOR INSTALL #####
  # Target directory for the database log (.ldf) files.
  default['Relativity']['InvariantDatabase']['LogsDir'] = "D:\\TLOG\\TLOG_01"

  # Target directory for the database data (.mdf) files.
  default['Relativity']['InvariantDatabase']['DataDir'] = "D:\\USER_DATA\\DATA_01"

  # #### INVARIANT NETWORK DIRECTORIES FOR INSTALL
  # Invariant Network Path
  default['Relativity']['Invariant']['WorkerNetworkPath'] = "\\\\HK1VPDSQL12\\InvariantWorkerShare\\"

  # Invariant DTsearch Path
  default['Relativity']['Invariant']['DTSearchPath'] = '\\\\hk1nas01\\dtsearch_01\\'

  # Invariant Fileshare for data
  default['Relativity']['Invariant']['FilesharePath'] = "\\\\HK1VPDSQL12\\InvariantWorkerShare\\"

when 'UK'

  # Relativity Installers
  default['Relativity']['Source']['URL'] = 'https://lnt-packages.consilio.com/llnas00/tech/Software/Relativity/9.4/'
  default['Relativity']['Source']['EXE'] = 'Relativity_9.4.321.2_Installation_Package.exe'
  # Analytics Installers
  default['Relativity']['Source']['AnalyticsURL'] = 'https://lnt-packages.consilio.com/llnas00/tech/Software/Relativity/9.4/'
  default['Relativity']['Source']['AnalyticsMSI'] = '9.4.321.2_Relativity_Analytics_Server.msi'
  default['Consilio']['SSL']['ANXCert'] = 'http://packages.consilio.com/hlnas00/tech/Software/WildCard/AnxCert.pfx'
  # Invariant Installers
  default['Relativity']['InvariantSource']['URL'] = 'https://lnt-packages.consilio.com/llnas00/tech/Software/Relativity/9.4/'
  default['Relativity']['InvariantSource']['EXE'] = 'Relativity_9.4.321.2_Processing_Installation_Package_-_Invariant_4.4.315.2.exe'

    # Servivce Accounts
  default['Relativity']['Relativity']['Service_Account'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'uk_prod_serviceaccountpassword', 'consiliopass123')['username']
  default['Relativity']['Relativity']['Service_Account_Password'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'uk_prod_serviceaccountpassword', 'consiliopass123')['password']
  default['Relativity']['SQLServer']['Service_Account'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'uk_prod_serviceaccountpassword', 'consiliopass123')['username']
  default['Relativity']['SQLServer']['Service_Account_Password'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'uk_prod_serviceaccountpassword', 'consiliopass123')['password']

  # EDDSDBO user password
  default['Relativity']['eddsdbo']['Password'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'uk_prod_eddsdbopassword', 'consiliopass123')['password']

  ################### COMMON DATABASE PROPERTIES #######################
  ### The following properites are required when installing Primary Database
  ######################################################################

  # Backup, Logs, Data and FullText directories
  default['Relativity']['Database']['BackupDir'] = "D:\\USER_DATA" 
  default['Relativity']['Database']['LogsDir'] = "L:\\TLOG" 
  default['Relativity']['Database']['DataDir'] = "D:\\USER_DATA"
  default['Relativity']['Database']['FullTextDir'] = "D:\\USER_DATA"

  # FileRepo, EDDSFileShare and DTSearch Paths
  default['Relativity']['SQLPrimary']['FileRepo'] = '\\\\llnas08\\\reldoc_repo\\'
  default['Relativity']['SQLPrimary']['EDDSFileShare'] = '\\\\llnas08\\reldoc_repo\\EDDS\\'
  default['Relativity']['SQLPrimary']['DTSearch'] = '\\\\llnas08\\dt_search_storage\\'

  ##### INVARIANT LOCAL DIRECTORIES FOR INSTALL #####
  # Target directory for the database log (.ldf) files.
  default['Relativity']['InvariantDatabase']['LogsDir'] = "D:\\TLOG\\TLOG_01"

  # Target directory for the database data (.mdf) files.
  default['Relativity']['InvariantDatabase']['DataDir'] = "D:\\USER_DATA"

  # #### INVARIANT NETWORK DIRECTORIES FOR INSTALL
  # Invariant Network Path
  default['Relativity']['Invariant']['WorkerNetworkPath'] = "\\\\LLVPDSQL07\\InvariantWorker"

  # Invariant DTsearch Path
  default['Relativity']['Invariant']['DTSearchPath'] = '\\\\llnas08\\dt_search_storage\\'

  # Invariant Fileshare for data
  default['Relativity']['Invariant']['FilesharePath'] = "\\\\LLVPDSQL07\\InvariantWorker"

when 'US'
    
  # Relativity Installers
  default['Relativity']['Source']['URL'] = 'http://packages.consilio.com/hlnas00/tech/Software/Relativity/'
  default['Relativity']['Source']['EXE'] = '9.4.378.21_Relativity_Installation_Package.exe'
  # Analytics Installers
  default['Relativity']['Source']['AnalyticsURL'] = 'https://packages.consilio.com/hlnas00/tech/Software/Relativity/9.4/'
  default['Relativity']['Source']['AnalyticsMSI'] = 'Relativity_9.4.378.21_Analytics_Server.msi'
  default['Consilio']['SSL']['ANXCert'] = 'http://packages.consilio.com/hlnas00/tech/Software/WildCard/AnxCert.pfx'
  # Invariant Installers
  default['Relativity']['InvariantSource']['URL'] = 'https://packages.consilio.com/hlnas00/tech/Software/Relativity/9.4/'
  default['Relativity']['InvariantSource']['EXE'] = 'Relativity_9.4.378.21_-_Invariant_4.4.378.5_Processing_Installation_Package.exe'

    # Servivce Accounts
  default['Relativity']['Relativity']['Service_Account'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'us-serviceaccount', 'consiliopass123')['username']
  default['Relativity']['Relativity']['Service_Account_Password'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'us-serviceaccount', 'consiliopass123')['password']
  default['Relativity']['SQLServer']['Service_Account'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'us-serviceaccount', 'consiliopass123')['username']
  default['Relativity']['SQLServer']['Service_Account_Password'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'us-serviceaccount', 'consiliopass123')['password']

  # EDDSDBO user password
  default['Relativity']['eddsdbo']['Password'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'us_eddsdbopassword', 'consiliopass123')['password']

  ################### COMMON DATABASE PROPERTIES #######################
  ### The following properites are required when installing Primary Database
  ######################################################################

  # Backup, Logs, Data and FullText directories
  default['Relativity']['Database']['BackupDir'] = "D:\\USER_DATA" 
  default['Relativity']['Database']['LogsDir'] = "L:\\TLOG" 
  default['Relativity']['Database']['DataDir'] = "D:\\USER_DATA"
  default['Relativity']['Database']['FullTextDir'] = "D:\\USER_DATA"

  # FileRepo, EDDSFileShare and DTSearch Paths
  default['Relativity']['SQLPrimary']['FileRepo'] = '\\\\hlnas05\\data\\reldoc_repo\\'
  default['Relativity']['SQLPrimary']['EDDSFileShare'] = '\\\\hlnas05\\data\\reldoc_repo\\EDDS'
  default['Relativity']['SQLPrimary']['DTSearch'] = '\\\\hlnas08\\dt_search_storage\\'

  ##### INVARIANT LOCAL DIRECTORIES FOR INSTALL #####
  # Target directory for the database log (.ldf) files.
  default['Relativity']['InvariantDatabase']['LogsDir'] = "L:\\TLOG"

  # Target directory for the database data (.mdf) files.
  default['Relativity']['InvariantDatabase']['DataDir'] = "D:\\USER_DATA"

  # #### INVARIANT NETWORK DIRECTORIES FOR INSTALL
  # Invariant Network Path
  default['Relativity']['Invariant']['WorkerNetworkPath'] = "\\\\MLVPDSQL04\\InvariantWorker"

  # Invariant DTsearch Path
  default['Relativity']['Invariant']['DTSearchPath'] = '\\\\hlnas08\\dt_search_storage\\'

  # Invariant Fileshare for data
  default['Relativity']['Invariant']['FilesharePath'] = "\\\\hlnas05\\data\\reldoc_repo\\cache\\"

else

  # Relativity Installers
  default['Relativity']['Source']['URL'] = 'https://packages.consilio.com/hlnas00/tech/Software/Relativity/9.4/'
  default['Relativity']['Source']['EXE'] = '9.4.378.21_Relativity_Installation_Package.exe'
  # Analytics Installers
  default['Relativity']['Source']['AnalyticsURL'] = 'https://packages.consilio.com/hlnas00/tech/Software/Relativity/9.4/'
  default['Relativity']['Source']['AnalyticsMSI'] = 'Relativity_9.4.378.21_Analytics_Server.msi'
  default['Consilio']['SSL']['ANXCert'] = 'http://packages.consilio.com/hlnas00/tech/Software/WildCard/AnxCert.pfx'
  # Invariant Installers
  default['Relativity']['InvariantSource']['URL'] = 'https://packages.consilio.com/hlnas00/tech/Software/Relativity/9.4/'
  default['Relativity']['InvariantSource']['EXE'] = 'Relativity_9.4.378.21_-_Invariant_4.4.378.5_Processing_Installation_Package.exe'

  # Servivce Accounts
  default['Relativity']['Relativity']['Service_Account'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'vanilla-serviceaccountpassword', 'consiliopass123')['username']
  default['Relativity']['Relativity']['Service_Account_Password'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'vanilla-serviceaccountpassword', 'consiliopass123')['password']
  default['Relativity']['SQLServer']['Service_Account'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'vanilla-sqlserviceaccountpassword', 'consiliopass123')['username']
  default['Relativity']['SQLServer']['Service_Account_Password'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'vanilla-sqlserviceaccountpassword', 'consiliopass123')['password']

  # EDDSDBO user password
  default['Relativity']['eddsdbo']['Password'] = Chef::EncryptedDataBagItem.load('serviceaccounts', 'vanilla-eddsdbopassword', 'consiliopass123')['password']

  default['Attached']['DriveLetter'] = 'F:'

  ################### COMMON DATABASE PROPERTIES #######################
  ### The following properites are required when installing Primary Database
  ######################################################################

  # Backup, Logs, Data and FullText directories
  default['Relativity']['Database']['BackupDir'] = "#{node['Attached']['DriveLetter']}\\Backup"  
  default['Relativity']['Database']['LogsDir'] = "#{node['Attached']['DriveLetter']}\\Logs"  
  default['Relativity']['Database']['DataDir'] = "#{node['Attached']['DriveLetter']}\\Data"  
  default['Relativity']['Database']['FullTextDir'] = "#{node['Attached']['DriveLetter']}\\FullText"

  # FileRepo, EDDSFileShare and DTSearch Paths
  default['Relativity']['SQLPrimary']['FileRepo'] = ""
  default['Relativity']['SQLPrimary']['EDDSFileShare'] = ""
  default['Relativity']['SQLPrimary']['DTSearch'] = ""

  # #### INVARIANT LOCAL DIRECTORIES FOR INSTALL
  # Target directory for the database log (.ldf) files.
  default['Relativity']['InvariantDatabase']['LogsDir'] = "#{node['Attached']['DriveLetter']}\\Logs" 

  # Target directory for the database data (.mdf) files.
  default['Relativity']['InvariantDatabase']['DataDir'] = "#{node['Attached']['DriveLetter']}\\Data" 

  # #### INVARIANT NETWORK DIRECTORIES FOR INSTALL
  # Invariant Network Path
  default['Relativity']['Invariant']['WorkerNetworkPath'] = ""

  # Invariant DTSearchPath
  default['Relativity']['Invariant']['DTSearchPath'] = ""

  # Invariant Fileshare for data
  default['Relativity']['Invariant']['FilesharePath'] = ""

  ############ Analytics Attributes ##############
  ################################################
  default['Relativity']['Analytics']['CAATIndexDir'] = 'F:\\Analytics\\Indexes'
  default['Relativity']['Analytics']['RestUser'] = 'SLT_REL2'
  default['Relativity']['Analytics']['RestPassword'] = 'P@ssword01'

end
