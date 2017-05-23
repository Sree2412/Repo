require 'json'
require_relative './RestgenConfigurationEntity'

class RestgenConfiguration
    attr_accessor :entities, :enums
    
    def initialize(filepath)
        if filepath == nil || filepath.length == 0
            raise ArgumentError, 'RestgenConfiguration filepath needs to be a valid file path.'
        end
        filestr = File.read(filepath)
        config = JSON.parse(filestr)

        self.enums = config.key?('enums') ? config['enums'] : []
        
        self.entities = []
        config['entities'].each do |entity|
            self.entities.push(RestgenConfigurationEntity.new(entity, self))
        end
    end
    
    def entity_by_name(entityName)
        return self.entities.find {|s| s.name == entityName }
    end
end