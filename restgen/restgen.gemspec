Gem::Specification.new do |s|
  s.name        = 'restgen'
  s.version     = '0.0.9'
  s.date        = '2017-04-03'
  s.summary     = "Added start/end blocks to the logging"
  s.description = "A REST service generator to test REST services with generated data"
  s.authors     = ["Brian Ushman", "Kumar Shrestha"]
  s.email       = 'bushman@consilio.com'
  s.files       = ["lib/rest-generator.rb","lib/RestgenConfiguration.rb","lib/RestgenData.rb","lib/RestgenConfigurationEntity.rb","lib/RestgenConfigurationSchema.rb","lib/RestgenConfigurationSchemaItem.rb","lib/RestgenLogger.rb","lib/RestgenOutputter.rb"]
  s.homepage    =
    'https://github.consilio.com/QA/restgen'
  s.license       = 'MIT'
end