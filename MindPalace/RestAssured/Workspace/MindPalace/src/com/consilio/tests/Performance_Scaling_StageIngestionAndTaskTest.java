package com.consilio.tests;

import java.io.IOException;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Parameters;
import org.testng.annotations.Test;

import com.consilio.CAMethods.BaseTest;
import com.consilio.CAMethods.ReusableMethods;
import com.consilio.lib.ExcelUtils;

public class Performance_Scaling_StageIngestionAndTaskTest extends BaseTest{
	
	String threadCount;
	
	@Parameters("count")
	public Performance_Scaling_StageIngestionAndTaskTest(String thCount) {
		this.threadCount = thCount;
	}
		
	@BeforeTest
	public void beforeTest() throws IOException{
		init();
	}	
	
	@Test(dataProvider="dataProvider")
	public void executeTask(String testCaseName, String destinationFileToCompare, String areaId, String conName, String conType, String dbName) throws Exception{
		System.out.println(Thread.currentThread().getId());
		ReusableMethods reusableMethods = new ReusableMethods();
		reusableMethods.createStagingArea(testCaseName, areaId);
		reusableMethods.createConnector(areaId,  conType, conName, testCaseName, dbName, false, "");
		reusableMethods.ingestData(areaId, conName,  conType, testCaseName, dbName);		
		reusableMethods.createTask(areaId);
		reusableMethods.getIngestionExecutionTimes(areaId);
		reusableMethods.getTaskExecutionTimes(areaId);
	}
	
	@AfterTest
	public void afterTest() throws IOException{		
		ReusableMethods reusableMethods = new ReusableMethods();
		reusableMethods.calculateTaskDurationInParallelRuns(threadCount);
		TotalResult.putAll(reusableMethods.scalabilityMetricsResultData);
	}
		
	@DataProvider(name="dataProvider",parallel=true)
	public Object[][] ingestionDataProvider() throws Exception{
		String filePath = getProperty("testRepoPath") + getProperty("testData_Performance");
		Object[][] testObjArray = ExcelUtils.getArrayBasedOnRowCount(filePath, getProperty("testData_Perf_SheetName"), Integer.parseInt(threadCount));				
		return testObjArray;	
	}	
}
