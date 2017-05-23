require 'logger'

class RestgenOutputter
    def write(value)
    end
end

class RestgenConsoleOutputter < RestgenOutputter
    def write(value)
        puts value
    end
end

class RestgenFileOutputter < RestgenOutputter
    attr_accessor :filename, :logger

    def initialize(filename)
        self.filename = filename
        self.logger = Logger.new(self.filename)

        self.logger.formatter = proc do |severity, datetime, progname, msg|
            "#{msg}\r\n"
        end
    end

    def write(value)
        self.logger.info (value)
    end
end