namespace :setup do
  desc 'Use bundler to install gems from Gemfile to ChefDK embedded Ruby.'
  task :gems do
    puts 'Installing gems'
    stdout, stderr, status = Open3.capture3('chef exec bundle install')
    puts stdout
    puts stderr if status != 0 && stderr != ''
    raise('Bundler was unable to install required gems.') unless status
  end
end
