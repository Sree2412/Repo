namespace :setup do
  desc 'Use Berkshelf to update required cookbooks from the berksfile'
  task :cookbooks do
    puts 'Updating cookbooks'
    stdout, stderr, status = Open3.capture3('chef exec berks install')
    puts stdout
    puts stderr if status != 0 && stderr != ''
    raise('Berkshelf was unable to update cookbooks.') unless status
  end
end
