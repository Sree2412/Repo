package com.consilio.tests;

import java.io.IOException;

import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

import com.consilio.CAMethods.ReusableMethods;
import com.consilio.lib.ExcelUtils;

public class Functional_EmailThreadingTest extends ReusableMethods {
	
	@BeforeTest
	public void beforeTest() throws IOException{
		init();
	}
	
	@Test(dataProvider="getEmailThreadingData")
	public void emailThreadingTest(String testCaseName, String destinationFileToCompare, String areaId, String conName, String conType, String dbName, String Query1, String Query2, String Query3, String Query4) throws Exception{
		createStagingArea(testCaseName, areaId);
		createConnector(areaId, conType, conName, testCaseName, dbName, false, "");
		ingestData(areaId, conName, conType, testCaseName, dbName);
		createTask(areaId);
		exportStagingArea(areaId, "EmailThreading", "");	
		validateEmailThreadResults(areaId,testCaseName, destinationFileToCompare, false);		
	}
	
	@AfterTest
	public void afterTest() throws IOException{
		ExcelUtils.writeMetricsToExcel(currenttestCaseName, "metadata", metadataMetricsResultData);
	}
	
	@DataProvider
	public Object[][] getEmailThreadingData() throws Exception{
		String filePath = getProperty("testRepoPath") + getProperty("testData_EmailThreading");
		Object[][] testObjArray = ExcelUtils.getArray(filePath, getProperty("testData_ET_SheetName"));		
		return testObjArray;		
	}
}
