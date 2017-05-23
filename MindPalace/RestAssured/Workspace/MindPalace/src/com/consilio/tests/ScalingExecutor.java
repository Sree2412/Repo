package com.consilio.tests;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.testng.annotations.Test;
import com.consilio.CAMethods.EnumFactory.guiceStage;
import com.consilio.lib.runTestNGDynamically;

public class ScalingExecutor {

	@Test
	public void runTest()
	{
		int[] abc = new int[] {10,20,50,100};
		for (int i = 0;i<abc.length;i++)
		//use if you 
		{
		List<String> includeMethods = new ArrayList<String>();
		//includeMethods.add("scalingIngestionThis");
		Map<String,String> testngParams = new HashMap<String,String>();
		testngParams.put("count",Integer.toString(abc[i]));
		runTestNGDynamically ts = new runTestNGDynamically();
		ts.setIncludeMethodList(includeMethods);
		ts.setClassName("com.mp.tests.ScalingIndexIBMC");
		ts.setGuiceStage(guiceStage.DEVELOPMENT);
		ts.setSuiteName("Ingestion Building using code");
		ts.setTestName("Ingestion building task");
		ts.setThreadCount(abc[i]);
		ts.runTestNGTest(testngParams);
		}
	}
}
