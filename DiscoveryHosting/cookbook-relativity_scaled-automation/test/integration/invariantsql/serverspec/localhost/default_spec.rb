require 'spec_helper'

# rubocop:disable LineLength, AmbiguousRegexpLiteral

# BEGIN TEST FOR USERS AND GROUPS
describe 'User and Group resourc types' do
  # TEST THAT THE Administrators GROUP IS SETUP
  describe group('Administrators') do
    it { should exist }
  end
end
# END TEST FOR USERS AND GROUPS

# BEGIN TEST FOR WINDOWS FEATURES
describe 'Windows Feature resourc type' do
  describe windows_feature('Application-Server') do
    it { should be_installed }
  end

  describe windows_feature('AS-Dist-Transaction') do
    it { should be_installed }
  end

  describe windows_feature('AS-Incoming-Trans') do
    it { should be_installed }
  end

  describe windows_feature('AS-Outgoing-Trans') do
    it { should be_installed }
  end

  describe windows_feature('FailoverCluster-FullServer') do
    it { should be_installed }
  end

  # TEST THAT .NET 3.5 IS INSTALLED
  describe windows_feature('NetFx3') do
    it { should be_installed }
  end

  # TEST THAT .NET 4.5.1 IS INSTALLED
  describe windows_feature('NetFx4') do
    it { should be_installed }
  end
end
# END TEST FOR WINDOWS FEATURES

# BEGIN SQL SERVER 2012 TESTS
describe 'SQL Server 2012' do
  # TEST THAT SQL SERVER 2012 IS INSTALLED
  describe package('Microsoft SQL Server 2012 (64-bit)') do
    it { should be_installed }
  end

  # TEST THAT THE SQL SERVICE IS INSTALLED, ENABLED AND
  # RUNNING AND SET TO START AUTOMATICALLY
  describe service('SQL Server (MSSQLSERVER)') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
    it { should have_start_mode('Automatic') }
  end

  # TEST THAT PORT 1433 IS OPEN
  describe port(1433) do
    it { should be_listening.with('tcp') }
  end
end
# END SQL SERVER 2012 TESTS

# BEGIN TESTS FOR WINDOWS REGISTRY KEYS
describe 'Windows Registry Key resource type' do
  describe windows_registry_key(
    'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\MSDTC\\Security') do
    it { should exist }
    it do
      should have_property_value(
        'NetworkDtcAccessClients', :type_dword, '1')
    end
  end

  describe windows_registry_key(
    'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\MSDTC\\Security') do
    it { should exist }
    it do
      should have_property_value(
        'NetworkDtcAccessInbound', :type_dword, '1')
    end
  end

  describe windows_registry_key(
    'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\MSDTC\\Security') do
    it { should exist }
    it do
      should have_property_value(
        'NetworkDtcAccessOutbound', :type_dword, '1')
    end
  end

  describe windows_registry_key(
    'HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Power\\User\\PowerSchemes') do
    it { should exist }
    it do
      should have_property_value(
        'ActivePowerScheme', :type_string, '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c')
    end
  end

  # Check SQL Authentication Mode
  describe windows_registry_key(
    'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQLServer') do
    it { should exist }
    it do
      should have_property_value(
        'LoginMode', :type_dword, '2')
    end
  end
end

describe 'Check result if user does not exist and if the user does exist' do
  sql = "SELECT ISNULL(CAST(SUSER_ID('NO_USER') AS VARCHAR(10)), 'NO_USER')"
  cmd = "& 'C:\\Program Files\\Microsoft SQL Server\\110\\Tools\\Binn\\SQLCMD.EXE' -W -h -1 -Q \"#{sql}\""
  describe command cmd do
    its(:stdout) { should match /NO_USER/ }
  end

  sql = "SELECT ISNULL(CAST(SUSER_ID('EDDSDBO') AS VARCHAR(10)), 'NO_USER')"
  cmd = "& 'C:\\Program Files\\Microsoft SQL Server\\110\\Tools\\Binn\\SQLCMD.EXE' -W -h -1 -Q \"#{sql}\""
  describe command cmd do
    its(:stdout) { should_not match /NO_USER/ }
  end
end

describe 'Check if user is assigned to neccessary roles' do
  sql = "select distinct 1
            from [sys].[server_role_members]
              inner join [sys].[server_principals] as roles
                on roles.[principal_id] = [server_role_members].[role_principal_id]
                inner join [sys].[server_principals] as logins
                on logins.[principal_id] = [server_role_members].[member_principal_id]
            where logins.[name] = 'eddsdbo' and
              roles.[name] in ('dbcreator', 'bulkadmin')"
  cmd = "& 'C:\\Program Files\\Microsoft SQL Server\\110\\Tools\\Binn\\SQLCMD.EXE' -W -h -1 -Q \"#{sql}\""
  describe command cmd do
    its(:stdout) { should match /1/ }
  end

  sql = "select distinct 1
          from [sys].[server_role_members]
            inner join [sys].[server_principals] as roles
              on roles.[principal_id] = [server_role_members].[role_principal_id]
              inner join [sys].[server_principals] as logins
              on logins.[principal_id] = [server_role_members].[member_principal_id]
          where logins.[name] = 'kxmoss' and roles.[name] in
            ('dbcreator', 'bulkadmin')"
  cmd = "& 'C:\\Program Files\\Microsoft SQL Server\\110\\Tools\\Binn\\SQLCMD.EXE' \
  -W -h -1 -Q \"#{sql}\""
  describe command cmd do
    its(:stdout) { should match /(0 row(s) affected)/ }
  end
end

describe 'Directories were created' do
  describe file 'F:\FileShare' do
    it { should be_directory }
  end

  describe file 'F:\EDDSFileShare' do
    it { should be_directory }
  end

  describe file 'F:\DTSearch' do
    it { should be_directory }
  end

  describe file 'F:\Logs' do
    it { should be_directory }
  end

  describe file 'F:\Data' do
    it { should be_directory }
  end

  describe file 'F:\Backup' do
    it { should be_directory }
  end

  describe file 'F:\FullText' do
    it { should be_directory }
  end
end
