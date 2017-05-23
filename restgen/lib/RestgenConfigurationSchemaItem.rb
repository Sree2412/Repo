require 'json'

class RestgenConfigurationSchemaItem
    attr_accessor :propertyName, :propertyType, :minlength, :maxlength, :length, :minValue, :maxValue, :primaryKey, :foreignKey, :dependentProperty, :exclude, :pseudoPost
    
    def initialize(json_data)
        self.propertyName = json_data['propertyName']
        self.propertyType = json_data['propertyType']
        self.minlength = json_data['minlength']
        self.maxlength = json_data['maxlength']
        self.length = json_data['length']
        self.minValue = json_data['minValue']
        self.maxValue = json_data['maxValue']
        self.primaryKey = json_data['primaryKey'] == nil ? false : json_data['primaryKey']
        self.foreignKey = json_data['foreignKey']
        self.dependentProperty = json_data['dependentProperty']
        self.exclude = json_data['exclude'] == nil ? false : json_data['exclude']
        self.pseudoPost = json_data['pseudoPost'] == nil ? false : json_data['pseudoPost']

        #check for any attribute validations
        if self.pseudoPost == true && self.foreignKey == nil
            raise "Attribute validation failed for entity: #{self.propertyName}. When pseudoPost is set, then the foreignKey must also be set."
        end
    end
    
end