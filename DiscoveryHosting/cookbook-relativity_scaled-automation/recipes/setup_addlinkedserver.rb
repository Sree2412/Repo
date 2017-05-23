# Copyright 2016, Consilio, LLC
#
# All rights reserved - Do Not Redistribute
#

sql_script 'Link To Primary SQL' do
  code 'EXEC sp_addlinkedserver '\
       "#{node['Relativity']['Install']['PrimaryInstance']};"
  action :run
end
