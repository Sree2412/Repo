package com.consilio.tests;

import java.io.IOException;

import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

import com.consilio.CAMethods.ReusableMethods;
import com.consilio.lib.ExcelUtils;

public class Functional_TextualNearDupeTest extends ReusableMethods{
	
	@BeforeTest
	public void beforeTest() throws IOException{
		init();
	}
	
	@Test(dataProvider="getNearDupData")
	public void textualNearDupeTest(String testCaseName, String destinationFileToCompare, String areaId, String conName, String conType, String dbName) throws Exception{
		createStagingArea(testCaseName, areaId);
		createConnector(areaId, conType, conName, testCaseName, dbName, false, "");
		ingestData(areaId, conName, conType, testCaseName, dbName);
		createTask(areaId);
		exportStagingArea(areaId, "TextualNearDupe", "");
		validateNearDupeResults(areaId,testCaseName, destinationFileToCompare);	
	}	
	
	@AfterTest
	public void afterTest() throws IOException{
		ExcelUtils.writeMetricsToExcel(currenttestCaseName, "metadata", metadataMetricsResultData);
	}
	
	@DataProvider
	public Object[][] getNearDupData() throws Exception{
		String filePath = getProperty("testRepoPath") + getProperty("testData_NearDupe");
		Object[][] testObjArray = ExcelUtils.getArray(filePath, getProperty("testData_ND_SheetName"));		
		return testObjArray;		
	}	
}
