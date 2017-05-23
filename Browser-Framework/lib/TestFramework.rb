
require 'watir'
require 'solid_assert'
require 'json'
require 'log4r'
require 'fileutils'

SolidAssert.enable_assertions

module Consilio
module TestFramework
  def LogMessage(args={})
	logger = Consilio::Logger.new(:file_path => "test_run.log", :driver => driver)
	logger.Log(:level => args[:level], :url => url, :selector => args[:element].xpath, :action => args[:action], :message => args[:message], :image_path => '')
  end
  
  def CreateBrowser
	$browser = Watir::Browser.new self.browser_type
	$browser.goto "%s%s" % [self.baseUrl, self.url]
  end
  
  def ElementByCss(selector, timeout = 30)
    elements = self.ElementsByCss(selector, timeout)
    return elements.length > 0 ? elements[0] : $browser.element(:css => selector)
  end
  
  def ElementsByCss(selector, timeout = 30)
    message = "waiting for #{selector} to become present"
    Watir::Wait.until(timeout, message) { $browser.execute_script("return $('%s').length" % selector) > 0 }
    return $browser.execute_script("return $('%s')" % selector)
  end
  
  def ElementByChildCss(element, selector, timeout = 30)
    elements = self.ElementsByChildCss(element, selector, timeout)
    return elements.length > 0 ? elements[0] : $browser.element(:css => selector)
  end
  
  def ElementsByChildCss(element, selector, timeout = 30)
    message = "waiting for #{selector} to become present"
    Watir::Wait.until(timeout, message) { $browser.execute_script(("return $(arguments[0]).find('%s').length" % selector), element) > 0 }
    return $browser.execute_script(("return $(arguments[0]).find('%s')" % selector), element)
  end
  
  def RefreshPage
	refresh
	sleep(2)
	self.LogMessage(:level => 'info', :action => 'RefreshPage')
  end
  
  def PressEnterKey
	send_keys(:return)
	self.LogMessage(:level => 'info', :action => 'PressEnterKey')
  end
  
  def Assert(condition, message, stopExecution = true)
	if condition == false
		self.LogMessage(:message => message, :level => 'error')
		
		if stopExecution
			assert condition, message
		end
	end
	
	return condition
  end
  
  class FrameScope
  	def initialize(frameId)
  		ObjectSpace.define_finalizer(self, self.class.method(:finalize).to_proc)
  		$browser.driver.switch_to.frame frameId
  	end
  	def FrameScope.finalize
  		$browser.driver.switch_to.default_content
  	end
  end
end

class Watir::Table
	def GetRowsText
		return rows.collect{|row| row.to_subtype.text}
	end
end

class Watir::Input
	def Text(text = nil)
		if(text != nil)
			self.to_subtype.set text
		end
		return self.to_subtype.text
	end
end

class Watir::TextArea
	def Text(text = nil)
		if(text != nil)
			self.to_subtype.set text
		end
		return self.to_subtype.text
	end
end

class Watir::Select
	def Select(value = nil)
		if(value != nil)
			self.to_subtype.select_value(value)
			$browser.LogMessage(:level => 'info', :action => 'Select', :element => self)
		end
		return $browser.execute_script("return $(arguments[0]).children('option:selected')[0]", self.to_subtype)
	end
	
	def SelectByText(text)
		$browser.ByChildCss(self, "option:contains(%s)"%text).click
		$browser.LogMessage(:level => 'info', :action => 'SelectByText', :element => self)
		return $browser.execute_script("return $(arguments[0]).children('option:selected')[0]", self.to_subtype)
	end
	
	def SelectByIndex(index)
		$browser.ByChildCss(self, "option:eq(%s)"%index).click
		$browser.LogMessage(:level => 'info', :action => 'SelectByIndex', :element => self)
		return $browser.execute_script("return $(arguments[0]).children('option:selected')[0]", self.to_subtype)
	end
	
	def SelectLast
		$browser.ByChildCss(self, "option:last").click
		$browser.LogMessage(:level => 'info', :action => 'SelectLast', :element => self)
		return $browser.execute_script("return $(arguments[0]).children('option:selected')[0]", self.to_subtype)
	end
	
	def SelectFirst
		$browser.ByChildCss(self, "option:first").click
		$browser.LogMessage(:level => 'info', :action => 'SelectFirst', :element => self)
		return $browser.execute_script("return $(arguments[0]).children('option:selected')[0]", self.to_subtype)
	end
end

class Watir::Element
  alias_method :old_click, :click
  alias_method :old_double_click, :double_click
  alias_method :old_right_click, :right_click
  alias_method :old_hover, :hover
  alias_method :old_drag_and_drop_on, :drag_and_drop_on
  alias_method :old_drag_and_drop_by, :drag_and_drop_by
  alias_method :old_send_keys, :send_keys
  alias_method :old_focus, :focus
  
  def click
    $browser.LogMessage(:level => 'info', :action => 'click', :element => self)
    old_click
  end
  
  def double_click
    $browser.LogMessage(:level => 'info', :action => 'double_click', :element => self)
    old_double_click
  end
  
  def right_click
    $browser.LogMessage(:level => 'info', :action => 'right_click', :element => self)
    old_right_click
  end
  
  def hover
    $browser.LogMessage(:level => 'info', :action => 'hover', :element => self)
    old_hover
  end
  
  def drag_and_drop_on(other)
    $browser.LogMessage(:level => 'info', :action => 'drag_and_drop_on', :element => self)
    old_drag_and_drop_on(other)
  end
  
  def drag_and_drop_by(right_by, down_by)
    $browser.LogMessage(:level => 'info', :action => 'drag_and_drop_by', :element => self)
    old_drag_and_drop_by(right_by, down_by)
  end
  
  def send_keys(*args)
    $browser.LogMessage(:level => 'info', :action => 'send_keys', :element => self)
    send_keys(*args)
  end
  
  def focus
    $browser.LogMessage(:level => 'info', :action => 'focus', :element => self)
    old_focus
  end
  
  def xpath
	#getXPath = "var getXPath = function calculateXPath( element ){var xpath = '';for ( ; element && element.nodeType == 1; element = element.parentNode ){var id = $(element.parentNode).children(element.tagName).index(element) + 1;id > 1 ? (id = '[' + id + ']') : (id = '');xpath = '/' + element.tagName.toLowerCase() + id + xpath;}return xpath;};"
	#return $browser.execute_script(("%s return getXPath(arguments[0]);" % getXPath), self)
	return "Provide method for returning css, not xpath"
  end
  
  def wait_until_present(timeout = nil)
    super(timeout)
    return self
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

class Logger
	attr_accessor :file_path, :driver, :log
	
	def initialize(args={})
		self.file_path = args[:file_path]
		self.driver = args[:driver]
		
		self.log = Log4r::Logger.new ''
		self.log.add Log4r::RollingFileOutputter.new( "", {:formatter => LogFormatter, :filename => self.file_path} )
		self.log.level = Log4r::INFO
	end
	
	def Log(args={})
		level = args[:level] == nil ? "info" : args[:level]
		if $screen_capture
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

class FullCoverageTest
  def Init
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

end