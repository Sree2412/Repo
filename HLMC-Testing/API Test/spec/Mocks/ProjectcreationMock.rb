module ProjectcreationMock


  GetDomainServices1 =  "[{\"ServiceID\":1,\"ServiceName\":\"Analytic\"},{\"ServiceID\":2,\"ServiceName\":\"Collection\"},{\"ServiceID\":3,\"ServiceName\":\"Forensic\"},{\"ServiceID\":4,\"ServiceName\":\"Processing\"},{\"ServiceID\":5,\"ServiceName\":\"Hosting\"},{\"ServiceID\":6,\"ServiceName\":\"Review\"}]"

  GetDomainServices2 =  "[{\"ServiceID\":7,\"ServiceName\":\"Assessments, Strategies & Roadmaps Training\"},{\"ServiceID\":8,\"ServiceName\":\"Remediation/Defensible Disposition\"},{\"ServiceID\":9,\"ServiceName\":\"Retention Schedules and Legal Research\"},{\"ServiceID\":10,\"ServiceName\":\"Enterprise Content Management\"},{\"ServiceID\":11,\"ServiceName\":\"Privacy and Protection\"},{\"ServiceID\":12,\"ServiceName\":\"Change Management\"},{\"ServiceID\":13,\"ServiceName\":\"Discovery Readiness\"},{\"ServiceID\":14,\"ServiceName\":\"IG Program Development\"}]"

  RentionSchedules =  "[{\"Value\":8,\"Text\":\"Huron Consulting Group\"},{\"Value\":1,\"Text\":\"Industry Standard Schedule\"},{\"Value\":2,\"Text\":\"Information Requirements Clearinghouse\"},{\"Value\":3,\"Text\":\"Iron Mountain\"},{\"Value\":4,\"Text\":\"Jordan Lawrence\"},{\"Value\":5,\"Text\":\"Law Firm (Unknown)\"},{\"Value\":7,\"Text\":\"Other\"},{\"Value\":6,\"Text\":\"Zasio/Versatile\"}]"

  DomainSensitivities = "[{\"Value\":4,\"Text\":\"Contract-Based (Contractual)\"},{\"Value\":2,\"Text\":\"European Union Personal Data (EUPD)\"},{\"Value\":1,\"Text\":\"US Export Controlled Information (ITAR)\"},{\"Value\":3,\"Text\":\"US Protected Health Information (PHI)\"}]"

  SearchClients = "[{\"ClientName\":\"test client\",\"ClientID\":8992},{\"ClientName\":\"TESTA HURWITZ & THIBEAULT LLP\",\"ClientID\":7346},{\"ClientName\":\"Diagnostic Testing Group Inc.\",\"ClientID\":4958},{\"ClientName\":\"ST Assembly Test Services Ltd\",\"ClientID\":5205}]"

  SearchEngagements =  "{\"TotalMatches\":3,\"Engagements\":[{\"EngagementName\":\"HR - Approved Relocation -  LOCS (UK)\",\"EngagementNumber\":\"90000-983\",\"BillingID\":1419},{\"EngagementName\":\"HR - Approved Relocation - Document Analysis\",\"EngagementNumber\":\"90000-688\",\"BillingID\":1398},{\"EngagementName\":\"HR - Approved Relocation - LOCS\",\"EngagementNumber\":\"90000-317\",\"BillingID\":3413}]}"

  SearchProjectDetails = "{\"ProjectName\":\"Oracle\",\"ProjectID\":5,\"ProjectCode\":\"H10204\",\"ClientID\":7921,\"ClientName\":\"Hewlett-Packard Company\",\"ProjectStatus\":\"Active\",\"Engagements\":[{\"EngagementName\":\"HP-Oracle (Pythia Processing)\",\"EngagementNumber\":\"02304-015\"},{\"EngagementName\":\"HP v Oracle II- Pythia (P&H) H10204\",\"EngagementNumber\":\"02304-046\"},{\"EngagementName\":\"PMO - HP v Oracle II- Pythia (PMO) H10204\",\"EngagementNumber\":\"02304-047\"}],\"Sensitivities\":[],\"HasExistingRRS\":false}"

  SearchProject = "{\"ProjectExists\":true}"

# Add Projectid,Projectcode by incrementing it by 1 to match the data
  ProjectCreationInsertData = "{\"ProjectName\":\"TestSri11\",\"DomainProjectStatusID\":0,\"DomainServiceLineID\":1,\"ClientID\":8992,\"Requester\":\"samada\",\"HasExistingRRS\":\"false\"}"
  ProjectCreatedData = {:body=>"{\"ProjectName\":\"TestSri11\",\"ProjectID\":10189,\"ProjectCode\":\"H13216\",\"ClientID\":8992,\"ClientName\":\"test client\",\"ProjectStatus\":\"Created\",\"Engagements\":[],\"Sensitivities\":[],\"HasExistingRRS\":false}", :code=>200, :response=>"OK"}
end
