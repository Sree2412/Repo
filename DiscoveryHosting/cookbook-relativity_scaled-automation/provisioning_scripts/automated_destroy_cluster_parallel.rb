require 'chef/provisioning'

# Set ClusterName same as ClusterName var in tier2_parallel
ClusterName = 'kumar_env'.freeze
servernames = []

# Search for all the node names that match the ClusterName
if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
else
  search(:node, "name:#{ClusterName}*",
         filter_result: { 'name' => ['name'] }
        ).each do |server|
    servernames.push(server['name'])
  end
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
