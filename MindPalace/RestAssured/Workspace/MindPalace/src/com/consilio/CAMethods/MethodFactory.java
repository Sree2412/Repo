package com.consilio.CAMethods;


import java.io.IOException;
import java.text.DecimalFormat;
import org.json.JSONException;
import org.json.simple.parser.ParseException;
import org.testng.asserts.Assertion;

import com.consilio.CAMethods.EnumFactory.buildStatus;
import com.mp.lib.Log;

public class MethodFactory {
	private Assertion ha = new Assertion();
	
	public void functionalEnvironmentSetup (String indexAreaID,String createIndex, String DBName_MP,String ConnectorName, String testCaseID) throws JSONException, InterruptedException
	{
		String connectorID;
		APIFactory apiFunction = new APIFactory();
		buildStatus buildCompleted = buildStatus.none;
		boolean indexAreaExist = false;
		
			Log.info("Need to create a index area \""+indexAreaID+"\"");
			indexAreaExist = apiFunction.validateIndexArea(indexAreaID);
			
			if(indexAreaExist == true && createIndex.equals("yes"))
			{
				Log.info("Index area requested to create is already exists.");
				buildCompleted = apiFunction.vatidateBuild(indexAreaID);
			
				if(buildCompleted == buildStatus.buildCompleted || buildCompleted == buildStatus.none)
				{
					apiFunction.deleteIndexArea(indexAreaID);
					apiFunction.createIndexArea(indexAreaID);
					connectorID = apiFunction.createJDBCConnector(indexAreaID,DBName_MP,ConnectorName,testCaseID);
					apiFunction.startIngestion(indexAreaID,connectorID);
					apiFunction.startBuild(indexAreaID);
					apiFunction.enableQueries(indexAreaID);
				}
				else 
				{
					Log.error("The provided index area is stuck in Ingestion, this requires manual intervention.");
					ha.assertEquals(0, 1, "The provided index area is stuck in Ingestion, this requires manual intervention.");
				}
			} else if(indexAreaExist == true && createIndex.equals("no"))
			{
				Log.info("Index area requested to create is already exists.");
				buildCompleted = apiFunction.vatidateBuild(indexAreaID);
			
				if(!(buildCompleted == buildStatus.buildCompleted || buildCompleted == buildStatus.none))
				{
					Log.error("The provided index area is stuck in Ingestion, this requires manual intervention.");
					ha.assertEquals(0, 1, "The provided index area is stuck in Ingestion, this requires manual intervention.");
				}
			} else if(indexAreaExist == false && createIndex.equals("yes"))
			{
				apiFunction.createIndexArea(indexAreaID);
				connectorID = apiFunction.createJDBCConnector(indexAreaID,DBName_MP,ConnectorName,testCaseID);
				apiFunction.startIngestion(indexAreaID,connectorID);
				apiFunction.startBuild(indexAreaID);
				apiFunction.enableQueries(indexAreaID);
			}
			else if(indexAreaExist == false && createIndex.equals("no"))
			{
				Log.error("The index area requested is not created, to proceed further create the index area or update create index area value to yes.");
				ha.assertEquals(0, 1,"The provided index area is not present in this environment.");
			}
			}

	public void CAATCleanUpMethod(APIFactory apiFunction,String[] data) throws IOException, JSONException
	{
		apiFunction.setupEnv();
		apiFunction.deleteIndexArea(data[0].toString());
		apiFunction.createIndexArea(data[0].toString());
		
	}
	
	public void CAATingestionMethod(APIFactory apiFunction,String[] data) throws JSONException, InterruptedException, IOException, ParseException
	{
		String connectorID;
		apiFunction.setupEnv();
		connectorID = apiFunction.createJDBCConnector(data[0].toString(),data[2].toString(),data[1].toString(),data[3].toString());
		apiFunction.startIngestion(data[0].toString(),connectorID);
	}
	
	public void CAATbuildMethod(APIFactory apiFunction,String[] data) throws JSONException, InterruptedException, IOException
	{
		apiFunction.setupEnv();
		apiFunction.startBuild(data[0].toString());
		apiFunction.enableQueries(data[0].toString());	
	}
	
	public void CAATmasterClusterMethod(APIFactory apiFunction, String[] data, String outputURL) throws IOException, JSONException
	{
		String clusterID = "MasterCluster-"+data[0].toString();
		apiFunction.setupEnv();
		apiFunction.createClusterMigrationplus(data[0].toString(), clusterID);
		apiFunction.runClusterQuery(data[0].toString(),clusterID,"MasterCluster");
		String result = apiFunction.getClusterResults(data[0].toString(), clusterID);
		apiFunction.function.copyResultsDirectly(outputURL+"MasterCluster-"+data[0].toString(), result);
	}
	
	public void CAATconceptualNearDupeMethod(APIFactory apiFunction, String[] data, String outputURL) throws IOException, JSONException
	{
		String clusterID = "ConceptualDupeCluster-"+data[0].toString();
		apiFunction.setupEnv();
		apiFunction.createClusterConceptualNearDupe(data[0].toString(), clusterID);
		apiFunction.runClusterQuery(data[0].toString(),clusterID,"NearDupeCluster");
		String result = apiFunction.getClusterResults(data[0].toString(), clusterID);
		apiFunction.function.copyResultsDirectly(outputURL+"ConceptualDupeCluster-"+data[0].toString(), result);
	}
	
	public void CAATSearchMethod(APIFactory apiFunction, String[] data, String outputURL) throws JSONException, IOException
	{
		apiFunction.setupEnv();
		String searchCoh = data[2].toString();
		double sCDouble = Double.parseDouble(data[2].toString());
		double itera = 0.05;
		int count = (100/(int)(itera*100)) - ((int)(sCDouble*100)/(int)(itera*100))+1;
		for(int i =0;i<count;i++)
		{
			DecimalFormat decim = new DecimalFormat("0.00");
			double nwSearchCoh = Double.parseDouble(decim.format(sCDouble+(itera*i)));
			if(nwSearchCoh <= 1.00)
			{
			searchCoh = Double.toString(nwSearchCoh);
			String result = apiFunction.createSearchRequest(data[0].toString(),data[1].toString(),searchCoh);
			apiFunction.function.copyResultsDirectly(outputURL+data[3].toString()+"_"+Integer.toString((int)(nwSearchCoh*100)), result);
			}
		}
	}
	
	public void CAATCategorizationMethod(APIFactory apiFunction, String[] data, String outputURL) throws JSONException, IOException, InterruptedException, ParseException
	{
		apiFunction.setupEnv();
		String basePath = "\\\\10.12.235.31\\MPQATeam\\InputReferences\\categorizationInputCSVFiles\\performance\\";
		apiFunction.enableQueries(data[4].toString());
		String catTraining = data[0].toString()+"_training.csv";
		String catCorpus=data[0].toString()+"_corpus.csv";
		String mockFileName= data[2].toString()+"_"+data[0].toString();
		String catCoh = data[1].toString();
		double catCD = Double.parseDouble(data[1].toString());
		double catI = Double.parseDouble(data[3].toString());
		int catCI = (int) (catCD *100);
		int catII = (int) (catI*100);
		int count = (100/catII)-(catCI/catII)+1;
		String actResult;
		
		for (int i =0;i<count;i++)
		{
			DecimalFormat decim = new DecimalFormat("0.00");
			double nwCatCoh = Double.parseDouble(decim.format(catCD+(catI*i)));
			catCoh = Double.toString(nwCatCoh);
			String categorizationID = data[0].toString()+"_Categorization_Request_"+nwCatCoh;		

			apiFunction.createCategorizationRequest(data[4].toString(),catCoh,categorizationID, basePath+catTraining, basePath+catCorpus);
			apiFunction.runCategorizeQuery(data[4].toString(),categorizationID);
		actResult = apiFunction.getCategorizationResult(data[4].toString(),categorizationID);
		apiFunction.function.copyResultsDirectly("D:\\new\\MockFiles\\Categorization\\"+mockFileName+"_"+Integer.toString((int)(nwCatCoh*100)),actResult);
		apiFunction.deleteCategoryID(data[4].toString(),categorizationID);
		}
		
	}

	public void scalingCleanUpMethod(APIFactory apiFunction,String[] data) throws IOException, JSONException
	{
		apiFunction.setupEnv();
		apiFunction.deleteIndexArea(data[0].toString());
		apiFunction.createIndexArea(data[0].toString());
		
	}
	
	public void postScalingCleanUpMethod(APIFactory apiFunction,String[] data) throws IOException, JSONException
	{
		apiFunction.setupEnv();
		apiFunction.deleteIndexArea(data[0].toString());		
	}
	
	public void ingestionScalingMethod(APIFactory apiFunction,String[] data) throws JSONException, InterruptedException, IOException, ParseException
	{
		String connectorID;
		apiFunction.setupEnv();
		connectorID = apiFunction.createJDBCConnector(data[0].toString(),data[2].toString(),data[1].toString(),data[3].toString());
		apiFunction.startIngestion(data[0].toString(),connectorID);
		apiFunction.function.insertQAScalingInfo(new String[] {data[0].toString(),data[3].toString(),data[5].toString(),"Ingestion",data[4].toString(),apiFunction.function.getDateForSQL(apiFunction.startTime),apiFunction.function.getDateForSQL(apiFunction.endTime),apiFunction.taskTime," "});
	}
	
	public void ingestionPerformanceMethod(APIFactory apiFunction,String[] data) throws JSONException, InterruptedException, IOException, ParseException
	{
		String connectorID;
		apiFunction.setupEnv();
		connectorID = apiFunction.createJDBCConnector(data[0].toString(),data[2].toString(),data[1].toString(),data[3].toString(),data[6].toString());
		apiFunction.startIngestion(data[0].toString(),connectorID);
		apiFunction.function.insertQAScalingInfo(new String[] {data[0].toString(),data[3].toString(),data[5].toString(),"Ingestion",data[4].toString(),apiFunction.function.getDateForSQL(apiFunction.startTime),apiFunction.function.getDateForSQL(apiFunction.endTime),apiFunction.taskTime," "});
		System.out.println(data[0].toString()+" : this dataset id is created, also connector is created with ID: "+connectorID+", which has completed ingestion.");
	}
	
	public void buildScalingMethod(APIFactory apiFunction,String[] data) throws JSONException, InterruptedException, IOException
	{
		apiFunction.setupEnv();
		apiFunction.startBuild(data[0].toString());
		apiFunction.enableQueries(data[0].toString());
		apiFunction.function.insertQAScalingInfo(new String[] {data[0].toString(),data[3].toString(),data[5].toString(),"Build",data[4].toString(),apiFunction.function.getDateForSQL(apiFunction.startTime),apiFunction.function.getDateForSQL(apiFunction.endTime),apiFunction.taskTime," "});
		System.out.println("Building index is completed for index area: "+data[0].toString());
		
	}
	
	public void masterClusterScalingMethod(APIFactory apiFunction, String[] data) throws IOException, JSONException
	{
		String clusterID = "MasterCluster-"+data[0].toString();
		apiFunction.setupEnv();
		apiFunction.createClusterMigrationplus(data[0].toString(), clusterID);
		apiFunction.runClusterQuery(data[0].toString(),clusterID,"MasterCluster");
		apiFunction.function.insertQAScalingInfo(new String[] {data[0].toString(),data[3].toString(),data[5].toString(),"MasterCluster",data[4].toString(),apiFunction.function.getDateForSQL(apiFunction.startTime),apiFunction.function.getDateForSQL(apiFunction.endTime),apiFunction.taskTime," "});
		
	}
	
	public void conceptualNearDupeScalingMethod(APIFactory apiFunction, String[] data) throws IOException, JSONException
	{
		String clusterID = "ConceptualDupeCluster-"+data[0].toString();
		apiFunction.setupEnv();
		apiFunction.createClusterConceptualNearDupe(data[0].toString(), clusterID);
		apiFunction.runClusterQuery(data[0].toString(),clusterID,"NearDupeCluster");
		apiFunction.function.insertQAScalingInfo(new String[] {data[0].toString(),data[3].toString(),data[5].toString(),"ConceptualNearDupe",data[4].toString(),apiFunction.function.getDateForSQL(apiFunction.startTime),apiFunction.function.getDateForSQL(apiFunction.endTime),apiFunction.taskTime," "});
	}
	
	public void CreateCategorizationMethod(APIFactory apiFunction, String[] data) throws JSONException, IOException, InterruptedException, ParseException
	{
		apiFunction.setupEnv();
		String basePath = "\\\\10.12.235.31\\MPQATeam\\InputReferences\\categorizationInputCSVFiles\\";
		apiFunction.enableQueries(data[2].toString());
		String catTraining = data[3].toString();
		String catCorpus=data[4].toString();
		String catCoh = data[1].toString();
		double catCD = Double.parseDouble(data[1].toString());
		String categorizationID = data[0].toString()+"_Categorization_Request_"+catCD;
		System.out.println(categorizationID);
		apiFunction.createCategorizationRequest(data[2].toString(),catCoh,categorizationID, basePath+catTraining, basePath+catCorpus);
		System.out.println(categorizationID+" : this categorization is created.");
	}
	
	public void RunCategorizationMethod(APIFactory apiFunction, String[] data) throws JSONException, IOException, InterruptedException
	{
		apiFunction.setupEnv();
		double catCD = Double.parseDouble(data[1].toString());
		String categorizationID = data[0].toString()+"_Categorization_Request_"+catCD;
		apiFunction.runCategorizeQuery(data[2].toString(),categorizationID);
		//apiFunction.deleteCategoryID(data[2].toString(),categorizationID);
		apiFunction.function.insertQAScalingInfo(new String[] {data[2].toString(),"0",data[4].toString(),"Categorization",data[3].toString(),apiFunction.function.getDateForSQL(apiFunction.startTime),apiFunction.function.getDateForSQL(apiFunction.endTime),apiFunction.taskTime," "});
		System.out.println(categorizationID+" : this categorization id completed running.");
	}
	
	public void SearchMethod(APIFactory apiFunction, String[] data) throws JSONException, IOException
	{
		apiFunction.setupEnv();
		String searchCoh = data[2].toString();
		apiFunction.createSearchRequest(data[0].toString(),data[1].toString(),searchCoh);
		apiFunction.function.insertQAScalingInfo(new String[] {data[0].toString(),"0",data[4].toString(),"Search",data[3].toString(),apiFunction.function.getDateForSQL(apiFunction.startTime),apiFunction.function.getDateForSQL(apiFunction.endTime),apiFunction.taskTime," "});
	}

}
