require 'Nokogiri'
require 'rubyxl'

module FunctionLibrary
  def FunctionLibrary.extractJsonFromHTML(response)
    doc = Nokogiri::HTML(response)
    el = doc.css("div.data")[0]
    el.content
  end

  def FunctionLibrary.getDataFromExcel(filePath, sheetno, rowno, colno)
    workbook = RubyXL::Parser.parse(filePath)
    sheet = workbook[sheetno]
    celldata = sheet.sheet_data[rowno][colno].value
  end

end
