** Tests live in application repository or keep QA automation separated in a different organization??
- What is the organization of all the application repositories
	+ Application Ruby Libraries should be checked into the corresponding application repository.
	+ Regression, Smoke, Functional, Bug, User Story tests should also be checked into this same repository.
- Where would integration tests go that test multiple repository functionality
	+ When integration tests are needed they should be checked into the QA organization in an application umbrella repository.  Example would be prod add has processors, services, web, notifications, etc.  In the QA organization a "ProdApp" repository would be created where integration tests that span 2 or more of these projects would live.
- Core Technology Stack Pain Points & Proof Of Concept Items
	+ Validating cases with more complicated Angular apps can be supported
	+ Updating bundle packages with many changes (slow process)
	+ Versioning issues: Each developer needs to be more diligent in updating to proper versions of gems
	+ Ruby -> Watir (Selenium ID) -> RSpec	- (Can Selenium ID help with Angular and Dynamic elements, Windows Auth)
- Test Structure
	+ This remains to be a on-going discussion
	+ "Grooming/Design" session at the start of each sprint with dev/qa (optionally PM) to generate a rough test spec with stubbed out tests tagged accordingly.
	+ Each spec file should be related to any of the following higher-level relationships (functional area, user story, release)
	+ Every tests need to have the appropriate tags associated and this is crucial for custom test suite execution and code coverage analysis
- Reporting
	+ It is important to have metrics around reporting which is where the tagging will come in to place.
	+ Current implementation places an HTML file into the output of the test run directly.  We will need to hook this process into the Jenkins pipeline which will give us the benefit of having these metrics go into a main repository for viewing which is where other build process/applications place such data.
- Process Improvement/Retrospective - Probably the most important process is how do we improve our current workflow.
	+ At the end of each sprint a half hour retrospective with QA will be scheduled to through the following items
		- Pain points in the existing process and how to fix them
                - Overall improvement of the current workflow
                - Identify what is going right
                - Discussion about development engagement, such as... is it enough, too little or geting help in the wrong areas. 
	+ Important to note that if something isn't working, we need to identify it immediately and feel restrained that because it is a process it can't be changed.