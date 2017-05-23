
require 'byebug'
require 'watir'
require 'watir-webdriver'
require 'solid_assert'
require 'json'
require 'log4r'
require 'fileutils'

SolidAssert.enable_assertions

class FeatureTest
  attr_accessor :url, :baseUrl, :browser, :logger, :screen_capture, :browser_type
  
  def initialize(args={})
	self.baseUrl = args[:baseUrl]
	self.screen_capture = args[:screen_capture] != nil && args[:screen_capture] == true
	self.browser_type = args[:browser_type] != nil ? args[:browser_type] : :ie
	self.browser = args[:browser]
  end

  def load(args={})
	self.baseUrl = args[:baseUrl]
	self.screen_capture = args[:screen_capture] != nil && args[:screen_capture] == true
	self.browser_type = args[:browser_type] != nil ? args[:browser_type] : :ie
	self.browser = args[:browser]
	self.logger = HLLogger.new(:file_path => "test_run.log", :driver => self.browser.driver, :capture => self.screen_capture)
	self.LogMessage(:level => 'info', :action => 'Init')
	return self
  end
  
  def LogMessage(args={})
	# levels = 'info', 'warn', 'error', 'fatal'
	self.logger.Log(:url => "%s%s" % [baseUrl, self.url], :selector => args[:selector], :action => args[:action], :message => args[:message], :image_path => '')
  end
  
  def Init
	self.browser = Watir::Browser.new self.browser_type
	self.browser.goto "%s%s" % [self.baseUrl, self.url]
	self.logger = HLLogger.new(:file_path => "test_run.log", :driver => self.browser.driver, :capture => self.screen_capture)
	self.LogMessage(:level => 'info', :action => 'Init')
  end
  
  # Use this to get a watir element by CSS(need only css)
  def GetElement(selector)
	return JQueryElement.GetElement(self, selector)
  end
  
  # Use this to pass in an already existing watir element, which will give you the framework functionlity(need only watir)
  def SetElement(element)
	return JQueryElement.SetElement(self, element)
  end
  
  def RefreshPage
	self.browser.refresh
	sleep(2)
	self.LogMessage(:level => 'info', :action => 'RefreshPage')
  end
  
  def PressEnterKey
	self.browser.send_keys(:return)
	self.LogMessage(:level => 'info', :action => 'PressEnterKey')
  end
  
  def SetIFrame(name)
	framesLength = self.browser.execute_script("return frames.length") - 1
	for i in 0..framesLength
		if name == self.browser.execute_script("return frames[%d].name" % i)
			self.browser.driver.switch_to.frame(i)
			break
		end
	end
	return self
  end

  def RemoveIFrame
	self.browser.driver.switch_to.frame(0)
  end
  
  def Assert(condition, message, stopExecution = false)
	if condition == false
		self.LogMessage(:message => message, :level => 'error')
		
		if stopExecution
			assert condition, message
		end
	end
	
	return condition
  end
  
  def Read
    raise "Read function not implemented"
  end  
  
  def Insert
    raise "Insert function not implemented"
  end
  
  def Update
	raise "Update function not implemented"
  end
  
  def Delete
	raise "Delete function not implemented"
  end
  
  def TearDown
	self.LogMessage(:level => 'warn', :action => 'TearDown')
	self.browser.close
  end
  
  def Execute
    Init()
	Read()
	Insert()
	Update()
	Delete()
	TearDown()
  end
end  

class JQueryElement
	attr_accessor :browser, :feature, :selector, :element
	
	def initialize(args={})
		self.feature = args[:feature]
		self.browser = args[:browser]
		self.selector = args[:selector]
		self.element = args[:element]
	end
	
	def self.GetElement(feature, selector)
		raise "Brackets [] are not supported in selectors.  Use the SetElement method and pass a Watir element." if selector.include? '['
		
		element = JQueryElement.new(:browser => feature.browser, :feature => feature, :selector => selector, :element => feature.browser.execute_script("return $('%s')[0]" % selector))
		return element
	end
	
	def self.SetElement(feature, element)
		element = JQueryElement.new(:browser => feature.browser, :feature => feature, :element => element)
		return element
	end
		
	def Exists
		return self.browser.execute_script("return $(arguments[0]).length", self.element) > 0
	end

	def Label
		return self.browser.execute_script("return $(arguments[0]).text()", self.element) > 0
	end
	
	def Text(text = nil)
		if(text != nil)
			self.element.to_subtype.set text
			self.feature.LogMessage(:selector => self.selector, :action => 'SetText', :message => text)
		end
		return self.browser.execute_script("return $(arguments[0]).val()", self.element)
	end
	
	def Select(value = nil)
		if(value != nil)
			self.element.to_subtype.select_value(value)
			self.feature.LogMessage(:selector => self.selector, :action => 'Select')
		end
		return self.browser.execute_script("return $(arguments[0]).val()", self.element)
	end
	
	def Html
		return self.browser.execute_script("return $(arguments[0]).html()", self.element)
	end
	
	def Click
		#self.browser.execute_script("$(arguments[0]).click()", self.element)
		self.element.when_present.click
		sleep(1)
		self.feature.LogMessage(:selector => self.selector, :action => 'Click')
	end
end

class Watir::Table
	def GetRowsText
		return rows.collect{|row| row.to_subtype.text}
	end
end

class Array
	def filter(term, ignoreCase=false)
		return !ignoreCase ? self.find_all{|item| item.include? term} : self.find_all{|item| item.downcase.include? term.downcase}
	end
	
	def remove(term, ignoreCase=false)
		return !ignoreCase ? self.find_all{|item| !item.include? term} : self.find_all{|item| !item.downcase.include? term.downcase}
	end
end

class LogFormatter <  Log4r::Formatter
  def format(event)
    buff = "#{Log4r::LNAMES[event.level]} | "
	buff += Time.new.strftime("%Y-%m-%d %H:%M:%S") + " | "
	buff += ENV["COMPUTERNAME"] + " | "
	buff += event.data.join(" | ")
	buff += "\n"
  end
end

class HLLogger
	attr_accessor :file_path, :driver, :log, :capture
	
	def initialize(args={})
		self.file_path = args[:file_path]
		self.driver = args[:driver]
		self.capture = args[:capture]
		
		self.log = Log4r::Logger.new ''
		self.log.add Log4r::RollingFileOutputter.new( "", {:formatter => LogFormatter, :filename => self.file_path} )
		self.log.level = Log4r::INFO
	end
	
	def Log(args={})
		level = args[:level] == nil ? "info" : args[:level]
		if self.capture
			filename = DateTime.now.strftime('%Q')
			imagePath = "Images/%s.jpg" % filename
			FileUtils.mkdir_p 'Images'
			self.log.method(level).call [args[:url], args[:selector], args[:action], args[:message], imagePath]
			self.driver.save_screenshot imagePath
		else
			self.log.method(level).call [args[:url], args[:selector], args[:action], args[:message]]
		end
	end
end