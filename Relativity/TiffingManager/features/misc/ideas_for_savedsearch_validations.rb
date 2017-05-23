# array_of_rows = [
# 	['msg', true],
# 	['msg', false],
# 	['doc', 'true']
# ]

# array_of_rows = browser.table.tbody.trs.find

# hash_of_values = {}
# ​
# array_of_rows.each do |row|
# ​	
#   file_type = row.tds[4]
 
#   qc_status = row.tds[5]

#   if hash_of_values[file_type].nil?
#   	hash_of_values[file_type] = {
#   		"total_number" => 0,
#   		"total_qc" => 0 
#   	}
#   end
  
#   hash_of_values[file_type]["total_number"]++
#   if qc_status
#   	hash_of_values[file_type]["total_qc"]++
#   end
# end
# ​
# test_value_msg = (hash_of_values["msg"]["total_number"]/2).round 
# if(hash_of_values["msg"]["total_qc"] == test_value_msg)
# 	puts "success"
# end

# test_value_doc = (hash_of_values["doc"]["total_number"]/2).round 
# if(hash_of_values["doc"]["total_qc"] == test_value_doc)
# 	puts "success"
# end

# #input 50% of total = .msg

# Assert(PercentageOfFileTypes(".msg") == .50)

# def PercentageOfFileTypes(fileType)
#   totalCount = #tr.length
#   totalFileType = #tr > td:contains|endswith(fileType)
#   return totalCount / totalFileType
# end

# def CellContainsAllValues(col1Index, col1Value, col2Index, col2Value)
#   totalCount = 0
#   AllfileTypeRows = #tr > td:nth-child(col1Index):contains(col1Value)
#   loop(row in AllFileTypeRows)
#     if row[col2Index] == col2Value
#       totalCount += 1
#     end
#   end
#   return totalCount
# end