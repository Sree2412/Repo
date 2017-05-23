package com.consilio.CAMethods;

import com.consilio.lib.Log;
import com.jayway.restassured.response.*;
import com.jayway.restassured.specification.*;
import static com.jayway.restassured.RestAssured.*;
import static org.hamcrest.Matchers.*;

import java.time.Duration;
import java.time.Instant;
import org.json.JSONObject;

import org.testng.Assert;
import org.testng.asserts.SoftAssert;

public class ReusableMethods extends BaseTest {	
				
	public void createStagingArea(String testCaseName, String areaId) throws Exception{
		Log.startTestCase(testCaseName);
		try{	
			stagingAreaStartTime = Instant.now();
			Instant startTimeForCreatingStaringArea = Instant.now();
			Log.info("Creating Staging area: " + "'" + areaId + "'");		
			if(testCaseName!= null && !testCaseName.isEmpty() && areaId!=null && !areaId.isEmpty()){			
				if(getProperty("env").equals("MP")){					
					int statusCode = when().get(areaId).then().and().extract().statusCode();					
					if(statusCode == 200){ 
						when().delete(areaId).then().assertThat().statusCode(200);
						when().put(areaId).then().assertThat().statusCode(201);		
						given().header("Content-Type", "application/json").when().get(areaId).then().assertThat().body("stagingAreaId", is(areaId));				
					}else if(statusCode == 404){
						when().put(areaId).then().assertThat().statusCode(201);
						given().header("Content-Type", "application/json").when().get(areaId).then().assertThat().body("stagingAreaId", is(areaId)); 
					}					
				}else if(getProperty("env").equals("CAAT")){ 				
					when().put(areaId).then().assertThat().statusCode(200);
					given().queryParam("mimeType", "application/json").when().get(areaId).then().assertThat().body("stagingAreaId", is(areaId)); 					
				}
			}else{
				Log.error("Either TestCase name or Area Id is empty");
				throw new Exception();
			}							
			Instant endTimeForCreatingStaringArea = Instant.now();
			Duration elapsedTimeForCreatingStagingArea = Duration.between(startTimeForCreatingStaringArea, endTimeForCreatingStaringArea);
			Log.info("Completed Creating Staging area " + "'" + areaId + "'");			
			Log.info("Total time taken for creating Staging area '" + areaId + "' in milli seconds is: " + elapsedTimeForCreatingStagingArea.toMillis());
			Log.info("Total time taken for creating Staging area '" + areaId + "' in minutes is: " + elapsedTimeForCreatingStagingArea.toMinutes());
		}catch(Exception e){
			Log.error(e.getLocalizedMessage());		
			throw e;
		}		
	}	

	public void createConnector(String areaId, String conType, String conName, String dataType, String dataSetId, Boolean isIncremental, String incQuery) throws Exception{
		try{							
				Log.info("Creating Connector");	
				Instant startTimeforCreatingConnector = Instant.now();
				if(areaId != null && !areaId.isEmpty() && conType != null && !conType.isEmpty() && conName != null && !conName.isEmpty() 
						&& dataType != null && !dataType.isEmpty() && dataSetId != null && !dataSetId.isEmpty()){

					String newConfig = buildConnectorConfig(conName, conType, dataType, dataSetId, isIncremental, incQuery);
					RequestSpecification reqSpec = getConnectorRequestSpecification(conType, newConfig);
					Response response = given().spec(reqSpec).when().put(areaId + "/ingest/-1");
					int conId  = response.jsonPath().get("id");
					int statuscode = response.getStatusCode();
					Assert.assertTrue(statuscode == 201); 				
					Instant endTimeForCreatingConnector = Instant.now();
					Duration elapsedTimeForCreatingConnector = Duration.between(startTimeforCreatingConnector, endTimeForCreatingConnector);
					Log.info("Completed Creating Connector: " + "'" + conId + "'");
					Log.info("Total time taken for creating Connector '" + conId + "' for the area '" + areaId + "' in milli seconds is: " + elapsedTimeForCreatingConnector.toMillis());
					Log.info("Total time taken for creating Connector '" + conId + "' for the area '" + areaId + "' in minutes is: " + elapsedTimeForCreatingConnector.toMinutes());
					setConnectorId(conId);
				}else{
					Log.error("Either of Area Id, Connector Type, Connector Name, Data Type, Dataset Id is empty");
					throw new Exception();
				}				 				
		}catch(Exception e){
			Log.error(e.getLocalizedMessage());
			throw e;
		}		
	}	
	
	public void ingestData(String areaId, String conName, String conType, String dataType, String dataSetId) throws Exception{
		int conId = getConnectorId(); 
		try{
				Log.info("Ingesting Data for Connector: " + "'" + conId + "'");
				Instant ingestionStartTime = Instant.now();
				if(areaId != null && !areaId.isEmpty() && conType != null && !conType.isEmpty() && conName != null && !conName.isEmpty() 
						&& dataType != null && !dataType.isEmpty() && dataSetId != null && !dataSetId.isEmpty()){

					when().post(areaId + "/ingest/" + conId + "?op=start").then().statusCode(200);
					
					String connectorStatus = null;
					int successCount = 0;
					connectorStatus = getConnectorStatus(areaId, conId);
					successCount = getConnectorSuccessCount(areaId, conId);
					while(connectorStatus.equalsIgnoreCase("RUNNING") || connectorStatus.equalsIgnoreCase("STARTING") || connectorStatus.equalsIgnoreCase("PENDING") ||
							successCount == 0){ 
						Thread.sleep(1000);
						connectorStatus = getConnectorStatus(areaId, conId);
						successCount = getConnectorSuccessCount(areaId, conId);
					}
					
					if(connectorStatus.equalsIgnoreCase("ERROR")){ 
						Log.error("Ingestion failed");
						throw new RuntimeException();
					}/*else if(){
						
					}*/
					
					setIngestedCount(successCount);
					
					ResponseSpecification respSpec = getIngestionResponseSpecification();
					given().queryParam("mimeType", "application/json").when().get(areaId + "/ingest/" + conId).then().spec(respSpec);
					Instant ingestionEndTime = Instant.now();
					Duration ingestionElapsedTime = Duration.between(ingestionStartTime, ingestionEndTime);
					Log.info("Completed Ingestion for the areaId '" + areaId + "'");
					Log.info("Total number of successfully ingested documents are: " + successCount);
					Log.info("Time taken for Ingestion for the areaId '" + areaId + "' in milli seconds is: " + ingestionElapsedTime.toMillis());
					Log.info("Time taken for Ingestion for the areaId '" + areaId + "' in minutes is: " + ingestionElapsedTime.toMinutes());
				}else{
					Log.error("Either of Area Id, Connector Type, Connector Name, Data Type, Dataset Id is empty");
					throw new Exception();
				}				
		}catch(Exception e){
			Log.error(e.getLocalizedMessage());
			throw e;
		}		
	}	
	
	public void createTask(String areaId) throws Exception{
		try{
			Instant taskStartTime = Instant.now();
			String taskID = getProperty("taskId");
			String taskConfig = getProperty("emailThreadingAndTextualNearDupTaskConfig");
				Log.info("Creating task: " + "'" + taskID + "'");				
				if(areaId != null && !areaId.isEmpty() && taskID != null && !taskID.isEmpty() && taskConfig != null && !taskConfig.isEmpty()){
					if(taskID.equalsIgnoreCase("EmailThreadingAndNearDupTask")){
						if(getProperty("env").equals("CAAT")){
							given().queryParam("mimeType","application/json").body(taskConfig).when().put(areaId + "/task/" + taskID).then().statusCode(202);
						}else if(getProperty("env").equals("MP")){
							given().header("Content-Type","application/json").body(taskConfig).when().put(areaId + "/task/" + taskID).then().statusCode(202);
						}
									
						Log.info("Verifying Task completion");					
						JSONObject json = null;
						int nCount = 0;
						json = getTaskStatus(areaId, taskID);
						while(json.isNull("dateCompleted")){
							Thread.sleep(1000);
							json = getTaskStatus(areaId, taskID);
							nCount = json.getInt("numProcessed");
						}					
						Log.info("Task is completed");
						
						given().queryParam("mimeType", "application/json").body(taskConfig).when().get(areaId + "/task/" + taskID).then()
							.body("error", is(equalTo(null)))
							.body("dateCompleted", is(not(nullValue())));
						
						setNumProcessed(nCount);
					}
					Instant taskEndtime = Instant.now();
					Duration taskElapsedTime = Duration.between(taskStartTime, taskEndtime);
					
					Log.info("Completed creating task: " + "'" + taskID + "'");
					Log.info("Total time taken for the task '" + taskID + "' in milli seconds is: " + taskElapsedTime.toMillis());
					Log.info("Total time taken for the task '" + taskID + "' in minutes is: " + taskElapsedTime.toMinutes());
				}else{
					Log.error("Either of Area Id, Task Id, Task Configuration is empty");
					throw new Exception();
				}				
		}catch(Exception e){
			Log.error(e.getLocalizedMessage());
			throw e;
		}		
	}	
	
	public void exportStagingArea(String areaId, String task, String exportableFileName) throws Exception{	
		try{
			String taskId = getProperty("taskId");
				Log.info("Exporting Staging area for Staging area Id: " + "'" + areaId + "'");
				Instant startTimeForExportingStagingArea = Instant.now();
				if(areaId != null && !areaId.isEmpty() && taskId != null && !taskId.isEmpty() && task != null && !task.isEmpty()){
					if (taskId.equalsIgnoreCase("EmailThreadingAndNearDupTask")){
						//String exportConfig = getProperty("exportConfig").replace("fileName", getProperty("exportableFileName"));
						
						String exportConfig = null;
						if(task.equalsIgnoreCase("EmailThreading")){
							//exportConfig = getProperty("exportConfigET").replace("fileName", getProperty("exportableFileNameET"));
							exportConfig = getProperty("exportConfigET").replace("fileName", exportableFileName);
						}else{
							exportConfig = getProperty("exportConfigND").replace("fileName", getProperty("exportableFileNameND"));
						}						
						
						Response exportResponse = given().contentType("application/json").body(exportConfig).when().post(areaId + "/export?op=startExport");
						exportResponse.then().statusCode(200);
						String exportID = exportResponse.body().asString();
						
						Log.info("Verifying Export completion");					
						JSONObject json = null;
						json = getExportStatus(areaId, exportID);
						while(json.isNull("dateCompleted")){
							Thread.sleep(1000);
							json = getExportStatus(areaId, exportID);
						}
						
						given().queryParam("mimeType", "application/json").body(exportConfig).when().get(areaId + "/export/" + exportID).then()
						.body("error", is(equalTo(null)))
						.body("dateCompleted", is(not(nullValue())));												
					}
					Instant endTimeForExportingStagingArea = Instant.now();
					Duration elapsedTimeForExportingStagingArea = Duration.between(startTimeForExportingStagingArea, endTimeForExportingStagingArea);
					Log.info("Completed export for Staging area Id: " + "'" + areaId + "'");
					Log.info("Total time taken for exporting Staging area '" + areaId + "' in milli seconds is: " + elapsedTimeForExportingStagingArea.toMillis());
					Log.info("Total time taken for exporting Staging area '" + areaId + "' in minutes is: " + elapsedTimeForExportingStagingArea.toMinutes());
				}else{
					Log.error("Either of Area Id, Task Id is empty");
					throw new Exception();
				}				
		}catch(Exception e){
			Log.error(e.getLocalizedMessage());
			throw e;
		}		
	}
	
	public void validateNearDupeResults(String areaId, String dataType, String destinationFileToCompare) throws Exception{	
		try{
				waitFor(1000);
				Log.info("Validating exported results for Staging area Id: " + "'" + areaId + "'");
				SoftAssert assertion = new SoftAssert();
				Instant startTimeForValidatingNearDupResults = Instant.now();
				String strSourceXMLFile = getSourceFilePathToValidateOnEnv(areaId) + getProperty("sourceFileNameToValidateND");
				String strDestXMLFile = getProperty("destinationPathToValidate") + destinationFileToCompare;		
				
				assertion.assertTrue(areExportedResultsMatchingByAttribute(strSourceXMLFile, strDestXMLFile, "caat-derived-textual-near-dup-group", dataType, true), 
						"Near Dupe Results are not grouped by attribute 'Near Dupe Group'");
				
				if(getProperty("enableSimilarityCheck").equalsIgnoreCase("true")){					
					assertion.assertTrue(checkForSimilarity(areaId, dataType, destinationFileToCompare), "Results are not similar");
				}					
				Instant endTimeForValidatingTextualNearDupResults = Instant.now();
				Duration elapsedTimeForValidatingTextualNearDupResults = Duration.between(startTimeForValidatingNearDupResults, endTimeForValidatingTextualNearDupResults);
				Log.info("Total time taken for validating Textual Near Dup results for the area '" + areaId + "' in milli seconds is: " + elapsedTimeForValidatingTextualNearDupResults.toMillis());
				Log.info("Total time taken for validating Textual Near Dup results for the area '" + areaId + "' in minutes is: " + elapsedTimeForValidatingTextualNearDupResults.toMinutes());
				//assertion.assertAll();				
				Log.info("Completed validating exported results for Staging area Id: " + "'" + areaId + "'");
		}catch(Exception e){
			Log.error(e.getLocalizedMessage());
			throw e;
		}
		Log.endTestCase(dataType);
	}
	
	public void validateEmailThreadResults(String areaId, String dataType, String destinationFileToCompare, Boolean isIncremental) throws Exception{	
		try{
				waitFor(1000);
				Log.info("Validating exported results for Staging area Id: " + "'" + areaId + "'");		
				assertion = new SoftAssert();
				Instant startTimeForValidatingEmailThreadingResults = Instant.now();
				
				String strSourceXMLFile;
				String strDestXMLFile;					
				
				if(isIncremental == true){
					/*strSourceXMLFile =  getSourceFilePathToValidateOnEnv(areaId) + "EmailThreadingResults1.xml";
					strDestXMLFile =  getSourceFilePathToValidateOnEnv(areaId) + "EmailThreadingResults4.xml";*/
					
					strSourceXMLFile = "\\\\10.213.1.108\\filedata\\emails_\\Emails20_20170518.xml";
					strDestXMLFile =  "\\\\10.213.1.108\\filedata\\emails_\\Emails20_20170518.xml";
				}else{
					strSourceXMLFile = getSourceFilePathToValidateOnEnv(areaId) + getProperty("sourceFileNameToValidateET");
					strDestXMLFile = getProperty("destinationPathToValidate") + destinationFileToCompare;					
				}											
								
				assertion.assertTrue(areExportedResultsMatchingByAttribute(strSourceXMLFile, strDestXMLFile, "caat-derived-email-family", dataType, true), "Email Results are not matching by attribute 'Email Family'");
				assertion.assertTrue(areExportedResultsMatchingByAttribute(strSourceXMLFile, strDestXMLFile, "caat-derived-duplicate-set-id", dataType, true), "Email Results are not matching by attribute 'Dupe Set Id'");
				//assertion.assertTrue(areExportedResultsMatchingByAttribute(strSourceXMLFile, strDestXMLFile, "caat-derived-duplicate-spare", dataType, true), "Email Results are not matching by attribute 'Dupe Spare'");
				assertion.assertTrue(areExportedResultsMatchingByAttribute(strSourceXMLFile, strDestXMLFile, "caat-derived-inclusive-email", dataType, true), "Email Results are not matching by attribute 'Inclusive Email'");
				//assertion.assertTrue(areExportedResultsMatchingByAttribute(strSourceXMLFile, strDestXMLFile, "caat-derived-inclusive-email-reason", dataType, true), "Email Results are not matching by attribute 'Inclusive Email Reason'");
				//assertion.assertTrue(areExportedResultsMatchingByAttribute(strSourceXMLFile, strDestXMLFile, "caat-derived-end-email", dataType, true), "Email Results are not matching by attribute 'End Email'");				
				
				//assertion.assertTrue(areExportedResultsMatchingByAttribute(strSourceXMLFile, strDestXMLFile, "caat-derived-conversation-index", dataType, true), "Email Results are not matching by attribute 'Email Family'");
				//assertion.assertTrue(areExportedResultsMatchingByAttribute(strSourceXMLFile, strDestXMLFile, "caat-derived-email-change-status", dataType, true), "Email Results are not matching by attribute 'End Email'");
				if(getProperty("enableSimilarityCheck").equalsIgnoreCase("true")){					
					assertion.assertTrue(checkForSimilarity(areaId, dataType, destinationFileToCompare), "Results are not similar");
				}								
				
				stagingAreaEndTime = Instant.now();
				Duration stargingAreaElapsedTime = Duration.between(stagingAreaStartTime, stagingAreaEndTime);
				Duration elapsedTimeForValidatingEmailThreadingResults = Duration.between(startTimeForValidatingEmailThreadingResults, stagingAreaEndTime);				
				Log.info("Total time taken for validating Email Threading results for the area '" + areaId + "' in milli seconds is: " + elapsedTimeForValidatingEmailThreadingResults.toMillis());
				Log.info("Total time taken for all the steps of Staging area '" + areaId + "' in milli seconds is: " + stargingAreaElapsedTime.toMillis());
				Log.info("Total time taken for all the steps of Staging area '" + areaId + "' in minutes is: " + stargingAreaElapsedTime.toMinutes());
				//assertion.assertAll();				
				Log.info("Completed validating exported results for Staging area Id: " + "'" + areaId + "'");
				
		}catch(Exception e){
			Log.error(e.getLocalizedMessage());
			throw e;
		}
		Log.endTestCase(dataType);
	}
	
	public void validateDocumentsProcessedOnIncremental(){
		assertion.assertTrue(getIngestedCount() == getNumProcessed());
		assertion.assertAll();
	}
			
}
