
require_relative './RestgenOutputter'

class RestgenLogger
    attr_accessor :outputters

    def initialize
        self.outputters = []
    end

    def log(value)
        return if self.outputters.length == 0

        self.outputters.each do |outputter|
            outputter.write(value)
        end
    end
end