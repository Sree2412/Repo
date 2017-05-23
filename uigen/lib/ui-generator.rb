require 'rubygems'
require 'bundler/setup'
require 'interface'
require 'abstract'
require 'watir'
require 'securerandom'

class UIgen  
  attr_accessor :url, :browser, :logger, :config
    
  def initialize(url)
    self.url = url
    
    # include all ruby files
    Dir[File.dirname(__FILE__) + '/*.rb'].each {|file| require file }

    caller_locations.each do |caller|
      if caller.to_s.index(":in `new'") != nil
        path = caller.absolute_path
        path = path[0..path.rindex('/')-1]
        expression = path + '../../**/*.rb'
        Dir[expression].each {|file| puts file }
        break
      end
    end

    self.browser = Watir::Browser.new :chrome
    self.browser.goto self.url
  end

  def load_configuration(filename)
    self.config = UIgenConfiguration.new(filename)
  end

  def execute(action_name)
    if self.config == nil
      raise ArgumentError, 'Configuration must be loaded before an action can be executed.'
    end

    action = self.config.action_by_name(action_name)
    if action == nil
      raise ArgumentError, "Unable to find action '#{action_name}' in the configuration."
    end

    # dyanmically generate the runtime instance of the class
    target = Object.const_get(action.class)
    instance = target.new(self.browser)

    if action.dependency != nil
      retValue = self.execute(action.dependency)
      if instance.respond_to?(':' + action.dependency)
        instance.send(action.dependency + "=", retValue)
      end
    end
        
    if instance.respond_to?('before_state') && !instance.before_state
      raise ArgumentError, "Unable to continue '#{action_name}' before_state is not valid."
    end

    instance.action()

    if instance.respond_to?('after_state') && !instance.after_state
      raise ArgumentError, "Unable to continue '#{action_name}' after_state is not valid."
    end

    return instance
  end
end

class UiGenBase
  attr_accessor :browser

  def initialize(browser_instance)
    self.browser = browser_instance
    self.init
  end

  def init
  end

  def generateUniqueString(len)
      poolSize = 36
      return SecureRandom.random_number(poolSize**len).to_s(poolSize).rjust(len, "0")
  end
  
  def generateNumber(min, max)
      return rand(min..max)
  end
end

IAction = interface{
  required_methods :action
}

IBeforeState = interface{
  required_methods :before_state
}

IAfterState = interface{
  required_methods :after_state
}