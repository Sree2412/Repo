require 'chefspec'
require 'chefspec/berkshelf'
require_relative('helpers/automatic_resource_matcher.rb')
require_relative('helpers/iis_config.rb')
ChefSpec::Coverage.start!
