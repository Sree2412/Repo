(Evaluate developers unit tests)
+ Functional tests with expected out
	- Which components are involved (UI, DB, etc.) which could be tested independently
+ Integration tests - running various previously passed test to try and change the output of the functional test
+ Negative tests - expected negative behavior
+ Tests variation - users/credentials/settings/etc.

Building a list of automation candidates:
- Determine what manual steps can be automated, justification of automating a test
	+ Scope of test (too large, too many outside factors, etc.)
	+ Time of test development vs. manual testing frequency
	+ Manual effort vs. automation development ease
	+ Business value of feature to have automation coverage at a higher percentage
- When should QA automation engagement start in relation to feature development
	+ Explore techniques around starting at the same time with Dev
	+ When is it not a good time to start when Dev starts and if so when to start engaging
- Also as a related topic be sure to visit [Test Development Strategy](Test-Development-Strategy)