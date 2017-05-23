module CTMock
	VerifyBillingMock = JSON.parse('{
		"EngagementNumber": "02410-017",
		"BillingDate": 	"2015-09",
		"Service": 		"Other",
		"Location": 	"",
		"UnitType": 	"USD",
		"ExtendedPrice": "$1.00",
		"UnitPrice": "1",
		"UnitNumber": "$1.00",
		"Note": "automation testing note"
	}')

	AddContractTermsMock = JSON.parse('{
		"Category": "Data Analytics",
		"Name": 		"Parameter Recommendation Report - Hour",
		"Price": 		"111",
		"Location": "Chicago"
	}')

	CompareCTMock = JSON.parse('{		
		"Name": 		"Parameter Recommendation Report",		
		"Location": "Chicago",
		"Price": 		"111.00"
	}')

	# This object is to Update the existing Contract Term	
	UpdateContractTermsMock = JSON.parse('{
		"Category": "Data Analytics",
		"Name": 		"Data Analytics Specialist - Hour",
		"Price": 		"222",
		"Location":	"Houston"
	}')

	# This object is to compare the updated contract term
	CompareUpdatedCTMock = JSON.parse('{		
		"Name": 		"Data Analytics Specialist",		
		"Location": "Houston",
		"Price": 		"222.00"
	}')	
end


