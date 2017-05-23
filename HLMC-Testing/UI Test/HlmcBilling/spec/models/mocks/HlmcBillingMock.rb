module HlmcBillingUrl
	Local = "https://qa-hlmc.huronconsultinggroup.com/Finance/ProjectBilling?projectId=1951"
	Dev = "https://dev-hlmc.huronconsultinggroup.com/Finance/ProjectBilling?projectId=1951"
	QA = "https://qa-hlmc.huronconsultinggroup.com/Finance/ProjectBilling?projectId=1951"
	UAT = "https://uat-hlmc.huronconsultinggroup.com/Finance/ProjectBilling?projectId=1951"
	Staging = "https://staging-hlmc.huronconsultinggroup.com/Finance/ProjectBilling?projectId=1951"
	Prod = "https://hlmc.huronconsultinggroup.com/Finance/ProjectBilling?projectId=1951"
end

module HlmcBillingMock
	AddBillingMock = JSON.parse('{
		"EngagementNumber": "1062",
		"BillingDate": "04/2016",
		"Service": "-1",
		"UnitType": "USD",
		"UnitPrice": "1",
		"UnitNumber": "1",
		"Note": "automation testing note"
	}')

	VerifyBillingMock = JSON.parse('{
		"EngagementNumber": "02410-017",
		"BillingDate": "2016-04",
		"Service": "Other",
		"Location": "",
		"UnitType": "USD",
		"ExtendedPrice": "$1.00",
		"UnitPrice": "1",
		"UnitNumber": "$1.00",
		"Note": "automation testing note"
	}')

	EditBillingMock = JSON.parse('{
	"UnitPrice": "2",
	"UnitNumber": "2"
	}')

	VerifyEditBillingMock =JSON.parse('{
		"EngagementNumber": "02410-017",
		"BillingDate": "2016-04",
		"Service": "Other",
		"Location": "",
		"UnitType": "USD",
		"ExtendedPrice": "$4.00",
		"UnitPrice": "2",
		"UnitNumber": "$2.00",
		"Note": "automation testing note"
	}')


end
