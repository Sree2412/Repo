package com.consilio.tests;

import java.io.IOException;
import org.json.JSONException;
import org.json.simple.parser.ParseException;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Parameters;
import org.testng.annotations.Test;
import com.consilio.CAMethods.APIFactory;
import com.consilio.CAMethods.DataFactory;
import com.consilio.CAMethods.MethodFactory;


public class ScalingIndexIBMC {
	APIFactory af = new APIFactory();
	final String dir = System.getProperty("user.dir");
	private String threadCount;
	private String taskID;
	private long startTime;
	private long endTime;
	
	
	@BeforeClass
	@Parameters("count")
	public void setUp(String count) throws Exception
	{
		threadCount = count;
		taskID = "ScalingTest-"+af.function.getDate();
		startTime = af.function.getTimeNow();
		af.function.insertQAScalingTasks(new String[] {taskID,"21 02 2017 execution - Performance Scaling",af.function.getDateForSQL(startTime),af.function.getDateForSQL(startTime)});
		af.function.setUpLog4j("Scaling-Test");		
	}
	
	@Test(dataProvider = "getIngestionScalingData", dataProviderClass=DataFactory.class,priority=0)
	public void scalingCleanUp(String indexName,String connectorName,String dbName,String testCaseID) throws IOException, JSONException, InterruptedException, ParseException
	{
		new MethodFactory().scalingCleanUpMethod(new APIFactory(),new String[] {indexName,connectorName,dbName,testCaseID});
	}
	
	@Test(dataProvider = "getIngestionScalingData", dataProviderClass=DataFactory.class,priority=1)
	public void ingestionScaling(String indexName,String connectorName,String dbName,String testCaseID) throws IOException, JSONException, InterruptedException, ParseException
	{
		new MethodFactory().ingestionScalingMethod(new APIFactory(),new String[] {indexName,connectorName,dbName,testCaseID,threadCount,taskID});
	}
	
	@Test(dataProvider = "getIngestionScalingData", dataProviderClass=DataFactory.class,priority=2)
	public void buildScaling(String indexName,String connectorName,String dbName,String testCaseID) throws IOException, JSONException, InterruptedException, ParseException
	{
		new MethodFactory().buildScalingMethod(new APIFactory(),new String[] {indexName,connectorName,dbName,testCaseID,threadCount,taskID});
	}
	
	@Test(dataProvider = "getIngestionScalingData", dataProviderClass=DataFactory.class,priority=3)
	public void masterClusterScaling(String indexName,String connectorName,String dbName,String testCaseID) throws IOException, JSONException, InterruptedException, ParseException
	{
		new MethodFactory().masterClusterScalingMethod(new APIFactory(),new String[] {indexName,connectorName,dbName,testCaseID,threadCount,taskID});
	}
	
	@Test(dataProvider = "getIngestionScalingData", dataProviderClass=DataFactory.class,priority=4)
	public void conceptualNearDupeScaling(String indexName,String connectorName,String dbName,String testCaseID) throws IOException, JSONException, InterruptedException, ParseException
	{
		new MethodFactory().conceptualNearDupeScalingMethod(new APIFactory(),new String[] {indexName,connectorName,dbName,testCaseID,threadCount,taskID});
		//new MethodFactory().postScalingCleanUpMethod(new APIFactory(),new String[] {indexName,connectorName,dbName,testCaseID,threadCount,taskID});
	}
	
	@Test(dataProvider = "getSearchScalingData", dataProviderClass=DataFactory.class,priority=5)
	public void ConceptualSearchScaling(String description,String searchTerm,String searchCoh,String indexName) throws JSONException, IOException, InterruptedException
	{
		new MethodFactory().SearchMethod(new APIFactory(), new String[] {indexName,searchTerm,searchCoh,threadCount,taskID});
	}
	
	@Test(dataProvider = "getCategorizationScalingData", dataProviderClass=DataFactory.class,priority=6)
	public void ConceptualCategorizationScaling(String description,String catCoh,String indexName,String trainingPath,String corpusPath) throws JSONException, IOException, InterruptedException, ParseException
	{
		new MethodFactory().CreateCategorizationMethod(new APIFactory(), new String[] {description,catCoh,indexName,trainingPath,corpusPath});
		new MethodFactory().RunCategorizationMethod(new APIFactory(), new String[] {description,catCoh,indexName,threadCount,taskID});
	}
	
	@Test(dataProvider = "getIngestionScalingData", dataProviderClass=DataFactory.class,priority=7)
	public void postCleanUpMethod(String description,String catCoh,String indexName,String trainingPath,String corpusPath) throws JSONException, IOException, InterruptedException
	{
		new MethodFactory().postScalingCleanUpMethod(new APIFactory(),new String[] {indexName});
	}
	
	@AfterClass
	public void closingUpdate()
	{	
		endTime = af.function.getTimeNow();
		af.function.updateQAScalingTasks(new String[] {taskID,"21 02 2017 execution - Performance Scaling",af.function.getDateForSQL(startTime),af.function.getDateForSQL(endTime)});
	}
	
	
}
