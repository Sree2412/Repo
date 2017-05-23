require 'json'

class UIgenConfigurationItem
    attr_accessor :name, :class, :dependency
    
    def initialize(json_data, config)
        self.name = json_data['name']
        self.class = json_data['class']
        self.dependency = json_data['dependency']
    end
end