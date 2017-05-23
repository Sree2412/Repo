package com.consilio.tests;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.testng.annotations.AfterTest;
import org.testng.annotations.Test;

import com.consilio.CAMethods.BaseTest;
import com.consilio.CAMethods.EnumFactory.guiceStage;
import com.consilio.lib.ExcelUtils;
import com.consilio.lib.runTestNGDynamically;

public class Performance_ScalingExecutor_StagingIngestionTest extends BaseTest{

	@Test
	public void runTest() {
		int[] abc = new int[] { 10, 50, 100};
		
		for (int i = 0; i < abc.length; i++) {			
			List<String> includeMethods = new ArrayList<String>();			
			Map<String, String> testngParams = new HashMap<String, String>();
			testngParams.put("count", Integer.toString(abc[i]));
			runTestNGDynamically ts = new runTestNGDynamically();
			ts.setIncludeMethodList(includeMethods);
			ts.setClassName("com.consilio.tests.Performance_Scaling_StageIngestionTest");
			ts.setGuiceStage(guiceStage.DEVELOPMENT);
			ts.setSuiteName("Performance_Staging");
			ts.setTestName("Performance_Staging_Task");
			ts.setThreadCount(abc[i]);
			ts.runTestNGTest(testngParams);
		}
	}	
	
	@AfterTest
	public void afterTest() throws FileNotFoundException, IOException{
		ExcelUtils.writeMetricsToExcel("PerformanceStageIngestionScaling", "scalability", TotalResult);
	}
}
