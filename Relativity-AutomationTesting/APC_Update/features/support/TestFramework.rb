
# require 'pry'
# require 'watir'
# require 'watir-webdriver'
# require 'solid_assert'
# require 'json'
# require 'log4r'
# require 'fileutils'

# SolidAssert.enable_assertions

# module TestFramework
#   def LogMessage(args={})
# 	logger = Logger.new(:file_path => "test_run.log", :driver => driver)
# 	logger.Log(:url => url, :selector => args[:element].xpath, :action => args[:action], :message => args[:message], :image_path => '')
#   end
  
#   def CreateBrowser
# 	$browser = Watir::Browser.new self.browser_type
# 	$browser.goto "%s%s" % [self.baseUrl, self.url]
#   end
  
#   def ByCss(selector)
# 	return $browser.execute_script("var values = $('%s'); return values.length > 1 ? values : values[0];" % selector)
#   end
  
#   def ByCssInFrame(frameId, selector)
#     values = nil
# 	$browser.driver.switch_to.frame frameId
# 	begin
# 	values = $browser.execute_script("var values = $('%s'); return values.length > 1 ? values : values[0];" % selector)
# 	rescue
# 	puts "Unable to retrieve frame %s contents"%frameId
# 	ensure
# 	driver.switch_to.default_content
# 	end
# 	return values
#   end
  
#   def ByChildCss(element, selector)
# 	return $browser.execute_script(("var values = $(arguments[0]).find('%s'); return values.length > 1 ? values : values[0];" % selector), element)
#   end
  
#   def RefreshPage
# 	refresh
# 	sleep(2)
# 	self.LogMessage(:level => 'info', :action => 'RefreshPage')
#   end
  
#   def PressEnterKey
# 	send_keys(:return)
# 	self.LogMessage(:level => 'info', :action => 'PressEnterKey')
#   end
  
#   def Assert(condition, message, stopExecution = true)
# 	if condition == false
# 		self.LogMessage(:message => message, :level => 'error')
		
# 		if stopExecution
# 			assert condition, message
# 		end
# 	end
	
# 	return condition
#   end
# end

# class Watir::Table
# 	def GetRowsText
# 		return rows.collect{|row| row.to_subtype.text}
# 	end
# end

# class Watir::Input
# 	def Text(text = nil)
# 		if(text != nil)
# 			self.to_subtype.set text
# 		end
# 		return self.to_subtype.text
# 	end
# end

# class Watir::TextArea
# 	def Text(text = nil)
# 		if(text != nil)
# 			self.to_subtype.set text
# 		end
# 		return self.to_subtype.text
# 	end
# end

# class Watir::Select
# 	def Select(value = nil)
# 		if(value != nil)
# 			self.to_subtype.select_value(value)
# 			$browser.LogMessage(:level => 'info', :action => 'Select', :element => self)
# 		end
# 		return $browser.execute_script("return $(arguments[0]).children('option:selected')[0]", self.to_subtype)
# 	end
	
# 	def SelectByText(text)
# 		$browser.ByChildCss(self, "option:contains(%s)"%text).click
# 		$browser.LogMessage(:level => 'info', :action => 'SelectByText', :element => self)
# 		return $browser.execute_script("return $(arguments[0]).children('option:selected')[0]", self.to_subtype)
# 	end
	
# 	def SelectByIndex(index)
# 		$browser.ByChildCss(self, "option:eq(%s)"%index).click
# 		$browser.LogMessage(:level => 'info', :action => 'SelectByIndex', :element => self)
# 		return $browser.execute_script("return $(arguments[0]).children('option:selected')[0]", self.to_subtype)
# 	end
	
# 	def SelectLast
# 		$browser.ByChildCss(self, "option:last").click
# 		$browser.LogMessage(:level => 'info', :action => 'SelectLast', :element => self)
# 		return $browser.execute_script("return $(arguments[0]).children('option:selected')[0]", self.to_subtype)
# 	end
	
# 	def SelectFirst
# 		$browser.ByChildCss(self, "option:first").click
# 		$browser.LogMessage(:level => 'info', :action => 'SelectFirst', :element => self)
# 		return $browser.execute_script("return $(arguments[0]).children('option:selected')[0]", self.to_subtype)
# 	end
# end

# module WrappedElement
#   def click
#     super
# 	$browser.LogMessage(:level => 'info', :action => 'Click', :element => self)
#   end
# end

# class Watir::Element
#   prepend WrappedElement
  
#   def xpath
# 	getXPath = "var getXPath = function calculateXPath( element ){var xpath = '';for ( ; element && element.nodeType == 1; element = element.parentNode ){var id = $(element.parentNode).children(element.tagName).index(element) + 1;id > 1 ? (id = '[' + id + ']') : (id = '');xpath = '/' + element.tagName.toLowerCase() + id + xpath;}return xpath;};"
# 	return $browser.execute_script(("%s return getXPath(arguments[0]);" % getXPath), self)
#   end
  
#   def DragDropTo(element)
# 	$browser.driver.action.drag_and_drop(self, element.wd).perform
#   end
# end

# class Array
# 	def filter(term, ignoreCase=false)
# 		return !ignoreCase ? self.find_all{|item| item.include? term} : self.find_all{|item| item.downcase.include? term.downcase}
# 	end
	
# 	def remove(term, ignoreCase=false)
# 		return !ignoreCase ? self.find_all{|item| !item.include? term} : self.find_all{|item| !item.downcase.include? term.downcase}
# 	end
# end

# class LogFormatter <  Log4r::Formatter
#   def format(event)
#     buff = "#{Log4r::LNAMES[event.level]} | "
# 	buff += Time.new.strftime("%Y-%m-%d %H:%M:%S") + " | "
# 	buff += ENV["COMPUTERNAME"] + " | "
# 	buff += event.data.join(" | ")
# 	buff += "\n"
#   end
# end

# class Logger
# 	attr_accessor :file_path, :driver, :log
	
# 	def initialize(args={})
# 		self.file_path = args[:file_path]
# 		self.driver = args[:driver]
		
# 		self.log = Log4r::Logger.new ''
# 		self.log.add Log4r::RollingFileOutputter.new( "", {:formatter => LogFormatter, :filename => self.file_path} )
# 		self.log.level = Log4r::INFO
# 	end
	
# 	def Log(args={})
# 		level = args[:level] == nil ? "info" : args[:level]
# 		if $screen_capture
# 			filename = DateTime.now.strftime('%Q')
# 			imagePath = "Images/%s.jpg" % filename
# 			FileUtils.mkdir_p 'Images'
# 			self.log.method(level).call [args[:url], args[:selector], args[:action], args[:message], imagePath]
# 			self.driver.save_screenshot imagePath
# 		else
# 			self.log.method(level).call [args[:url], args[:selector], args[:action], args[:message]]
# 		end
# 	end
# end

# class FullCoverageTest
#   def Init
#   end
  
#   def Read
#     raise "Read function not implemented"
#   end  
  
#   def Insert
#     raise "Insert function not implemented"
#   end
  
#   def Update
# 	raise "Update function not implemented"
#   end
  
#   def Delete
# 	raise "Delete function not implemented"
#   end
  
#   def TearDown
#   end
  
#   def Execute
#     Init()
# 	Read()
# 	Insert()
# 	Update()
# 	Delete()
# 	TearDown()
#   end
# end