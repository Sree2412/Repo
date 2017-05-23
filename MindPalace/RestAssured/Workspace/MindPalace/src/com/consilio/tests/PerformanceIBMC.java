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

public class PerformanceIBMC {
	
	APIFactory af = new APIFactory();
	final String dir = System.getProperty("user.dir");
	private String threadCount = "1";
	private String taskID;
	private long startTime;
	private long endTime;
	
	@BeforeClass
	public void setUp() throws Exception
	{
		taskID = "PerformanceTest-UAT-"+af.function.getDate();
		startTime = af.function.getTimeNow();
		af.function.insertQAScalingTasks(new String[] {taskID,"Performance Test for 100K categorization: Defect ID: 2595",af.function.getDateForSQL(startTime),af.function.getDateForSQL(startTime)});
		af.function.setUpLog4j("Performance-Test");		
	}
	
	@Test(dataProvider = "getIngestionPerformanceData", dataProviderClass=DataFactory.class,priority=0)
	public void scalingCleanUp(String indexName,String connectorName,String dbName,String testCaseID,String doNotUse) throws IOException, JSONException, InterruptedException, ParseException
	{
		new MethodFactory().scalingCleanUpMethod(new APIFactory(),new String[] {indexName,connectorName,dbName,testCaseID});
	}
	
	@Test(dataProvider = "getIngestionPerformanceData", dataProviderClass=DataFactory.class,priority=1)
	public void ingestionScaling(String indexName,String connectorName,String dbName,String testCaseID,String documentCount) throws IOException, JSONException, InterruptedException, ParseException
	{
		new MethodFactory().ingestionPerformanceMethod(new APIFactory(),new String[] {indexName,connectorName,dbName,testCaseID,threadCount,taskID,documentCount});
	}
	
	@Test(dataProvider = "getIngestionPerformanceData", dataProviderClass=DataFactory.class,priority=2)
	public void buildScaling(String indexName,String connectorName,String dbName,String testCaseID,String documentCount) throws IOException, JSONException, InterruptedException, ParseException
	{
		new MethodFactory().buildScalingMethod(new APIFactory(),new String[] {indexName,connectorName,dbName,testCaseID,threadCount,taskID});
	}
	
	
	@Test(dataProvider = "getIngestionPerformanceData", dataProviderClass=DataFactory.class,priority=3)
	public void masterClusterScaling(String indexName,String connectorName,String dbName,String testCaseID,String documentCount) throws IOException, JSONException, InterruptedException, ParseException
	{
		new MethodFactory().masterClusterScalingMethod(new APIFactory(),new String[] {indexName,connectorName,dbName,testCaseID,threadCount,taskID});
	}
	
	@Test(dataProvider = "getIngestionPerformanceData", dataProviderClass=DataFactory.class,priority=4)
	public void conceptualNearDupeScaling(String indexName,String connectorName,String dbName,String testCaseID,String documentCount) throws IOException, JSONException, InterruptedException, ParseException
	{
		new MethodFactory().conceptualNearDupeScalingMethod(new APIFactory(),new String[] {indexName,connectorName,dbName,testCaseID,threadCount,taskID});
	}
		
	@Test(dataProvider = "getSearchPerformanceData", dataProviderClass=DataFactory.class,priority=5)
	public void ConceptualSearchScaling(String description,String searchTerm,String searchCoh,String indexName) throws JSONException, IOException, InterruptedException
	{
		new MethodFactory().SearchMethod(new APIFactory(), new String[] {indexName,searchTerm,searchCoh,threadCount,taskID});
	}
	
	@Test(dataProvider = "getCategorizationPerformanceData", dataProviderClass=DataFactory.class,priority=6)
	public void ConceptualCategorizationScaling(String description,String catCoh,String indexName,String trainingPath,String corpusPath) throws JSONException, IOException, InterruptedException, ParseException
	{
		new MethodFactory().CreateCategorizationMethod(new APIFactory(), new String[] {description,catCoh,indexName,trainingPath,corpusPath});
		new MethodFactory().RunCategorizationMethod(new APIFactory(), new String[] {description,catCoh,indexName,threadCount,taskID});
	}
	
	@Test(dataProvider = "getIngestionPerformanceData", dataProviderClass=DataFactory.class,priority=7)
	public void postCleanUpMethod(String description,String catCoh,String indexName,String trainingPath,String corpusPath) throws JSONException, IOException, InterruptedException
	{
		new MethodFactory().postScalingCleanUpMethod(new APIFactory(),new String[] {indexName});
	}
	
	@AfterClass
	public void closingUpdate()
	{
		endTime = af.function.getTimeNow();
		af.function.updateQAScalingTasks(new String[] {taskID,"Performance Test for 100K categorization: Defect ID: 2595",af.function.getDateForSQL(startTime),af.function.getDateForSQL(endTime)});
	}
	
}
