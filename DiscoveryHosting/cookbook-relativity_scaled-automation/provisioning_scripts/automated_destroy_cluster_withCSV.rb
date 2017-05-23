require 'chef/provisioning'
require 'CSV'

# Set ClusterName same as ClusterName var in tier2_parallel
ClusterName = 'Rel94-InternalTest'.freeze
# Path to CSV that has hostnames of servers
CSV_Path = "C:\\knowledgeshare\\TestServers.csv"

servernames = []

### increment the node count for each role and add the server names to role array
CSV.foreach(CSV_Path) do | x,y |
  servernames << x  
end

# Destroy all nodes that match the ClusterName
with_chef_server(
  'https://chef.consilio.com/organizations/consilio-dev',
  client_name: Chef::Config[:node_name],
  signing_key_filename: Chef::Config[:client_key]
) do
  with_driver 'vra:https://cloud.consilio.com' do
    machine_batch do
      machines servernames
      action :destroy
    end
  end
end
