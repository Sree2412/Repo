require 'cmess/guess_encoding'
require 'cmess/cli'

include CMess::CLI

class Concordance

    attr_accessor :filepath, :line_ending, :delimeter, :bom
    
    def initialize(filepath)
        self.filepath = filepath
        self.bom = "\uFEFF"
        self.line_ending = "\u00FE"
        self.delimeter = "\u00FE\u0014\u00FE"
    end

    def Headers
        line = File.open(self.filepath, "r:" + self.Encoding?, &:readline)
        if line[0] == self.bom
            line = line[1..-1]
        end
        line = line[1..-3] # remove the first delimeter and the ending delimeter + newline
        return line.split(self.delimeter)
    end
    
    def DocumentCount
        return self.LineCount - 1
    end
    
    def LineCount
        return File.foreach(self.filepath).inject(0) {|c, line| c+1}
    end

    def Encoding?
        return CMess::GuessEncoding::Automatic.guess(File.open(self.filepath, &:readline))
    end
    
    def ColumnValues(column_name, exclude_empty_strings = false)
        values = []
        header_index = self.Headers.index(column_name)
        if header_index < 0
            return values;
        end
        File.foreach(self.filepath, :encoding => self.Encoding?).with_index do |line, index|
            if index == 0
                next
            end
                        
            line = line[1..-3] # remove the first delimeter and the ending delimeter + newline
            value = line.split(self.delimeter)[header_index]
            
            if exclude_empty_strings && value.length == 0
                next
            end
            
            values.push(value)
        end
        return values;
    end
    
    def CompareString?(str)        
        strLines = str.split('\n')
                
        File.foreach(self.filepath, :encoding => self.Encoding?).with_index do |line, index| 
            if index == 0 # remove all byte-order-marks
                if line[0] == self.bom
                    line = line[1..-1]
                end
                if strLines[0] == self.bom
                    strLines[0] = strLines[0][1..-1]
                end
            end
            
            if line.strip != strLines[index].strip
                return false
            end
        end
        
        return true;
    end
    
    def CompareFile?(filename)
        src = File.open(self.filepath, "r:" + self.Encoding?)
        cmp = File.open(filename, "r:" + self.Encoding?)
        
        srcLine = src.readline
        cmpLine = cmp.readline
        while srcLine != nil || cmpLine != nil
            if srcLine != cmpLine
                return false
            end
            
            if srcLine.strip != cmpLine.strip
                return false
            end
            
            begin
                srcLine = src.readline
            rescue EOFError => e
                srcLine = nil
            end
            
            begin
                cmpLine = cmp.readline
            rescue EOFError => e
                cmpLine = nil
            end
        end
        
        return true
    end
end
