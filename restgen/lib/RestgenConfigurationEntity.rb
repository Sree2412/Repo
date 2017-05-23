require 'json'
require_relative './RestgenConfigurationSchema'

class RestgenConfigurationEntity
    attr_accessor :name, :schema, :get, :post, :put, :patch, :delete
    
    def initialize(json_data, config)
        self.name = json_data['name']
        self.schema = RestgenConfigurationSchema.new(json_data['schema'], config).schemaItems
        self.get = json_data['get']
        self.post = json_data['post']
        self.put = json_data['put']
        self.patch = json_data['patch']
        self.delete = json_data['delete']
    end
    
    def getPrimaryKey
        self.schema.each do |item|
            if item.primaryKey == true
                return item
            end
        end
        return nil
    end    
    
    def getForeignKeys
        items = []
        self.schema.each do |item|
            if item.foreignKey != nil
                items.push(item)
            end
        end
        return items
    end    
end