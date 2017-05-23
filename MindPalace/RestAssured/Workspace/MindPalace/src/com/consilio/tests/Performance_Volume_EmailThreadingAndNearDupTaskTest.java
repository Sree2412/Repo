package com.consilio.tests;

import java.io.IOException;

import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

import com.consilio.CAMethods.ReusableMethods;
import com.consilio.lib.ExcelUtils;

public class Performance_Volume_EmailThreadingAndNearDupTaskTest extends ReusableMethods{

	@BeforeTest
	public void beforeTest() throws IOException{
		init();
	}
	
	@Test(dataProvider="getEmailThreadingData")
	public void emailThreadingTest(String testCaseName, String destinationFileToCompare, String areaId, String conName, String conType, String dbName) throws Exception{
		createStagingArea(testCaseName, areaId);
		createConnector(areaId, conType, conName, testCaseName, dbName, false, "");
		ingestData(areaId, conName, conType, testCaseName, dbName);
		createTask(areaId);
		getIngestionExecutionTimes(areaId);
		getTaskExecutionTimes(areaId);
		calculateTaskDurationInParallelRuns("0");		
	}
	
	@AfterTest
	public void afterTest() throws IOException{
		ExcelUtils.writeMetricsToExcel("Performance_StageVolume", "scalability", scalabilityMetricsResultData);
	}
	
	@DataProvider
	public Object[][] getEmailThreadingData() throws Exception{
		String filePath = getProperty("testRepoPath") + getProperty("testData_Performance");
		Object[][] testObjArray = ExcelUtils.getArray(filePath, getProperty("testData_Perf_Vol_SheetName"));		
		return testObjArray;		
	}
}
