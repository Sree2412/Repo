
module RelativityUrl
	Local = "https://relativity92test.huronconsultinggroup.com/Relativity"
	Test = "https://mlvtwrew31.huronconsultinggroup.com/Relativity"
	Prod = "https://relativity.huronconsultinggroup.com/Relativity"
	Automation = "https://mtpctscid643.consilio.com/Relativity/"
	Automation_forms = "https://mtpctscid694.consilio.com/Relativity"
end

# module RelativityWorkspaceName
# 	SearchName = JSON.parse('{
# 		"WorkspaceName": "H12568 - HCG - Enron - Nuix 6.2",
# 		"AgentName" = ""Custodian Update Agent (1)"
# 	}')
# end

module RelativityWorkspaceItems
	WorkspaceName = "H12568 - HCG - Enron - Nuix 6.2"
	AgentName = "Custodian Update Agent (1)"
	WorkspaceNameSmoke = "Smoke Workspace"
	WorkspaceAdmin = 'Workspace Admin'
end

module DedupeHistoryRunsColumns
	Status = 3
	SavedSearchUsed = 5
	FieldUpdated = 6
	DeduplicationType =  7
	TotalDocuments = 8
	UniqueDocuments = 9
	NonUniqueDocuments = 10
end

module DedupeInputs
	SuccessfulRun = "Success"
	SavedSearchName = 'H12568 - HCG - Enron - Nuix 6.2 \ Dedupe_Test1'
	FieldName = 'BD EMT IsMessage'
	DeDuplicationTypeName = 'Document'
end

module ApplicationNames
	ApcUpdate = 'All Processed Custodian Update'
	Dedupe = 'Dedupe Saved Search'
	Documents ='Documents'
	IntakeInformation = 'Intake Information'
	WorkspaceAdmin = 'Workspace Admin'
end

module AnalyticsIndexField
	Name = 'Smoke Analytics'
	Status ='Yes'
end

module STR
	Name ='Smoke STR'
	Status ='Completed'
end

module AddAnalyticsServer
	Name ='Smoke Analytics Server'
	URL ='http://MTPCTSCID690.consilio.com:8080/nexus/services/'
	RestAPIPort ='8443'
	RestUsername ='SLT_REL2'
	RestPass ='P@ssword01'
	Status ='Active'
end

module GroupAccessNames
	Agents = "Server & Agent Management"
	Workspaces = "Workspaces"
	User_GroupMgmt = "User and Group Management"
end


module CreateSmokeItems
	Client = "Smoke Client"
	Matter = "Smoke Matter"
	UserFirstName = "Smoke"
	UserLastName =	"User"
	FullName = UserLastName+", "+UserFirstName
	Email = "Smokeuser@kcura.com"
	Password = "Password2!"
	GroupName = "Smoke Group"
end

module WorkspaceElements
	FieldName = "Smoke Designation"
	FieldType = "Single Choice"
	ChoiceName1 = "Smoke Responsive"
	ChoiceName2 = "Smoke Non-Responsive"
	LayoutName = "Smoke Layout"
	ViewName = "Smoke Responsive Documents"
	Operator = "any of these"
	FolderName = "HernandezJuan"
end

module CodingResponsive
	DocumentControlNumber = "JHERNANDE_0000568"
	ReportName = "Smoke Summary Report"
end

module ParentDocIDField
	ParentIDName = "Parent Document ID"
	ParentFieldType = "Fixed-Length Text"
end

module WorkspaceAdminTabs
	WorkspaceDetails = "Workspace Details"
	SearchIndexes = "Search Indexes"
	ObjectType = "Object Type"
	Fields = "Fields"
	Choices = "Choices"
	Layouts = "Layouts"
	Views = "Views"
	Tabs = "Tabs"
	RelativityApps = "Relativity Applications"
	CustomPages = "Custom Pages"
	History = "History"
	UserStatus = "User Status"
end

module SearchField
	ControlNumber = "ControlNumber"
	Name = "DisplayName"
	DocumentNumber = "TRANS_00001"
end

module TranscriptAddHeaderFooter
	HeaderText = "Document Header"
  FooterText = "Documant Footer"
end

module WordIndex
	Search_Word1 = "PETER"
	Search_Word2 = "Declaration"
end
