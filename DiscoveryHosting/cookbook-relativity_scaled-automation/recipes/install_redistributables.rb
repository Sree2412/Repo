# Copyright 2016, Consilio, LLC
#
# All rights reserved - Do Not Redistribute
#
# rubocop:disable LineLength

dist_2010_86 = File.join(node['Install']['redistributables'], 'vcredist_x86_2010.exe')
dist_2010_64 = File.join(node['Install']['redistributables'], 'vcredist_x64_2010.exe')
dist_2012_86 = File.join(node['Install']['redistributables'], 'vcredist_x86_2012.exe')
dist_2012_64 = File.join(node['Install']['redistributables'], 'vcredist_x64_2012.exe')
dist_2013_86 = File.join(node['Install']['redistributables'], 'vcredist_x86_2013.exe')
dist_2013_64 = File.join(node['Install']['redistributables'], 'vcredist_x64_2013.exe')

puts dist_2010_86
puts dist_2010_64
puts dist_2012_86
puts dist_2012_64
puts dist_2013_86
puts dist_2013_64


directory 'create_redistributables_dir' do
  path 'C:/redistributables'
end

remote_file 'dist_2010_86' do
  source dist_2010_86
  path 'C:/redistributables/vcredist_x86_2010.exe'
  not_if { File.exist?('C:/redistributables/vcredist_x86_2010.exe') }
end

remote_file 'dist_2010_64' do
  source dist_2010_64
  path 'C:/redistributables/vcredist_x64_2010.exe'
  #not_if { File.exist?('C:\\redistributables\\vcredist_x64_2010.exe') }
end
remote_file 'dist_2012_86' do
  source dist_2012_86
  path 'C:/redistributables/vcredist_x86_2012.exe'
  #not_if { File.exist?('C:\\redistributables\\vcredist_x64_2010.exe') }
end

remote_file 'dist_2012_64' do
  source dist_2012_64
  path 'C:/redistributables/vcredist_x64_2012.exe'
  #not_if { File.exist?('C:\\redistributables\\vcredist_x64_2010.exe') }
end

remote_file 'dist_2013_86' do
  source dist_2013_86
  path 'C:/redistributables/vcredist_x86_2013.exe'
  #not_if { File.exist?('C:\\redistributables\\vcredist_x64_2010.exe') }
end

remote_file 'dist_2013_64' do
  source dist_2013_64
  path 'C:/redistributables/vcredist_x64_2013.exe'
  #not_if { File.exist?('C:\\redistributables\\vcredist_x64_2010.exe') }
end

cookbook_file 'add_install_bat' do
  source 'install_redist.bat'
  path 'C:/install_redist.bat'
end

batch 'install_redist' do
  code <<-EOH
  @echo off
  C:
  cd C:/redistributables
  vcredist_x86_2010.exe /passive /norestart
  vcredist_x64_2010.exe /passive /norestart
  vcredist_x86_2012.exe /passive /norestart
  vcredist_x64_2012.exe /passive /norestart
  vcredist_x86_2013.exe /passive /norestart
  vcredist_x64_2013.exe /passive /norestart
  EOH
end

