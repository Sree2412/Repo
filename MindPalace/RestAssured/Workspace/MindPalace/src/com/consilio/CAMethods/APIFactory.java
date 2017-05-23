package com.consilio.CAMethods;

import static com.jayway.restassured.RestAssured.basePath;
import static com.jayway.restassured.RestAssured.baseURI;
import static com.jayway.restassured.RestAssured.given;
import static com.jayway.restassured.RestAssured.port;
import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.not;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.TimeUnit;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.testng.asserts.Assertion;
import org.testng.asserts.SoftAssert;
import com.jayway.restassured.builder.RequestSpecBuilder;
import com.jayway.restassured.builder.ResponseSpecBuilder;
import com.jayway.restassured.response.ValidatableResponse;
import com.jayway.restassured.specification.RequestSpecification;
import com.jayway.restassured.specification.ResponseSpecification;
import com.consilio.CAMethods.EnumFactory.buildStatus;
import com.consilio.CAMethods.EnumFactory.ingestionStatus;
import com.consilio.lib.Log;


	public class APIFactory{ 
		protected String taskTime;
		private String env;
		private String paramKey;
		private SoftAssert sa = new SoftAssert();
		private Assertion ha = new Assertion();
		public String connectorID;
		public FunctionFactory function = new FunctionFactory();
		protected long startTime;
		protected long endTime;
		
		public void setupEnv() throws IOException
		{	
			Log.info("Environment setup started.");
			env = function.getProperty("env");
			
			if(env.equals("MP"))
			{
			baseURI = function.getProperty("baseURI_MP");
			port = Integer.parseInt(function.getProperty("port_MP"));
			basePath="/index/";
			paramKey = "Content-Type";
			}
			else if(env.equals("CAAT"))
			{
				baseURI = function.getProperty("baseURI_CAAT");
				port = Integer.parseInt(function.getProperty("port_CAAT"));
				basePath="/nexus/r1/index/";
				paramKey = "mimeType";
			}
			Log.info("Environment setup completed successfully."+Thread.currentThread().getName());
		}
		
		public void environmentSetup(String indexAreaID,String createIndex, String DBName_MP,String ConnectorName, String testCaseID) throws JSONException, InterruptedException
		{
			String connectorID;
			buildStatus buildCompleted = buildStatus.none;
			boolean indexAreaExist = false;
			
				Log.info("Need to create a index area \""+indexAreaID+"\"");
				indexAreaExist = validateIndexArea(indexAreaID);
				
				if(indexAreaExist == true && createIndex.equals("yes"))
				{
					Log.info("Index area requested to create is already exists.");
					buildCompleted = vatidateBuild(indexAreaID);
				
					if(buildCompleted == buildStatus.buildCompleted || buildCompleted == buildStatus.none)
					{
						deleteIndexArea(indexAreaID);
						createIndexArea(indexAreaID);
						connectorID = createJDBCConnector(indexAreaID,DBName_MP,ConnectorName,testCaseID);
						startIngestion(indexAreaID,connectorID);
						startBuild(indexAreaID);
						enableQueries(indexAreaID);
					}
					else 
					{
						Log.error("The provided index area is stuck in Ingestion, this requires manual intervention.");
						ha.assertEquals(0, 1, "The provided index area is stuck in Ingestion, this requires manual intervention.");
					}
				} else if(indexAreaExist == true && createIndex.equals("no"))
				{
					Log.info("Index area requested to create is already exists.");
					buildCompleted = vatidateBuild(indexAreaID);
				
					if(!(buildCompleted == buildStatus.buildCompleted || buildCompleted == buildStatus.none))
					{
						Log.error("The provided index area is stuck in Ingestion, this requires manual intervention.");
						ha.assertEquals(0, 1, "The provided index area is stuck in Ingestion, this requires manual intervention.");
					}
				} else if(indexAreaExist == false && createIndex.equals("yes"))
				{
					createIndexArea(indexAreaID);
					connectorID = createJDBCConnector(indexAreaID,DBName_MP,ConnectorName,testCaseID);
					startIngestion(indexAreaID,connectorID);
					startBuild(indexAreaID);
					enableQueries(indexAreaID);
				}
				else if(indexAreaExist == false && createIndex.equals("no"))
				{
					Log.error("The index area requested is not created, to proceed further create the index area or update create index area value to yes.");
					ha.assertEquals(0, 1,"The provided index area is not present in this environment.");
				}
				}
		
		public boolean validateIndexArea(String indexAreaID)
		{
			boolean exist = false;
			int statusCode=0;
			if(env.equals("MP"))
			{
			statusCode = given().when()
			.get(indexAreaID)
		.then()
		.extract().statusCode();
			}
			else if(env.equals("CAAT"))
			{
				statusCode = given().queryParam(paramKey, "application/json")
						.when()
						.get(indexAreaID)
					.then()
					.extract().statusCode();
			}
			
			if(statusCode == 200)
			{exist = true;
			Log.info("The requested index area is created successfully, and is now available.");}
			else
			{exist = false;
			Log.info("The request index area is not available, check if it is really created.");}
			
			return exist;
		}
		
		public void createIndexArea(String indexAreaID)
		{	
			int statusCode;
			//create index area
			Log.info("Started creating index area \""+indexAreaID+"\".");
			if(env.equals("MP"))
			{
			statusCode = given().header(paramKey,"application/json")
							.when().put(indexAreaID).andReturn().statusCode();
			}
			else if(env.equals("CAAT"))
			{
				statusCode = given().queryParam(paramKey,"application/json")
						.when().put(indexAreaID).andReturn().statusCode();	
			}else
			{
				statusCode =0;
			}
			Log.info("Create index returns status code: "+statusCode);
			ha.assertEquals(statusCode, 201, "Unable to create index, system returns status code: "+statusCode );
			validateIndexArea(indexAreaID);		
		}
		
		public void deleteIndexArea(String indexAreaID)
		{
			int statusCode =0;
			//delete the categorization request
			if(env.equals("MP"))
			{
			statusCode = given().header(paramKey,"application/json")
			.when().delete(indexAreaID).andReturn().statusCode();
			}else if(env.equals("CAAT"))
			{
				statusCode = given().queryParam(paramKey,"application/json")
						.when().delete(indexAreaID).andReturn().statusCode();	
			} else
			{
				statusCode =0;
			}
			ha.assertEquals(statusCode, 200, "Unable to delete index area \""+indexAreaID+"\"");
			Log.info("Deleted the index area \""+indexAreaID+"\"");
		}

		public String createJDBCConnector(String indexAreaID,String dbName, String connectorName, String testCaseID) throws JSONException
		{
			int statusCode;
			String sqlServerName = null;
			String userName = null;
			String password = null;
			String mp_local = "";
			if(env.equals("MP"))
			{
				sqlServerName = "10.12.239.126";
				userName = "sluser";
				password="Consilio@16#";
				mp_local = ",33,'\\\\elasticsearch'\"";
			}
			else if(env.equals("CAAT"))
			{
				sqlServerName = "10.12.239.126";
				userName = "sluser";
				password="Consilio@16#";
				mp_local = "\"";
			}
			String connector_config_jdbc = "{\"config\":"
					+ "{\"filterProportion\": 0.0"
					+ ",\"limit\": 0"
					+ ",\"mode\":\"ADD_TRAINING_AND_SEARCHABLE_ITEMS\""
					+ ",\"name\":\""+connectorName
					+ "\",\"params\":{"
					+ "\"singleItemQuery\":\"select DocumentID as itemId, 'file:' + FileLocation as URL from DocumentFiles where FileTypeCode = 'Txt' AND DocumentID = ?\""
					+ ",\"query\":\"EXEC get_test_by_stringItemID "+testCaseID+mp_local
					+ ",\"userName\": \""+userName+"\""
					+ " ,\"driverClassName\":\"com.microsoft.sqlserver.jdbc.SQLServerDriver\""
					+ ",\"password\": \""+password+"\"" 
					+ " ,\"url\":\"jdbc:sqlserver://"+sqlServerName
					+ ";databaseName="+dbName
					+ ";responseBuffering=adaptive;"
					+ "\"}},"
					+ "\"type\":\"JDBCConnector\"}";

			RequestSpecBuilder reqBuilder = new RequestSpecBuilder();
			RequestSpecification reqSpec = null;
			
			if(env.equals("MP"))
			{
			reqBuilder
				.addHeader(paramKey,"application/json")
				.setBody(connector_config_jdbc);
			} else if(env.equals("CAAT"))
			{
				reqBuilder
					.addQueryParam(paramKey,"application/json")
					.setBody(connector_config_jdbc);	
			} else
			{
				ha.assertTrue(false,"The environment is not setup for this execution.");
			}
			
			reqSpec = reqBuilder.build();
			ResponseSpecBuilder resBuilder = new ResponseSpecBuilder();
			resBuilder
			.toString();
			
			ResponseSpecification resSpec = resBuilder.build();
			
			ValidatableResponse vResponse = 
					given()
				.spec(reqSpec)
					.when()
				.put(indexAreaID + "/ingest/-1")
					.then()
				.spec(resSpec);
			
			statusCode = vResponse.extract().statusCode();
			if(statusCode == 201)
			{
				Log.info("Conenctor is created successfully.");
			}
			else
			{
				Log.info("Connector creation failed, system returns status code "+statusCode+" the error returned is "+vResponse.extract().body().asString());
				ha.assertEquals(0, 1, "Conector creation failed with status code \""+statusCode+"\"");
			}
			
			connectorID = vResponse.extract().jsonPath().getString("id");
			sa.assertTrue(Integer.parseInt(connectorID)> 0,"The connector is created invalid id: "+connectorID);
			return connectorID;
		}
		
		public String createJDBCConnector(String indexAreaID,String dbName, String connectorName, String testCaseID, String documentCount) throws JSONException
		{
			int statusCode;
			String sqlServerName = null;
			String userName = null;
			String password = null;
			String mp_local = "";
			if(env.equals("MP"))
			{
				sqlServerName = "10.12.239.126";
				userName = "sluser";
				password="Consilio@16#";
				mp_local = ",27,'\\\\elasticsearch\\\\Datasets'\"";
			}
			else if(env.equals("CAAT"))
			{
				sqlServerName = "10.12.239.126";
				userName = "sluser";
				password="Consilio@16#";
				mp_local = "\"";
			}
			String connector_config_jdbc = "{\"config\":"
					+ "{\"filterProportion\": 0.0"
					+ ",\"limit\": 0"
					+ ",\"mode\":\"ADD_TRAINING_AND_SEARCHABLE_ITEMS\""
					+ ",\"name\":\""+connectorName
					+ "\",\"params\":{"
					+ "\"singleItemQuery\":\"select DocumentID as itemId, 'file:' + FileLocation as URL from DocumentFiles where FileTypeCode = 'Txt' AND DocumentID = ?\""
					+ ",\"query\":\"EXEC get_test_by_stringItemID_nCount "+testCaseID+","+documentCount+mp_local
					+ ",\"userName\": \""+userName+"\""
					+ " ,\"driverClassName\":\"com.microsoft.sqlserver.jdbc.SQLServerDriver\""
					+ ",\"password\": \""+password+"\"" 
					+ " ,\"url\":\"jdbc:sqlserver://"+sqlServerName
					+ ";databaseName="+dbName
					+ ";responseBuffering=adaptive;"
					+ "\"}},"
					+ "\"type\":\"JDBCConnector\"}";

			//System.out.println(connector_config_jdbc);
			RequestSpecBuilder reqBuilder = new RequestSpecBuilder();
			RequestSpecification reqSpec = null;
			
			if(env.equals("MP"))
			{
			reqBuilder
				.addHeader(paramKey,"application/json")
				.setBody(connector_config_jdbc);
			} else if(env.equals("CAAT"))
			{
				reqBuilder
					.addQueryParam(paramKey,"application/json")
					.setBody(connector_config_jdbc);	
			} else
			{
				ha.assertTrue(false,"The environment is not setup for this execution.");
			}
			
			reqSpec = reqBuilder.build();
			ResponseSpecBuilder resBuilder = new ResponseSpecBuilder();
			resBuilder
			.toString();
			
			ResponseSpecification resSpec = resBuilder.build();
			
			ValidatableResponse vResponse = 
					given()
				.spec(reqSpec)
					.when()
				.put(indexAreaID + "/ingest/-1")
					.then()
				.spec(resSpec);
			
			statusCode = vResponse.extract().statusCode();
			if(statusCode == 201)
			{
				Log.info("Conenctor is created successfully.");
			}
			else
			{
				Log.info("Connector creation failed, system returns status code "+statusCode+" the error returned is "+vResponse.extract().body().asString());
				ha.assertEquals(0, 1, "Conector creation failed with status code \""+statusCode+"\"");
			}
			
			connectorID = vResponse.extract().jsonPath().getString("id");
			sa.assertTrue(Integer.parseInt(connectorID)> 0,"The connector is created invalid id: "+connectorID);
			return connectorID;
		}

		
		protected ingestionStatus getIngestionConnectorStatus(String indexAreaID) throws JSONException, ParseException
		{
			String[] connectorIDs;
			List<ingestionStatus> statusList = new ArrayList<ingestionStatus>();
			connectorIDs = getIngestionConnectors(indexAreaID);
			for(int i =0;i<connectorIDs.length;i++)
			{
			ingestionStatus bestConnectors = ingestionStatus.none;
			bestConnectors = validateIngestion(indexAreaID,connectorIDs[i]);
			statusList.add(bestConnectors);
			}
			int inprogressCount = Collections.frequency(statusList, ingestionStatus.ingestionInProgress);
			int completedCount = Collections.frequency(statusList, ingestionStatus.ingestionCompleted);
			int erroredCount = Collections.frequency(statusList, ingestionStatus.ingestionErrored);
			if (inprogressCount>0)
			{
				return ingestionStatus.ingestionInProgress;
			} else if(inprogressCount == 0 && completedCount >0)
			{
				return ingestionStatus.ingestionCompleted;
			}else if(inprogressCount == 0 && completedCount == 0 && erroredCount >0)
			{
				return ingestionStatus.ingestionErrored;
			}else
			{
				return ingestionStatus.none;
			}
		}
		
		protected String[] getIngestionConnectors(String indexAreaID) throws JSONException, ParseException
		{
			
			String ingestProperties = null;
			if(env.equals("MP"))
			{
			ingestProperties = "{\"properties\":"+given().header(paramKey,"application/json").when()
			.get(indexAreaID+"/ingest").then().extract().body().asString()+"}";
			} else if(env.equals("CAAT"))
			{
				ingestProperties = "{\"properties\":"+given().queryParam(paramKey,"application/json").when()
						.get(indexAreaID+"/ingest").then().extract().body().asString()+"}";	
			} else 
			{
				ha.assertTrue(false,"The environment is not setup among MP or CAAT for this execution");
			}
			
			JSONParser jp = new JSONParser();
			org.json.simple.JSONObject obj = (org.json.simple.JSONObject) jp.parse(ingestProperties);
			JSONArray objArray = (JSONArray) obj.get("properties");
			String[] ingestID = new String[objArray.size()];
			@SuppressWarnings("rawtypes")
			Iterator itr = objArray.iterator();
			
			for(int i=0; i<objArray.size();i++)
			{
				
				JSONObject connectors = new JSONObject(itr.next().toString());
				ingestID[i] = connectors.get("id").toString();
			}
			return ingestID;
		}
		
		protected ingestionStatus validateIngestion(String indexAreaID, String connectorID) throws JSONException
		{
			ingestionStatus ingested = ingestionStatus.none;
			String indexProperties = null;
			if(env.equals("MP"))
			{
			indexProperties = given().header(paramKey,"application/json").when()
			.get(indexAreaID+"/ingest/"+connectorID.toString()).then().extract().body().asString();
			} else if(env.equals("CAAT"))
			{
				indexProperties = given().queryParam(paramKey,"application/json").when()
						.get(indexAreaID+"/ingest/"+connectorID.toString()).then().extract().body().asString();	
			} else 
			{
				ha.assertTrue(false,"The environment is not setup among MP or CAAT for this execution");
			}
			JSONObject obj = new JSONObject(indexProperties);
			JSONObject objFailures = obj.getJSONObject("failures");
			JSONObject objStatus = obj.getJSONObject("status");
			if(objFailures.getInt("successCount") >0 && objStatus.getString("state").equals("IDLE"))
			{
				ingested = ingestionStatus.ingestionCompleted;
			} else if(objFailures.getInt("successCount") >0 && !(objStatus.getString("state").equals("IDLE")))
			{
				ingested = ingestionStatus.ingestionInProgress;
			} else if(objFailures.getInt("successCount") == 0 && !(objStatus.getString("state").equals("IDLE")))
			{
				ingested = ingestionStatus.ingestionInProgress;
			} else if(objFailures.getInt("successCount") == 0 && objStatus.getString("state").equals("IDLE") && objFailures.getInt("failureCount") == 0)
			{
				ingested = ingestionStatus.none;
			} else if(objFailures.getInt("successCount") == 0 && objStatus.getString("state").equals("IDLE") && objFailures.getInt("failureCount") > 0)
			{
				ingested = ingestionStatus.ingestionErrored;
			}
			
			return ingested;
			
			}
		
		protected buildStatus vatidateBuild(String indexAreaID) throws JSONException
		{
			buildStatus exist = buildStatus.none;
			String indexProperties = null;
			if(env.equals("MP"))
			{
			indexProperties = given().header(paramKey,"application/json").when()
			.get(indexAreaID).then().extract().body().asString();
			} else if(env.equals("CAAT"))
			{
				indexProperties = given().queryParam(paramKey,"application/json").when()
						.get(indexAreaID).then().extract().body().asString();	
			} else 
			{
				ha.assertTrue(false,"The environment is not setup among MP or CAAT for this execution");
			}
			JSONObject obj = new JSONObject(indexProperties);
			if(obj.isNull("lastBuildCompleted") == true && obj.getString("buildStage").toString().equals("NONE") && obj.isNull("lastBuildError") == true)
			{
				exist = buildStatus.none;
						Log.info("Index building is not yet initiated.");
			}
			else if(obj.isNull("lastBuildCompleted") == true && obj.getString("buildStage").toString().equals("NONE") == false)
			{
				exist = buildStatus.buildInProgress;
			}
			else if(obj.isNull("lastBuildCompleted") == false && obj.getString("buildStage").toString().equals("NONE") == true && obj.isNull("lastBuildError") == false)
			{
				exist = buildStatus.buildErrored;
			}
			else if(obj.isNull("lastBuildCompleted") == false && obj.getString("buildStage").toString().equals("NONE") == true && obj.isNull("lastBuildError") == true)
			{
				exist = buildStatus.buildCompleted;
			}
			else if(obj.isNull("lastBuildCompleted") == false && obj.getString("buildStage").toString().equals("NONE") == false && obj.isNull("lastBuildError") == true)
			{
				exist = buildStatus.buildInProgress;
			}
			return exist;
		}
		
		public void startIngestion(String indexAreaID,String connectorID) throws JSONException
		{
			
			int postStatusCode;
			long ingestStatus = 0;
			String ingestionStatus =null;
			RequestSpecBuilder reqBuilder = new RequestSpecBuilder();
			RequestSpecification reqSpec = reqBuilder.build();
		
			
			if (env.equals("MP"))
			{	
				postStatusCode = 200;
				reqBuilder
				.addQueryParam("op", "start")
				.addHeader(paramKey, "application/json");
			}
			else if(env.equals("CAAT"))
			{
				postStatusCode = 202;
				reqBuilder
				.addQueryParam("op", "start")
				.addQueryParam(paramKey, "application/json");
			}
			else
			{
				postStatusCode =0;
				ha.assertTrue(false,"The environment is not setup for this execution.");
			}
			
			ResponseSpecBuilder resBuilder  = new ResponseSpecBuilder();
			resBuilder.toString();
			ResponseSpecification resSpec = resBuilder.build();
			startTime = function.getTimeNow();
			ValidatableResponse vResponse = given()
				.spec(reqSpec)
			.when()
				.post(indexAreaID + "/ingest/"+ connectorID.toString())
			.then()
			.spec(resSpec);
			if(vResponse.extract().statusCode() == postStatusCode)
			{
				Log.info("Ingestion request completed without any error.");
			}else
			{
				Log.info("Ingestion request failed."+" The ingestion request failed with status code \""+vResponse.extract().statusCode()+"\" and status line \""+vResponse.extract().statusLine()+"\"");
				ha.assertEquals(vResponse.extract().statusCode(), postStatusCode,"The ingestion request failed with status code \""+vResponse.extract().statusCode()+"\" and status line \""+vResponse.extract().statusLine()+"\"");
			}
			
			JSONObject obj = null;
			Log.info("Currently, the ingestion status is \""+ingestStatus+"\"");
			for (;!(ingestStatus  > 0);)
			{
				try {
					TimeUnit.SECONDS.sleep(10);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				if (env.equals("MP"))
				{
				ingestionStatus = given().header(paramKey,"application/json").when()
						.get(indexAreaID + "/ingest/" + connectorID.toString()).thenReturn().body().asString();
				} else if(env.equals("CAAT"))
				{
					ingestionStatus = given().queryParam(paramKey,"application/json").when()
							.get(indexAreaID + "/ingest/" + connectorID.toString()).thenReturn().body().asString();
				} else
				{
					ha.assertTrue(false,"The environment is not setup for this execution.");
				}
				obj = new JSONObject(ingestionStatus);
				
				if(obj.getJSONObject("status").get("lastRunCompleted").equals(null))
				{
					ingestStatus = 0;
				}else
				{
					ingestStatus = obj.getJSONObject("status").getLong("lastRunCompleted");
				}
				
				if(ingestStatus  > 0)
				{
					endTime = function.getTimeNow();		
				}
			} 
			
			//float milliseconds = (float) endTime - (float) startTime; 
			//System.out.println((endTime-startTime)/1000+"."+(endTime-startTime)%1000+"  in ss.SSS for index area:"+indexAreaID);
			if((endTime-startTime)>0)
			{
			taskTime = Long.toString(((endTime-startTime)/1000)/60)+":"+Long.toString(((endTime-startTime)/1000)%60)+"."+Long.toString((endTime-startTime)%1000);
			}else
			{
				taskTime = "0";
			}
			
			Log.info("Currently, the ingestion status is \"COMEPLETED\"");
			
			if(obj.getJSONObject("failures").getInt("failureCount")>0 && obj.getJSONObject("failures").getInt("successCount")==0)
			{
				ha.assertTrue(false,"Ingestion failed/skipped for all the documents.");
			}else if(obj.getJSONObject("status").get("lastRunError").equals(null) == false)
			{
				Log.info("The ingestion is completed, with lastRunError: \""+obj.getJSONObject("status").get("lastRunError").toString()+"\", failureCount: "+obj.getJSONObject("status").getInt("failureCount")+" ,successCount: "+obj.getJSONObject("failures").getInt("successCount"));
				ha.assertTrue(false,"The ingestion is failed with error: \""+obj.getJSONObject("status").get("lastRunError").toString()+"\"");
			}
			Log.info("The ingestion completed with no error.");
		}
		
		public void startBuild(String indexAreaID) throws JSONException
		{
			int postStatusCode;
			buildStatus building = buildStatus.none;
			RequestSpecBuilder reqBuilder = new RequestSpecBuilder();
			RequestSpecification reqSpec = reqBuilder.build();
			
			if(env.equals("MP"))
			{
				postStatusCode = 202;
				reqBuilder
				.addQueryParam("op", "startBuild")
				.addHeader(paramKey, "application/json");
			}
			else if(env.equals("CAAT"))
			{
				postStatusCode = 200;
				reqBuilder
				.addQueryParam("op", "startBuild")
				.addQueryParam(paramKey, "application/json");
			}
			else
			{
				postStatusCode=0;
				ha.assertTrue(false,"The environment is not setup for this execution.");
			}
				
			ResponseSpecBuilder resBuilder = new ResponseSpecBuilder();
			resBuilder.toString();
			ResponseSpecification resSpec = resBuilder.build();
			
			startTime = function.getTimeNow();
			ValidatableResponse vResponse = given()
				.spec(reqSpec).when().post(indexAreaID).then().spec(resSpec);
		
			if(vResponse.extract().statusCode() == postStatusCode)
			{
				Log.info("The index building request is completed without any error.");
				building = buildStatus.buildInProgress;
			}
			else{
				Log.info("The index building request failed with status code \""+vResponse.extract().statusCode()+"\"");
			}
			
			while(building != buildStatus.buildCompleted)
			{
				try {
					TimeUnit.SECONDS.sleep(10);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				building = vatidateBuild(indexAreaID);
				if(building.equals(buildStatus.buildCompleted))
				{
					endTime = function.getTimeNow();
				}
				if(building == buildStatus.buildErrored)
				{
				ha.assertTrue(false,"The building of index is failed, please check logs for more infromation.");
				}
			}
			if((endTime-startTime)>0)
			{
			taskTime = Long.toString(((endTime-startTime)/1000)/60)+":"+Long.toString(((endTime-startTime)/1000)%60)+"."+Long.toString((endTime-startTime)%1000);
			}else
			{
				taskTime = "0";
			}
			
		}
		
		public void enableQueries(String indexAreaID) throws InterruptedException, JSONException
		{
			String queryStatus=null;
			String qStatus = "NULL";
			
			RequestSpecBuilder reqBuilder = new RequestSpecBuilder();
			RequestSpecification reqSpec = reqBuilder.build();
			if(env.equals("MP"))
			{
				reqBuilder
				.addHeader(paramKey, "application/json")
				.addQueryParam("op", "enableQueries");
			} else if(env.equals("CAAT"))
			{
				reqBuilder
				.addQueryParam(paramKey, "application/json")
				.addQueryParam("op", "enableQueries");
			} else
			{
				ha.assertTrue(false,"The environment is not setup for this execution.");
			}
			
			ResponseSpecBuilder resBuilder = new ResponseSpecBuilder();
			resBuilder.toString();
			ResponseSpecification resSpec = resBuilder.build();
			
			//request to enable queries
			ValidatableResponse vResponse = given().spec(reqSpec).when()
				.post(indexAreaID).then().spec(resSpec);
			
			if(vResponse.extract().statusCode() == 202)
			{
				Log.info("The queries are enabled on the requested index, wihtout any error.");
			}
			else
			{
				Log.info("Unable to enable queries on requested index. System returns the status code \""+vResponse.extract().statusCode()+"\"");
				ha.assertEquals(vResponse.extract().statusCode(), 202,"Unable to enable queries on requested index. System returns the status code \""+vResponse.extract().statusCode()+"\"");
			}
			
			if(env.equals("CAAT"))
			{
			for (;qStatus.equals("ENABLED")!= true;)
			{
				queryStatus = given().queryParam(paramKey, "application/json").when()
						.get(indexAreaID).andReturn().getBody().asString();
				
				JSONObject obj = new JSONObject(queryStatus);
				qStatus = obj.getString("queryState");
			}
			} 
		}
		
		public String createSearchRequest(String indexAreaID, String searchTerm, String conceptScore) throws JSONException
		{
			Object[] searchArray= function.getSearchArray(searchTerm);
			
			Log.info("The search term for this request is \""+searchTerm+"\", which is converted into array as "+Arrays.toString(searchArray)+", and the score provided for this request is: "+conceptScore);
			RequestSpecBuilder reqBuilder = new RequestSpecBuilder();
			RequestSpecification reqSpec = reqBuilder.build();
			
			String requestBody= "{"+
					 "\"queryType\": \"SearchRequest\","+
					 "\"request\": {"+
					  "\"concept\":[{\"rawItem\":{\"data\":"+Arrays.toString(searchArray)+"}}]"+
					 ",\"maxNumItems\": 50"+
					  ",\"minConceptScore\":" + conceptScore +"}}";
			
			if(env.equals("MP"))
			{
			reqBuilder
			.addHeader(paramKey, "application/json")
			.setBody(requestBody);
			} else if(env.equals("CAAT"))
			{
				reqBuilder
				.addQueryParam(paramKey, "application/json")
				.setBody(requestBody);
			} else
			{
				ha.assertTrue(false,"The environment is not setup for this execution");
			}
			
			ResponseSpecBuilder resBuilder = new ResponseSpecBuilder();
			resBuilder.toString();
			ResponseSpecification resSpec = resBuilder.build();
			
			startTime = function.getTimeNow();
			
			ValidatableResponse vResponse = given()
				.spec(reqSpec)
			.when()
				.post(indexAreaID+"/search")
			.then()
			.spec(resSpec);
			
			endTime = function.getTimeNow();
			
			if(vResponse.extract().statusCode() == 200)
			{
				if((endTime-startTime)>0)
				{
				taskTime = Long.toString(((endTime-startTime)/1000)/60)+":"+Long.toString(((endTime-startTime)/1000)%60)+"."+Long.toString((endTime-startTime)%1000);
				}else
				{
					taskTime = "0";
				}
				
				Log.info("The search request is completed without any error.");
			}
			else
			{
				Log.info("The search request is failed with following status code \""+vResponse.extract().statusCode()+"\", and the following information: "+vResponse.extract().body().asString());
				ha.assertEquals(vResponse.extract().statusCode(), 200,"The search request is failed with following status code \""+vResponse.extract().statusCode()+"\", and the following information: "+vResponse.extract().body().asString());
			}
			return vResponse.extract().body().asString();
		}
	
		@SuppressWarnings("unchecked")
		public void createCategorizationRequest(String indexAreaID,String cohScore, String categorizationID, String trainingInputPath, String corpusInputPath) throws JSONException, IOException, ParseException
		{
			int putStatusCode;
			
			JSONArray corpus = function.getDataFromCSVCorpus(corpusInputPath);
			String[] training = function.getDataFromCSV(trainingInputPath);
			RequestSpecBuilder reqBuilder = new RequestSpecBuilder();
			RequestSpecification reqSpec = reqBuilder.build();
			
			JSONObject reqBody = new JSONObject();
			JSONObject request = new JSONObject();
			JSONArray operation = new JSONArray();
			JSONObject limiters = new JSONObject();
			reqBody.put("queryType", "SearchableCategorizeRequest");
			request.put("maxNumCategoriesInResults", "1");
			request.put("minScore", Double.parseDouble(cohScore));
			request.put("examples", function.getJSONforConceptExample(training));
			limiters.put("operation", "in");
			limiters.put("name", "itemId");
			limiters.put("stringListValue", corpus);
			operation.add(limiters);
			request.put("limiters", operation);
			reqBody.put("request", request);
			
			//Log.info(reqBody.toString());
			
			if(env.equals("MP"))
			{
				putStatusCode = 201;
				reqBuilder
				.addHeader(paramKey, "application/json")
				.setBody(reqBody.toString());
			}
			else if(env.equals("CAAT"))
			{
			putStatusCode = 201;
			reqBuilder
			.addQueryParam(paramKey, "application/json")
			.setBody(reqBody.toString());
			}
			else
			{
				putStatusCode=0;
				ha.assertTrue(false,"The environment is not setup for this execution.");
			}
			
			given().spec(reqSpec).when().put(indexAreaID+"/search/"+categorizationID).then().statusCode(putStatusCode);
					
			}
		
		public void runCategorizeQuery(String indexAreaID, String categorizationID) throws JSONException
		{
			String searchRunStatus = "UNKNOWN";
			String rStatus = "null";
			RequestSpecBuilder reqBuilder = new RequestSpecBuilder();
			RequestSpecification reqSpec = reqBuilder.build();
			if(env.equals("MP"))
			{
			reqBuilder
			.addQueryParam("op", "start")
			.addHeader(paramKey,"application/json");
			} else if(env.equals("CAAT"))
			{
				reqBuilder
				.addQueryParam("op", "start")
				.addQueryParam(paramKey,"application/json");	
			} else
			{
				ha.assertTrue(false,"The environment is not setup for this execution.");
			}
			
			startTime = function.getTimeNow();
			given().spec(reqSpec).when().post(indexAreaID+"/search/"+categorizationID).then().statusCode(200);
			for (;searchRunStatus.equals("COMPLETED")!= true && searchRunStatus.equals("ERRORED")!= true ;)
			{
				try {
					TimeUnit.SECONDS.sleep(10);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				if(env.equals("MP")){rStatus = given().header(paramKey, "application/json").when()
						.get(indexAreaID+"/search/"+categorizationID).andReturn().getBody().asString();}
				else if(env.equals("CAAT")){rStatus = given().queryParam(paramKey, "application/json").when()
						.get(indexAreaID+"/search/"+categorizationID).andReturn().getBody().asString();}
				else {rStatus = null; ha.assertTrue(false,"The environment setup is not done for this execution.");}
				
				JSONObject obj = new JSONObject(rStatus);
				if(obj.get("state").equals(null))
				{
				searchRunStatus = "UNKNOWN";	
				}else{
				searchRunStatus = obj.getString("state");
				if(searchRunStatus.equals("ERRORED"))
				{
					Log.info("The categorization request is failed with below details,"+rStatus.toString());
				ha.assertTrue(false,"The Catrogirxzation request failed , please check logs for full details.");
				}
				
				endTime = function.getTimeNow();
			}
				if((endTime-startTime)>0)
				{
				taskTime = Long.toString(((endTime-startTime)/1000)/60)+":"+Long.toString(((endTime-startTime)/1000)%60)+"."+Long.toString((endTime-startTime)%1000);
				}else
				{
					taskTime = "0";
				}
				}
			
			ResponseSpecBuilder resBuilder = new ResponseSpecBuilder();
			ResponseSpecification resSpec = resBuilder.build();
			resBuilder
			.expectBody("state",is("COMPLETED"))
			.expectBody("queryId",is(categorizationID))
			.expectBody("completedTime",not("null"));
			
			if(env.equals("MP"))
			{
			given().header(paramKey, "application/json").when()
			.get(indexAreaID+"/search/"+categorizationID).then().spec(resSpec);
			} else if(env.equals("CAAT"))
			{
				given().queryParam(paramKey, "application/json").when()
				.get(indexAreaID+"/search/"+categorizationID).then().spec(resSpec);
			}
		}
		
		public String getCategorizationResult(String indexAreaID, String categorizationID)
		{
			String cateResult = null;
		//get categorization results by score
		RequestSpecBuilder reqBuilder = new RequestSpecBuilder();
		RequestSpecification reqSpec = reqBuilder.build();
		if(env.equals("MP"))
		{reqBuilder.addHeader(paramKey, "application/json");}
		else if(env.equals("CAAT"))
		{reqBuilder.addQueryParam(paramKey, "application/json");}
		else{ha.assertTrue(false,"The environment is not setup for this execution.");}
		
		ResponseSpecBuilder resBuilder = new ResponseSpecBuilder();
		resBuilder.toString();
		ResponseSpecification resSpec = resBuilder.build();
		
		ValidatableResponse vResponse = given().spec(reqSpec).when().get(indexAreaID+"/search/"+categorizationID+"/results?length=-1").then().spec(resSpec);
		
		if(vResponse.extract().statusCode() == 200)
		{
			cateResult = vResponse.extract().body().asString();
		}else
		{
			Log.error("Get categorization results failed with error. Expected status code was 200, but system returned "+ vResponse.extract().statusCode());
			ha.assertEquals(vResponse.extract().statusCode(), 200,"Get categorization results failed with error. Expected status code was 200, but system returned "+vResponse.extract().statusCode());
		}
		
		return cateResult;
		}
			
		public boolean validateCatgoryIDAvailable(String indexAreaID,String categorizationID)
		{
			boolean exist = false;
			int statusCode;
			if(env.equals("MP"))
			{statusCode = given().header(paramKey,"application/json").when().get(indexAreaID+"/search/"+categorizationID).then().extract().statusCode();}
			else if(env.equals("CAAT"))
			{statusCode = given().queryParam(paramKey,"application/json").when().get(indexAreaID+"/search/"+categorizationID).then().extract().statusCode();}
			else 
			{statusCode=0;ha.assertTrue(false,"The enviornment is not setup for this execution.");}
			
			if(statusCode == 409)
			{exist = false;}
			else if(statusCode == 200)
			{exist = true;}
			
			return exist;
		}
		
		public void deleteCategoryID(String indexAreaID, String categorizationID)
		{
			//delete the categorization request
			if(env.equals("MP"))
			{given().header(paramKey,"application/json").when().delete(indexAreaID+"/search/"+categorizationID).then().statusCode(200);}
			else if(env.equals("CAAT"))
			{given().queryParam(paramKey,"application/json").when().delete(indexAreaID+"/search/"+categorizationID).then().statusCode(200);}
			else{ha.assertTrue(false,"The environment is not setup for this execution.");}
		}
		
		public void createClusterConceptualNearDupe(String indexAreaID, String clusterID)
		{
			String ClusterNearDupeRequest = "{\"clusterAlgorithm\":\"CONCEPTUAL_NEAR_DUP\",\"numTitleWords\":7}";
			
			
			RequestSpecBuilder reqBuilder = new RequestSpecBuilder();
			RequestSpecification reqSpec = reqBuilder.build();
			if(env.equals("MP"))
			{reqBuilder.addHeader(paramKey, "application/json").setBody(ClusterNearDupeRequest);}
			else if(env.equals("CAAT"))
			{reqBuilder.addQueryParam(paramKey, "application/json").setBody(ClusterNearDupeRequest);}
			else{ha.assertTrue(false,"The environment is not setup for this execution.");}
			
			given().spec(reqSpec).when().put(indexAreaID+"/cluster/"+clusterID).then().statusCode(201);
			
			//validate cluster is created
			if(env.equals("MP"))
			{given().header(paramKey, "application/json").when().get(indexAreaID+"/cluster/"+clusterID).then().body("queryId",is(clusterID));}
			else if(env.equals("CAAT"))
			{given().queryParam(paramKey, "application/json").when().get(indexAreaID+"/cluster/"+clusterID).then().body("queryId",is(clusterID));}
			else{ha.assertTrue(false,"The environment is not setup for this execution.");}
			
			
		}
		
		 public boolean validateClusterID(String indexAreaID, String clusterID)
		 {
			 boolean exist = false;
			 int statusCode; 
			 if(env.equals("MP"))
			 {statusCode = given().header(paramKey,"application/json").when().get(indexAreaID+"/cluster/"+clusterID).then().extract().statusCode();}
			 else if(env.equals("CAAT"))
			 {statusCode = given().queryParam(paramKey,"application/json").when().get(indexAreaID+"/cluster/"+clusterID).then().extract().statusCode();}
			 else
			 {statusCode=0;ha.assertTrue(false,"The environment is not setup for this execution.");}
			 
			 if(statusCode == 409)
			 {exist=false;}
			 else if(statusCode == 200)
			 {exist=true;}
			 return exist;
		 }
			
		 public void deleteClusterByID(String indexAreaID, String clusterID)
		 {
			 //delete the clusterID
			 if(env.equals("MP"))
			 {given().header(paramKey,"application/json").when().delete(indexAreaID+"/cluster/"+clusterID).then().statusCode(200);}
			 else if(env.equals("CAAT"))
			 {given().queryParam(paramKey,"application/json").when().delete(indexAreaID+"/cluster/"+clusterID).then().statusCode(200);}
			 else{ha.assertTrue(false,"The environment is not setup for this execution.");}
		 }
		
		public void createClusterMigrationplus(String indexAreaID, String clusterID)
		{
			String ClusterRequest = "{"+
					"\"clusterAlgorithm\":\"MIGRATION_PLUS\""+
						",\"failOnUnknownItemMetadata\":false"+
						",\"generality\":0.5"+
						",\"maxHierarchyDepth\":10"+
						",\"minCoherence\":0.9"+
						",\"numTitleWords\":7"+
						",\"outlineNumbering\":false"+
						",\"titleAlgorithm\":\"GENERAL\"}";
			
			RequestSpecBuilder reqBuilder = new RequestSpecBuilder();
			RequestSpecification reqSpec = reqBuilder.build();
			
			if(env.equals("MP"))
			{reqBuilder.addHeader(paramKey, "application/json").setBody(ClusterRequest);}
			else if(env.equals("CAAT"))
			{reqBuilder.addQueryParam(paramKey, "application/json").setBody(ClusterRequest);}
			else
			{ha.assertTrue(false,"The environment is not setup for this execution.");}
			
			given().spec(reqSpec).when().put(indexAreaID+"/cluster/"+clusterID).then().statusCode(201);
			
			//validate cluster is created
			if(env.equals("MP"))
			{given().header(paramKey, "application/json").when().get(indexAreaID+"/cluster/"+clusterID).then().body("queryId",is(clusterID.toString()));}
			else if(env.equals("CAAT"))
			{given().queryParam(paramKey, "application/json").when().get(indexAreaID+"/cluster/"+clusterID).then().body("queryId",is(clusterID.toString()));}
			else
			{ha.assertTrue(false,"The environment is not setup for this execution.");}
		}
		
		public void runClusterQuery(String indexAreaID, String clusterID, String clusterType) throws JSONException
		{
			RequestSpecBuilder reqBuilder = new RequestSpecBuilder();
			RequestSpecification reqSpec = reqBuilder.build();
			startTime = function.getTimeNow();
			if(env.equals("MP"))
			{reqBuilder.addQueryParam("op","start").addHeader(paramKey, "application/json");}
			else if(env.equals("CAAT"))
			{reqBuilder.addQueryParam("op","start").addQueryParam(paramKey, "application/json");}
			else
			{ha.assertTrue(false,"The environment is not setup for this execution.");}
			
			given().spec(reqSpec).when().post(indexAreaID+"/cluster/"+clusterID).then().statusCode(202);

			String clustStatus = "NONE";
			for (;clustStatus.equals("COMPLETED") != true;)
			{
				try {
					TimeUnit.SECONDS.sleep(10);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				String clusterStatus;
				
				if(env.equals("MP"))
				{clusterStatus  = given().header(paramKey,"application/json").when().get(indexAreaID+"/cluster/"+clusterID).andReturn().getBody().asString();}
				else if(env.equals("CAAT"))
				{clusterStatus  = given().queryParam(paramKey,"application/json").when().get(indexAreaID+"/cluster/"+clusterID).andReturn().getBody().asString();}
				else
				{clusterStatus=null;ha.assertTrue(false,"The environment is not setup for this execution.");}
				
				JSONObject obj = new JSONObject(clusterStatus);
				clustStatus = obj.getString("state");
				if(clustStatus.equals("ERRORED"))
				{
					Log.info("The clustering failed.");
					ha.assertTrue(false,"The clustering failed. Please check the logs for more information.");
				}
				if(clustStatus.equals("COMPLETED"))
				{
					endTime = function.getTimeNow();			
				}
			}
			
			if((endTime-startTime)>0)
			{
			taskTime = Long.toString(((endTime-startTime)/1000)/60)+":"+Long.toString(((endTime-startTime)/1000)%60)+"."+Long.toString((endTime-startTime)%1000);
			}else
			{
				taskTime = "0";
			}
	 	}
			
		public String getClusterResults(String indexAreaID,String clusterID) throws FileNotFoundException, UnsupportedEncodingException
		{
			int statusCode;
			RequestSpecBuilder reqBuilder = new RequestSpecBuilder();
			RequestSpecification reqSpec = reqBuilder.build();
			
			if(env.equals("MP"))
			{reqBuilder
				.addHeader(paramKey, "application/json")
				.setBody("sort=TITLE");
			}else if(env.equals("CAAT"))
			{
				reqBuilder
				.addQueryParam(paramKey, "application/json")
				.addQueryParam("sort=TITLE");
			}
			
			ResponseSpecBuilder resBuilder = new ResponseSpecBuilder();
			resBuilder.toString();
			ResponseSpecification resSpec = resBuilder.build();
			
			ValidatableResponse vResponse = given()
					.spec(reqSpec)
					.when()
					.get(indexAreaID+"/cluster/"+clusterID+"/results")
					.then()
					.spec(resSpec);
			
			statusCode = vResponse.extract().statusCode();
			Log.info("The cluster result fetching with below details: "+vResponse.extract().asString());
			ha.assertEquals(statusCode, 200,"The cluster result is returning error, please check the logs for more details.");
			return vResponse.extract().body().asString();
		}
		
		public void disableQueries(String indexAreaID) throws InterruptedException, JSONException
		{
			String queryStatus=null;
			String qStatus = "NULL";
			
			RequestSpecBuilder reqBuilder = new RequestSpecBuilder();
			RequestSpecification reqSpec = reqBuilder.build();
			if(env.equals("MP"))
			{reqBuilder.addHeader(paramKey, "application/json").addQueryParam("op", "disableQueries");}
			else if(env.equals("CAAT"))
			{reqBuilder.addQueryParam(paramKey, "application/json").addQueryParam("op", "disableQueries");}
			else
			{ha.assertTrue(false,"The environment is not setup for this execution.");}
			
			ResponseSpecBuilder resBuilder = new ResponseSpecBuilder();
			resBuilder.toString();
			ResponseSpecification resSpec = resBuilder.build();
			//request to enable queries
			ValidatableResponse vResponse = given().spec(reqSpec).when().post(indexAreaID).then().spec(resSpec);
			
			if(vResponse.extract().statusCode()==202)
			{
				Log.info("Disabled queries request is completed successfully, wityhout any error.");
			}
			else
			{
				Log.info("Disabled queries request failed with status code \""+vResponse.extract().statusCode()+"\"");
				ha.assertEquals(vResponse.extract().statusCode(), 200,"Disabled queries failed with status code \""+vResponse.extract().statusCode()+"\"");
			}
			
			
			 if(env.equals("CAAT"))
			 {
			for (;qStatus.equals("DISABLED")!= true;)
			{
				queryStatus = given()
						.queryParam(paramKey, "application/json")
						.when()
						.get(indexAreaID)
						.andReturn()
						.getBody()
						.asString();
				JSONObject obj = new JSONObject(queryStatus);
				qStatus = obj.getString("queryState");
			}
			}
			
		}
	}


