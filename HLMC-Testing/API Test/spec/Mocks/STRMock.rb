module STRMock


  STROne = {:body=>"{\"$id\":\"1\",\"pkClientID\":6790,\"clientName\":\"Huron Consulting Group\",\"clientEliteNum\":\"90000\",\"clientEliteName\":\"Huron Consulting Group\",\"createdOn\":\"2011-07-03T02:57:37.71\",\"createdBy\":\"CONSILIO\\\\scurtis\",\"updatedOn\":\"2016-03-13T08:54:48.27\",\"updatedBy\":\"dbo\"}", :code=>200, :response=>"OK"}

   STRTwo = {:body=>"{\"$id\":\"1\",\"pkProjectID\":10,\"ProjectName\":\"Kipper\",\"ProjectCode\":\"H10211\",\"fkClientID\":7549,\"DomainProjectStatusID\":0,\"Requestor\":\"Sergio Kopelev\",\"RootPath\":null,\"ActiveDirectorySecurityGroup\":\"H10211_DRS\",\"DatabaseServer\":null,\"DatabaseName\":null,\"AdoConnectionString\":null,\"OleDbConnectionString\":null,\"OdbcConnectionString\":null,\"HasCertifiedContractTerms\":false,\"fkBillingDeadlineTypeID\":null,\"BillingDeadlineDay\":null,\"CreatedOn\":\"2011-07-14T21:38:11.037\",\"CreatedBy\":\"integrifytest\",\"UpdatedOn\":\"2016-03-13T08:55:22.857\",\"UpdatedBy\":\"dbo\",\"Timestamp\":\"AAAAADiOrOM=\",\"ProjectStatus\":0,\"RelativityETL\":1,\"ProjectSnapshot\":1,\"RDOUpdate\":0,\"DWLoad\":1,\"LoadOrder\":20,\"CodeUpdate\":0,\"HelixUrl\":null}", :code=>200, :response=>"OK"}


  STRThree = {:body=>"{\"$id\":\"1\",\"User\":\"samada\"}", :code=>200, :response=>"OK"}

  STRFour = {:body=>"{\"$id\":\"1\",\"pkUserID\":266,\"emailAddress\":\"mwan@consilio.com\",\"firstName\":\"Min \",\"lastName\":\"Wan\",\"loginID\":\"mwan\",\"createdOn\":\"2014-05-01T20:04:06.667\"}", :code=>200, :response=>"OK"}

  STRFive = {:body=>"{\"$id\":\"1\",\"next_page\":null,\"previous_page\":null,\"count\":0,\"users\":[{\"$id\":\"2\",\"created_at\":\"2015-10-26T21:26:47Z\",\"email\":\"kshrestha@huronconsultinggroup.com\",\"active\":true,\"moderator\":false,\"suspended\":false,\"verified\":true,\"last_login_at\":\"2016-03-02T22:06:31Z\",\"updated_at\":\"2016-03-02T22:07:42Z\",\"locale\":\"en-US\",\"name\":\"Kumar Shrestha\",\"organization_id\":null,\"role\":\"agent\",\"id\":2342812487,\"url\":\"https://huronlegal1445891818.zendesk.com/api/v2/users/2342812487.json\"}]}", :code=>200, :response=>"OK"}

  STRSix = {:body=>"{\"$id\":\"1\",\"next_page\":null,\"previous_page\":null,\"count\":0,\"users\":[{\"$id\":\"2\",\"created_at\":\"2015-10-26T21:26:47Z\",\"email\":\"kshrestha@huronconsultinggroup.com\",\"active\":true,\"moderator\":false,\"suspended\":false,\"verified\":true,\"last_login_at\":\"2016-03-02T22:06:31Z\",\"updated_at\":\"2016-03-02T22:07:42Z\",\"locale\":\"en-US\",\"name\":\"Kumar Shrestha\",\"organization_id\":null,\"role\":\"agent\",\"id\":2342812487,\"url\":\"https://huronlegal1445891818.zendesk.com/api/v2/users/2342812487.json\"}]}", :code=>200, :response=>"OK"}

  STRSeven = {:body=>"[]", :code=>200, :response=>"OK"}



end
