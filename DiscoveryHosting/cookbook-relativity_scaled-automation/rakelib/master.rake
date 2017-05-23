namespace 'push' do
  desc 'CI Push to master'
  task :master do
    # get chef server config from git and clean up any berks/chef stuff
    # already existing in the directory
    repo = 'https://github.consilio.com/CID/chef_config.git'
    File.delete('Berksfile.lock') if File.file?('Berksfile.lock')
    FileUtils.rm_r('.chef') if File.directory?('.chef')
    Git.clone(repo, '.chef')

    # now, open the existing repo, make sure to get the latest then make
    # sure we have both the develop and master branches local (by checking
    # them out), then merge develop onto master, and push to master.
    g = Git.open('.')
    g.pull
    g.checkout('develop')
    g.checkout('master')
    g.merge('develop')
    g.push
  end
end
