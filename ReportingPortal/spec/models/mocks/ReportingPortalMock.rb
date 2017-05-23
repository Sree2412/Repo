
module ReportingPortalMock

	# this is the project that exists in both qa and prod 101816
	ClientName = 'Scotia'

	ClientName_NoResults = 'H7'

	InvalidImage_Area = 480

	PageTitle = 'Reporting Portal'

	ProjectName = 'Nuix'

	# Probably don't need these anymore since using match functionality in script
	# Projects_Client = ["H52130 - TEST PROJECT LOGGING", "H52129 - TEST PROJECT - AUDIT LOG NAME", "H52128 - TEST PROJECT FOR ADMIN.PERSON", "H52126 - TESTNEWPROJECT - 04"]

	# Projects_Mine = ["H52258 - TESTING", "H52257 - TEST PROJECT (2)", "H52256 - TESTINGPROJECTCREATIONPAGESASO", "H52255 - YELLOWBEE", "H52254 - SASO TESTING345", "H52253 - SASOTESTING", "H52252 - FLAMINGO213", "H52251 - FLAMINGO2", "H52250 - S PROD TEST", "H52249 - PREMIGRATIONTEST", "H52248 - TEST123", "H52247 - TESTSRI2", "H52246 - TESTSRI1", "H52245 - TESTSRI", "H52244 - MANDEEPSTESTPROJECT", "H52243 - RRSTESTPROJECT01", "H52242 - 007TESTMANDEEP", "H52241 - NEW RRS TEST", "H52240 - TEST21", "H52239 - MANDEEPSINGHTEST007", "H52238 - TEST18", "H52237 - MANDEEPTEST007", "H52236 - TEST14", "H52235 - TEST12", "H52234 - TEST9", "H52233 - TEST6", "H52232 - TEST4", "H52231 - TEST3", "H52230 - TEST2", "H52229 - TEST1", "H52228 - S TESTING", "H52227 - TEST PROJECT EMAIL GENERATION", "H52226 - TEST EMAIL SENDING", "H52225 - TEST PROJECT 02", "H52224 - TEST PROJECT 01", "H52223 - RRSREVDEEP2", "H52222 - RRSREVDEEP1", "H52221 - RRSTESTPROJECTMANDEEP2", "H52220 - RRSTESTPROJECTMANDEEP1", "H52219 - NEWRRSTEST1", "H52218 - NEWRRSTEST", "H52217 - TESTPROMANDEEP2", "H52216 - TESTPROMANDEEP1", "H52215 - TESTPROMANDEEP", "H52214 - RRSREV1DEEP1", "H52213 - RRSREV1DEEP", "H52212 - TEST PROJECT CREATION", "H52211 - TEST PROJECT 21", "H52210 - TEST NEW PROJECT 20", "H52209 - TEST NEW PROJECT 19"]

	# Projects_NameFilter_Test = ["H12568 - ENRON - NUIX 6.2", "H11824 - ENRON - NUIX 5.2", "H10871 - ENRON - NUIX 4.2", "H10402 - NUIX PILOT", "H10286 - ALLIANT - NUIX FORENSIC PROCESSING", "H10274 - MATTER 3 FORENSICS - NUIX", "H10220 - MEDCAP - NUIX/RELATIVITY"]

	# Projects_NameFilter_Prod = ["H12610 - NUIX 6.2 TESTING UK", "H12568 - ENRON - NUIX 6.2", "H11824 - ENRON - NUIX 5.2", "H10871 - ENRON - NUIX 4.2", "H10402 - NUIX PILOT", "H10286 - ALLIANT - NUIX FORENSIC PROCESSING", "H10274 - MATTER 3 FORENSICS - NUIX", "H10220 - MEDCAP - NUIX/RELATIVITY"]

	Projects_None = []

	Report_Filters = ['All', 'Processing', 'Project Overview', 'Review', 'Analysis']

	Reports = ["Data Received Reconciliation Report", "Exceptions Report", "Processing Export Summary", "Project Snapshot", "QA Reviewer Productivity Report", "Review Snapshot", "Reviewer Report", "Search Hit Report with Custodian Summary", "Search Hit Report", "Suppression Report"]

	Reports_Analysis = ["Search Hit Report with Custodian Summary", "Search Hit Report"]

	Reports_Processing = ["Data Received Reconciliation Report", "Exceptions Report", "Processing Export Summary", "Suppression Report"]

	Reports_ProjectOverview = ["Project Snapshot"]

	Reports_Review = ["QA Reviewer Productivity Report", "Review Snapshot", "Reviewer Report"]

	TestProject = ['H11895', 'H10871', 'H12568', 'H11824']

	TestProjectNames = ['US Processing Only Testing', 'Enron - Nuix 4.2', 'Enron - Nuix 6.2', 'Enron - Nuix 5.2']

	TestProjectFullNames = ['H11895 - US Processing Only Testing', 'H10871 - Enron - Nuix 4.2', 'H12568 - Enron - Nuix 6.2', 'H11824 - Enron - Nuix 5.2']

	Next = 'next'

	Previous = 'before'

end

# Users

module ReportingPortalUsers

	User = 'adigby'

	DiscoverProjectManager = ''

	DPMProjects = []

	ReviewLeader = ''

	RLProjects = []

	ReviewFacilityLeader = ''

	RFLProjects = []

	ReviewServicesLeader = ''

	RSLProjects = []

	DataAnalyticsAssoc = ''

	DAAProjects = []

	DataOperationsAssoc = ''

	DOAProjects = []

end