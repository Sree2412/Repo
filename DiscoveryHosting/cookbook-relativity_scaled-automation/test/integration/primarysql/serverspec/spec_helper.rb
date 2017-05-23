require 'serverspec'
require 'rspec_junit_formatter'

if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
  # set windows settings
  set :backend, :cmd
  set :os, family: 'windows', release: '2012'
else
  # set linux settings
  set :backend, :exec
end

RSpec.configure do |c|
  c.formatter = 'RspecJunitFormatter'
  # c.output_stream = 'serverspec.xml'
end
