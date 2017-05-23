namespace :unit do
  desc 'Run chefspec tests against the cookbook.'
  RSpec::Core::RakeTask.new(:chefspec) do |task|
    puts 'Running chefspec...'
    task.pattern = Dir.glob('spec/**/*_spec.rb')
    task.rspec_opts = '--format RspecJunitFormatter '\
                      '-o Reports/chefspec.xml '\
                      '--color '\
                      '--format documentation'
  end
  CLEAN.include('Reports')
  CLEAN.include('Logs')
end
