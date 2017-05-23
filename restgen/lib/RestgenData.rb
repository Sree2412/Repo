require 'json'
require 'securerandom'
require_relative './RestgenConfigurationSchemaItem'

class RestgenData
    attr_accessor :defaultLength, :int_pool_size, :string_pool_size, :bool_pool_size, :defaultMinValue, :defaultMaxValue
    
    def initialize
        self.defaultLength = 24
        self.int_pool_size = 10
        self.string_pool_size = 36
        self.bool_pool_size = 2
        self.defaultMinValue = 0
        self.defaultMaxValue = 10000
    end
    
    def compileSchema(entity, data = nil, config = nil)
        json = JSON.parse('{}')
        
        entity.schema.each do |item|
            if item.primaryKey == true || item.foreignKey != nil
                next if data == nil
                json[item.propertyName] = data[item.propertyName]
            else
                json[item.propertyName] = generate(item, config)
            end
        end
        
        return json.to_json
    end
    
    def generate(schemaItem = nil, config = nil)
        if schemaItem == nil
            return _generateUniqueString(self.string_pool_size, self.defaultLength)
        end
        
        len = schemaItem.length != nil ? schemaItem.length : self.defaultLength
        
        if schemaItem.maxlength != nil && schemaItem.length == nil && schemaItem.maxlength < len
            len = schemaItem.maxlength
        end
        
        case schemaItem.propertyType
            when "number"
                return _generateNumber(schemaItem.minValue != nil ? schemaItem.minValue : self.defaultMinValue, schemaItem.maxValue != nil ? schemaItem.maxValue : self.defaultMaxValue)
            when "boolean"
                return _generateUniqueString(self.bool_pool_size, 1) == "1"
            when "string"
                return _generateUniqueString(self.string_pool_size, len)
            else
                itemIndex = _generateNumber(0, config.enums[schemaItem.propertyType].length - 1)
                return config.enums[schemaItem.propertyType][itemIndex]
        end
    end
    
    def _generateUniqueString(poolSize, len)
        return SecureRandom.random_number(poolSize**len).to_s(poolSize).rjust(len, "0")
    end
    
    def _generateNumber(min, max)
        return rand(min..max)
    end
end