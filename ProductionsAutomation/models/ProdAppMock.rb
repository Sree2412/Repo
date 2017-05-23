module ProdAppUrl
	QA 	= "http://mlvtwrpn01.consilio.com:8080/ProductionsWeb"
	UAT	= "http://mtpctscid514.consilio.com/ProductionsWeb"
end

module ProfileMock
	H11895_Mock = JSON.parse ('{
		"ProfileName": "H11895",
		"Source": "\\\\\\\\hlnas08\\\\mphldataopsfs01\\\\Hosting\\\\ProdApp\\\\H11895\\\\prod\\\\Productions\\\\_Prod_Staging_1\\\\BCMK02_export.dat",
		"Destination": "\\\\\\\\hlnas08\\\\mphldataopsfs01\\\\Hosting\\\\Jeff Brick\\\\UATTesting\\\\H11895\\\\New_ProdApp",
		"TextColumn": "Extracted Text",
		"NativeColumn": "FILE_PATH"				
	}')
	
	H11344_10R_Mock = JSON.parse ('{
		"ProfileName": "H11344_10R",
		"Source": "\\\\\\\\hlnas08\\\\mphldataopsfs01\\\\Hosting\\\\ProdApp\\\\H11344\\\\VOL002_10R.dat",
		"Destination": "\\\\\\\\hlnas08\\\\mphldataopsfs01\\\\Hosting\\\\ProdApp\\\\H11344_10R",
		"TextColumn": "Extracted Text",
		"NativeColumn": "FILE_PATH"				
	}')

	H11344_10R_Fields = JSON.parse ('{
		"Field_1": 		"ProdBeg",
		"O_Field_1": 	"Production Begin",
		"Field_2": 		"ProdEnd",
		"O_Field_2":	"Production End",
		"Field_3": 		"Create DateTime",
		"O_Field_3": 	""				
	}') 
	Output = JSON.parse ('{ "H11344_10R": "\\\\\\\\hlnas08\\\\mphldataopsfs01\\\\Hosting\\\\ProdApp\\\\H11344_10R_Smoke\\\\Output.dat" }')
	
	H11344_Mock = JSON.parse ('{
		"ProfileName": "H11344",
		"Source": "\\\\\\\\hlnas08\\\\mphldataopsfs01\\\\Hosting\\\\ProdApp\\\\H11344\\\\VOL002_export.dat",
		"Destination": "\\\\\\\\hlnas08\\\\mphldataopsfs01\\\\Hosting\\\\Jeff Brick\\\\UATTesting\\\\H11344\\\\New_ProdApp\\\\H11344_Transformed.dat",
		"TextColumn": "Extracted Text",
		"NativeColumn": "Native Path"				
	}') 
end

# "": "";