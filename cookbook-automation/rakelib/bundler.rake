namespace :setup do
  desc 'Install bundler in the ChefDK embedded Ruby.'
  task :bundler do
    puts 'Installing bundler'
    stdout, stderr, status = Open3.capture3('chef gem install bundler')
    puts stdout
    puts stderr if status != 0 && stderr != ''
    raise('Bundler install failed.') unless status
  end
end
