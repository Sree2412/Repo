# add the qa ruby user to the rvm users group
group 'rvm' do
  append true
  members [node['qa']['ruby']['user']]
  action :create
end

# get the RVM signing key, if we don't already have it
execute 'grab_key' do
  command 'curl -sSL https://rvm.io/mpapis.asc | gpg --import -'
  action :run
  not_if "gpg --list-keys | grep -e '(RVM signing)'"
end

# Get and install rvm stable, if we don't already have it
execute 'install_rvm' do
  command 'curl -sSL https://get.rvm.io | bash -s stable'
  creates '/usr/local/rvm/bin/rvm'
  action :run
end

# Install a new version of ruby, only if that version isn't already installed
# To safely do this with new versions, we need to also get head and
# requirements each time
bash 'rvm_ruby' do
  code <<-EOH
  /usr/local/rvm/bin/rvm get head
  /usr/local/rvm/bin/rvm requirements
  /usr/local/rvm/bin/rvm install #{node['qa']['ruby']['version']}
  /usr/local/rvm/bin/rvm alias create default #{node['qa']['ruby']['version']}
  EOH
  action :run
  not_if '/usr/local/rvm/bin/rvm list |'\
         " grep -e '#{node['qa']['ruby']['version']}'"
end
