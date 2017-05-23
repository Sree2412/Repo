require 'rubygems'
require 'bundler/setup'
require 'RestServiceBase'
require 'json'

require_relative './RestgenData'
require_relative './RestgenConfiguration'
require_relative './RestgenConfigurationEntity'
require_relative './RestgenOutputter'
require_relative './RestgenLogger'

class Restgen
    attr_accessor :url, :username, :password, :config, :data, :logger
    
    def initialize(url = nil)
        self.url = url
        self.username = ""
        self.password = ""
        self.config = nil
        self.data = RestgenData.new()

        self.logger = RestgenLogger.new

        log_message("Restgen initialized with url #{url}")
    end

    def set_log_filepath(filename)
        self.logger.outputters.push(RestgenFileOutputter.new filename)
    end

    def log_message(msg)
        self.logger.log msg
    end

    def log_method_marker(msg, caller)
        log_message(msg) if caller == nil
    end
    
    def load_configuration(filename)
        self.config = RestgenConfiguration.new(filename)
    end
    
    def set_auth(username, password)
        self.username = username
        self.password = password

        log_message("set_auth username: \"#{self.username}\" ")
    end
    
    def rest_svc(url)
        svc = RestServiceBase.new(url)
        svc.set_auth(self.username, self.password)
        return svc
    end
    
    def get(entityName: nil, caller: nil)
        log_method_marker("[Start Block][GET] #{entityName}", caller)

        entity = _findEntity(entityName)

        hasProperties = _hasReplacementProperties(entity, 'get')

        if hasProperties
            postData = self.post(entityName: entityName, caller: self)[:body]
            
            fullUrl = _buildUrl("get", entityName: entityName, url: url)
            fullUrl = _stringReplaceValues(fullUrl, JSON.parse(postData))
            
            #append the input object
            svc_result = rest_svc(fullUrl).get
            svc_result[:inputObject] = postData
        else
            fullUrl = _buildUrl("get", entityName: entityName, url: url)
            svc_result = rest_svc(fullUrl).get
        end

        log_message("[GET] #{entityName}: #{svc_result}")
        log_method_marker("[End Block][GET] #{entityName}", caller)
        return svc_result
    end
    
    def post(entityName: nil, dependentData: nil, caller: nil)
        log_method_marker("[Start Block][POST] #{entityName}", caller)

        entity = _findEntity(entityName)
        if entity.post != nil
            postData = self.data.compileSchema(entity, nil, self.config)
            
            #only create the dependencies if no dependentData is passed in
            if dependentData == nil
                postData = _createDependencies(entity, postData)
            else
                postData = _createDependencies(entity, postData, dependentData)
            end
            
            fullUrl = _buildUrl("post", entityName: entityName)        
            fullUrl = _stringReplaceValues(fullUrl, JSON.parse(postData))
            
            #append the input object
            postData = _stageData(entity, postData)
            svc_result = rest_svc(fullUrl).post(postData)
            svc_result[:inputObject] = postData
        else
            svc_result = JSON.parse('{}')
            svc_result[:body] = self._randomGet(entityName: entityName).to_json()
        end
        log_message("[POST] #{entityName}: #{svc_result}")
        log_method_marker("[End Block][POST] #{entityName}", caller)
        return svc_result
    end
    
    def patch(entityName: nil, caller: nil)
        log_method_marker("[Start Block][PATCH] #{entityName}", caller)

        postData = self.post(entityName: entityName, caller: self)[:body]
        
        entity = _findEntity(entityName)
        fullUrl = _buildUrl("patch", entityName: entityName)
        
        patchData = self.data.compileSchema(entity, nil, self.config)
        fullUrl = _stringReplaceValues(fullUrl, JSON.parse(postData))
        
        #append the input object
        patchData = _stageData(entity, patchData)
        svc_result = rest_svc(fullUrl).patch(patchData)
        svc_result[:inputObject] = patchData
        log_message("[PATCH] #{entityName}: #{svc_result}")
        log_method_marker("[End Block][PATCH] #{entityName}", caller)
        return svc_result
    end
    
    def put(entityName: nil, caller: nil)
        log_method_marker("[Start Block][PUT] #{entityName}", caller)

        postData = JSON.parse(self.post(entityName: entityName, caller: self)[:body])
        
        entity = _findEntity(entityName)
        fullUrl = _buildUrl("put", entityName: entityName)
        
        putData = self.data.compileSchema(entity, postData, self.config)
        fullUrl = _stringReplaceValues(fullUrl, postData)
        
        #append the input object
        putData = _stageData(entity, putData)
        svc_result = rest_svc(fullUrl).put(putData)
        svc_result[:inputObject] = putData
        log_message("[PUT] #{entityName}: #{svc_result}")
        log_method_marker("[End Block][PUT] #{entityName}", caller)
        return svc_result
    end
    
    def delete(entityName: nil, caller: nil)
        log_method_marker("[Start Block][DELETE] #{entityName}", caller)

        postData = JSON.parse(self.post(entityName: entityName, caller: self)[:body])
        
        fullUrl = _buildUrl("delete", entityName: entityName)
        
        fullUrl = _stringReplaceValues(fullUrl, postData)
        
        #append the input object
        svc_result = rest_svc(fullUrl).delete
        svc_result[:inputObject] = postData.to_json
        log_message("[DELETE] #{entityName}: #{svc_result}")
        log_method_marker("[End Block][DELETE] #{entityName}", caller)
        return svc_result
    end

    def _randomGet(entityName: nil)
        fullUrl = _buildUrl("get", entityName: entityName, url: url)
        values = JSON.parse(rest_svc(fullUrl).get[:body])["value"]

        if values.length == 0
            raise "RandomGET failed because the entities has 0 values created.  There must be at least 1 entity created"
        end

        return_val = values[rand(0..values.length - 1)]

        log_message("[_randomGET] #{entityName}: #{return_val}")
        return return_val
    end
    
    def _findEntity(entityName)
        if self.config == nil
            raise 'A configuration must be loaded if an "entityName" is provided'
        end
        entity = self.config.entity_by_name(entityName)
        if entity == nil
            raise "A configuration by the name of #{entityName} was not found"
        end
        return entity
    end
    
    def _buildUrl(verb, entityName: nil, url: nil)
        full_url = self.url
        
        if entityName != nil
            entity = _findEntity(entityName)
            
            entityUrl = entity.send(verb)
            entityUrl.sub! '@{id}', '#{id}'
            full_url = "#{self.url}/#{entityUrl}"
            
        elsif url != nil
            full_url = url
        end
        
        return full_url
    end
    
    def _stringReplaceValues(str, obj)
        obj.keys.each do |key|
            str.gsub! "@#{key}", obj[key].to_s
        end
        return str
    end
    
    # take any properties from the 'right' that doesn't exist in the left and add them
    def _getEntityPrimaryKey(entityName)
        entity = _findEntity(entityName)
        if(entity == nil)
            raise "Unable to find entity '#{entityName}"
        end
        
        keyProperty = entity.getPrimaryKey
        if keyProperty == nil
            raise "Property '#{entityName} does not contain a primary key."
        end
        
        return keyProperty
    end
    
    def _createDependencies(entity, postData, dependentData = nil)
        postData = JSON.parse(postData)
        if dependentData != nil
            dependentData = JSON.parse(dependentData)
        end
        foreignKeys = entity.getForeignKeys
        
        #sort the dependentProperties so they are last
        foreignKeys.sort! { |a,b| a.dependentProperty.to_i <=> b.dependentProperty.to_i }
        
        foreignKeys.each do |key|
            # first check if there is a dependent object so we don't create the item twice
            if dependentData != nil && dependentData.key?(key.propertyName)
                postData[key.propertyName] = dependentData[key.propertyName]
            elsif key.pseudoPost == true
                primaryKey = _findEntity(key.foreignKey).getPrimaryKey
                existingItem = _randomGet(entityName: key.foreignKey)
                postData[key.propertyName] = existingItem[primaryKey.propertyName]
            else
                primaryKey = _findEntity(key.foreignKey).getPrimaryKey
                newItem = JSON.parse(post(entityName: key.foreignKey, dependentData: key.dependentProperty != nil ? postData.to_json : nil, caller: self)[:body])
                postData[key.propertyName] = newItem[primaryKey.propertyName]
            end
        end
        return postData.to_json
    end
    
    def _addProperty(data, key, value)
        data = JSON.parse(data)
        data[key] = value
        return data.to_json
    end

    def _hasReplacementProperties(entity, verb)
        urlPattern = entity.send(verb)
        maxValue = [0, urlPattern.index('\\'), urlPattern.index('/')].compact.max
        return urlPattern[maxValue..-1].index('@') != nil
    end

    def _stageData(entity, data)
        data = JSON.parse(data)
        entity.schema.each do |prop|
            if prop.exclude == true
                data.delete(prop.propertyName)
            end
        end
        return data.to_json
    end
end
