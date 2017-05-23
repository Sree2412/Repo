require_relative '../spec_helper'

# rubocop:disable LineLength
describe 'relativity-scaled-automation-sri::setup_sql' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(
      log_level: :error,
      platform: 'windows',
      version: '2012',
      file_cache_path: '/var/chef/cache'
    ) do |node|
      node.set['memory']['total'] = '4094304kb'
      node.set['Relativity']['SQLServer']['Service_Account'] = 'SQLServiceAccount'
      node.set['Relativity']['Relativity']['Service_Account'] = 'ServiceAccount'
      allow_any_instance_of(Chef::DSL::RegistryHelper).to receive(:registry_key_exists?).and_return(true)
      allow_any_instance_of(Chef::DSL::RegistryHelper).to receive(:registry_value_exists?).and_return(false)
    end.converge('relativity-scaled-automation-sri::setup_sql')
  end

  ENV['WINDIR'] = 'C:\\Windows'

  it 'Configure Windows Optimization Settings' do
    expect(chef_run).to include_recipe('relativity-scaled-automation-sri::optimize_windows')
  end

  it 'Modifies the Admin group by adding the Relativity Service account to it' do
    expect(chef_run).to modify_group('Administrators')
      .with(members: ['SQLServiceAccount'])
  end

  it 'Creates the setSPN batch file' do
    expect(chef_run).to create_template('Create_SPN')
      .with(source: 'SetSPN.bat.erb')
  end

  it 'Create Scheduled Task and run the bat file' do
    expect(chef_run).to run_powershell_script('Set_SPN')
  end

  it 'Install .NET 3.5' do
    expect(chef_run).to include_recipe('dotnet::dotnet-3.5')
  end

  it 'Install .NET 4.5.1' do
    expect(chef_run).to include_recipe('dotnetframework::default')
  end

  it 'Installs MSSQL' do
    expect(chef_run).to create_sqlserver_instance('MSSQLSERVER')
      .with(
        source: 'http://packages.consilio.com/hlnas00/tech/Software/SQLServer/2012/Dev/en_sql_server_2012_developer_edition_with_service_pack_2_x64_dvd_4668513.iso',
        version: '2012',
        features: 'SQLENGINE,FullText,SSMS',
        sysadmins: 'engineering, SQLServiceAccount, ServiceAccount')
  end

  it 'stops SQLSERVERAGENT' do
    expect(chef_run).to stop_windows_service('SQLSERVERAGENT')
  end

  it 'stops MSSQLSERVER' do
    expect(chef_run).to stop_windows_service('MSSQLSERVER')
  end

  it 'Assigns service account to MSSQLSERVER and does nothing else' do
    expect(chef_run).to_not start_windows_service('MSSQLSERVER').with(run_as_user: 'SQLServiceAccount')
  end

  it 'Assigns service account to SQLSERVERAGENT and does nothing else' do
    expect(chef_run).to_not start_windows_service('SQLSERVERAGENT').with(run_as_user: 'SQLServiceAccount')
  end

  it 'Starts the SQLSERVERAGENT service and dependencies' do
    expect(chef_run).to run_powershell_script('Start_SQLSERVERAGENT')
  end

  it 'Installs Application Server' do
    expect(chef_run).to install_windows_feature('Application-Server')
  end

  it 'Installs Distributed Transaction Support' do
    expect(chef_run).to install_windows_feature('AS-Dist-Transaction')
  end

  it 'Installs Incoming Remote Transaction' do
    expect(chef_run).to install_windows_feature('AS-Incoming-Trans')
  end

  it 'Installs Outgoing Remote Transaction' do
    expect(chef_run).to install_windows_feature('AS-Outgoing-Trans')
  end

  it 'Installs Failover-Cluster' do
    expect(chef_run).to install_windows_feature('FailoverCluster-FullServer')
  end

  it 'Creates a registry key for SetAllowRemoteClients set to 1' do
    expect(chef_run)
      .to create_registry_key('SetAllowRemoteClients')
      .with(values:
    [{
      name: 'NetworkDtcAccessClients',
      type: :dword,
      data: '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b'
    }],
            key: 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\MSDTC\\Security')
  end

  it 'Creates a registry key for SetAllowInbound set to 1' do
    expect(chef_run)
      .to create_registry_key('SetAllowInbound')
      .with(values:
    [{
      name: 'NetworkDtcAccessInbound',
      type: :dword,
      data: '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b'
    }],
            key: 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\MSDTC\\Security')
  end

  it 'Creates a registry key for SetAllowOutbound set to 1' do
    expect(chef_run)
      .to create_registry_key('SetAllowOutbound')
      .with(values:
    [{
      name: 'NetworkDtcAccessOutbound',
      type: :dword,
      data: '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b'
    }],
            key: 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\MSDTC\\Security')
  end

  it 'Creates new template file on server, create EDDSDBO user script' do
    expect(chef_run).to create_template('CreateEDDSDBOUser')
      .with(source: 'CreateUsers.erb')
  end

  it 'Creates user in SQL instance' do
    expect(chef_run).to run_execute('CreateUsers')
      .with(command: "sqlcmd -i #{Chef::Config[:file_cache_path]}/CreateUsers.sql")
  end

  it 'Restarts SQL services' do
    expect(chef_run).to run_batch('Enable_Mixed_Auth_Mode')
  end

  it 'Creates the FileShare Dir' do
    expect(chef_run).to create_directory('Create_FileShare_Dir')
  end

  it 'Creates the EDDSFileShare Dir' do
    expect(chef_run).to create_directory('Create_EDDSFileShare_Dir')
  end

  it 'Creates the DTSearch Dir' do
    expect(chef_run).to create_directory('Create_DTSearch_Dir')
  end

  it 'Creates the InvariantNetworkShare Dir' do
    expect(chef_run).to create_directory('Create_InvariantNetworkShare_Dir')
  end

  it 'Creates the BCPPath Dir' do
    expect(chef_run).to create_directory('Create_BCPPath_Dir')
  end

  it 'Creates the Logs Dir' do
    expect(chef_run).to create_directory('Create_Logs_Dir')
  end

  it 'Creates the Data Dir' do
    expect(chef_run).to create_directory('Create_Data_Dir')
  end

  it 'Creates the Backup Dir' do
    expect(chef_run).to create_directory('Create_Backup_Dir')
  end

  it 'Creates the FullText Dir' do
    expect(chef_run).to create_directory('Create_FullText_Dir')
  end

  it 'Creates Batch file on server' do
    expect(chef_run).to create_template('Create_Batch_File_on_Server')
  end

  it 'Creates shares' do
    expect(chef_run).to run_execute('Create_Shares')
  end

  it 'deletes the batch file' do
    expect(chef_run).to delete_file('C:\\CreateShares.bat')
  end
end
