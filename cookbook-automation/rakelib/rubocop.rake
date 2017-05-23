namespace :style do
  desc 'Run RuboCop linting against the cookbook.'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.patterns = ['recipes/*.rb',
                     '*.rb',
                     'files/default/*.rb',
                     'files/default/*.rake',
                     'templates/default/*.rb.erb',
                     'templates/default/*.rake.erb',
                     'spec/*.rb',
                     'spec/recipes/*.rb',
                     'test/**/**/**/*.rb',
                     'test/**/**/**/**/*.rb',
                     'Rakefile',
                     'Gemfile'
                    ]
    task.fail_on_error = true
  end
end
