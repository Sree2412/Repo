require 'json'

class UIgenConfiguration
    attr_accessor :actions
    
    def initialize(filepath)
        if filepath == nil || filepath.length == 0
            raise ArgumentError, 'UIgenConfiguration filepath needs to be a valid file path.'
        end
        filestr = File.read(filepath)
        config = JSON.parse(filestr)
        
        self.actions = []
        config['actions'].each do |action|
            self.actions.push(UIgenConfigurationItem.new(action, self))
        end
    end
    
    def action_by_name(actionName)
        return self.actions.find {|s| s.name == actionName }
    end
end