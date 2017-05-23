require 'json'
require_relative './RestgenConfigurationSchemaItem'

class RestgenConfigurationSchema
    attr_accessor :schemaItems
    
    def initialize(json_data, configuration)
        self.schemaItems = []
        json_data.each do |item|
            _validateDataType(item['propertyType'], configuration)
            self.schemaItems.push(RestgenConfigurationSchemaItem.new(item))
        end
    end

    def _validateDataType(type, config)
        nativeDataTypes = ['string', 'number', 'boolean']
        enumDataTypes = config.enums.keys
        if !nativeDataTypes.include?(type) && !enumDataTypes.include?(type)
            raise 'Unable to resolve data type "' + type + '"'
        end
    end
    
end