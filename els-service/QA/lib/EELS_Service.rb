# creating a rest service class for eels service
class EELS_Service
  attr_accessor :rest, :base_url

  def initialize(base_url, config_file_location)
    if base_url == nil? || base_url.length == 0
      raise "You must provide a valid base url"
    end
    if config_file_location == nil? || config_file_location.length == 0
      raise "You must provide a valid file path for the config"
    end

    self.base_url = base_url # setting the value of a property of an instance of a class

    self.rest = Restgen.new(base_url)
    self.rest.load_configuration(config_file_location)
  end

  def set_auth(username, password)
    if username == nil? || username.length == 0
      raise 'You must provide a valid username'
    end
    if password == nil? || password.length == 0
      raise 'You must provide a valid password'
    end
    self.rest.set_auth(username, password)
  end

  def manual_post(slash_entityName, body)
    return self.rest.rest_svc(self.base_url + slash_entityName).post(body)
  end

  def set_log_filepath(fileName)
    if fileName == nil? || fileName.length == 0
      raise "You must provide a valid file path for the log"
    end
    self.rest.set_log_filepath(fileName)
  end
  
  def log_message(msg)
    self.rest.log_message(msg)
  end

  def get(entity_name)
    return self.rest.get(entityName: entity_name)
  end

  def post(entity_name)
    return self.rest.post(entityName: entity_name)
  end

  def patch(entity_name)
    return self.rest.patch(entityName: entity_name)
  end

  def put(entity_name)
    return self.rest.put(entityName: entity_name)
  end

  def delete(entity_name)
    return self.rest.delete(entityName: entity_name)
  end


  def call_by_verb(request_verb, entity_name)
    return self.rest.send(request, entityName: entity_name)
  end

  def get_parsed_values(request_call, propertyName)
    return JSON.parse(request_call[:body])[propertyName]
  end

end