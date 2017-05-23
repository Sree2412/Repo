namespace :build do
  desc 'Deploy cookbook to chef server'
  task :deploy do
    repo = 'https://github.consilio.com/CID/chef_config.git'
    # check for a dev.chef in home
    File.delete('Berksfile.lock') if File.file?('Berksfile.lock')
    FileUtils.rm_r('.chef') if File.directory?('.chef')
    Git.clone(repo, '.chef')
    begin
      last_uploaded = `knife cookbook show cookbook-relativity_scaled-automation \
                     | tr -s " " | cut -d " " -f 2`
    rescue
      puts 'Knife command errored, likely means no cookbook of '\
           'this name exists on the chef server'
      last_uploaded = '0.0.0'
    end
    incoming_version = version?
    if Gem::Version.new(incoming_version) > Gem::Version.new(last_uploaded)
      puts 'Deploying cookbook to prod chef server.'
      sh 'berks install'
      sh 'berks upload --except integration'
      puts 'Tagging version into github.'
      g = Git.open('.')
      g.add_tag(incoming_version, message: 'tagged by JenkinsCI')
      g.push('origin', "refs/tags/#{incoming_version}")
    else
      puts 'There is nothing to deploy.  Current version already deployed.'
    end
    CLEAN.include('Berksfile.lock')
    CLEAN.include('.chef')
  end
end
