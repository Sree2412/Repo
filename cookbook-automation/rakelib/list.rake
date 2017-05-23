desc 'List tasks'
task :list do
  sh 'chef exec rake -T'
end
