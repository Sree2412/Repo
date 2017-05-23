namespace :build do
  desc 'Deploy cookbook to chef server'
  task :deploy do
    # check for a dev.chef in home
    home = File.expand_path('~')
    if File.directory?(home + '/dev.chef')
      # use dev.chef on jenkins
      if File.directory?('.chef')
        # cleanup just in case
        FileUtils.rm_r '.chef'
      end
      if File.file?('Berksfile.lock')
        # cleanup just in case
        File.delete('Berksfile.lock')
      end
      FileUtils.cp_r(home + '/dev.chef', '.chef')
      begin
        last_uploaded = `knife cookbook show http_file_serve \
                       | tr -s " " | cut -d " " -f 2`
      rescue
        puts 'Knife command errored, likely means no cookbook of '\
             'this name exists on the chef server'
        last_uploaded = '0.0.0'
      end
      incoming_version = `cat metadata.rb | grep \
                         version | awk -F"'" '{print $2}'`
      if Gem::Version.new(incoming_version) > Gem::Version.new(last_uploaded)
        puts 'Deploying cookbook to dev chef server.'
        sh 'berks install'
        sh 'berks upload'
        FileUtils.rm_r '.chef'
        File.delete('Berksfile.lock')
        if File.directory?(home + '/main.chef')
          FileUtils.cp_r(home + '/main.chef', '.chef')
          puts 'Deploying cookbook to prod chef server.'
          sh 'berks install'
          sh 'berks upload'
        else
          puts 'Production chef was not updated, \
                as its configuration was not found.'
        end
        puts 'Tagging version into github.'
        sh "git tag #{incoming_version}"
        sh "git push origin #{incoming_version}"
      else
        puts 'There is nothing to deploy.  Current version already deployed.'
      end
    else
      puts 'To deploy, this task needs to be run from CI.'
    end
    CLEAN.include('Berksfile.lock')
    CLEAN.include('.chef')
  end
end
