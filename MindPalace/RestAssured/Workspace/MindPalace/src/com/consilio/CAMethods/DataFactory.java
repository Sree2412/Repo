package com.consilio.CAMethods;

import org.testng.annotations.DataProvider;

import com.mp.lib.ExcelUtils;

public class DataFactory {
	
	@DataProvider
	public static Object[][] getConceptSearchData() throws Exception{
		String filePath = "resources\\testrepo\\TestData_BasicSearch.xlsx";
		Object[][] testObjArray = ExcelUtils.getArray(filePath, "searchCases");
		return testObjArray;		
	}
	
	@DataProvider
	public static Object[][] getCategorizationData() throws Exception{
		String filePath = "resources\\testrepo\\TestData_Categorization.xlsx";
		Object[][] testObjArray = ExcelUtils.getArray(filePath, "categorizeCases");
		return testObjArray;		
	}
	
	@DataProvider
	public static Object[][] getClusterData() throws Exception{
		String filePath = "resources\\testrepo\\TestData_Cluster.xlsx";
		Object[][] testObjArray = ExcelUtils.getArray(filePath, "clusterCases");		
		return testObjArray;		
	}
		
	@DataProvider(parallel=true)
	public static Object[][] getIngestionScalingData() throws Exception{
		//In TestData_ScalingIBMC, IBMC means Ingestion, Build, Master Cluster and Conceptual Near Dupe Cluster
		String filePath = "resources\\testrepo\\TestData_ScalingIBMC.xlsx";
		Object[][] testObjArray = ExcelUtils.getArray(filePath, "datasets");		
		return testObjArray;		
	}
	
	@DataProvider(parallel=true)
	public static Object[][] getSearchScalingData() throws Exception{
		//In TestData_ScalingIBMC, IBMC means Ingestion, Build, Master Cluster and Conceptual Near Dupe Cluster
		String filePath = "resources\\testrepo\\TestData_ScalingSearch.xlsx";
		Object[][] testObjArray = ExcelUtils.getArray(filePath, "scaleSearch");		
		return testObjArray;		
	}
	
	@DataProvider(parallel=true)
	public static Object[][] getCategorizationScalingData() throws Exception{
		//In TestData_ScalingIBMC, IBMC means Ingestion, Build, Master Cluster and Conceptual Near Dupe Cluster
		String filePath = "resources\\testrepo\\TestData_ScalingCategorization.xlsx";
		Object[][] testObjArray = ExcelUtils.getArray(filePath, "scaleCat");		
		return testObjArray;		
	}
	
	@DataProvider
	public static Object[][] getIngestionPerformanceData() throws Exception{
		//In TestData_ScalingIBMC, IBMC means Ingestion, Build, Master Cluster and Conceptual Near Dupe Cluster
		String filePath = "resources\\testrepo\\TestData_PerformanceIBMC.xlsx";
		Object[][] testObjArray = ExcelUtils.getArray(filePath, "datasets");		
		return testObjArray;		
	}
	
	@DataProvider
	public static Object[][] getSearchPerformanceData() throws Exception{
		//In TestData_ScalingIBMC, IBMC means Ingestion, Build, Master Cluster and Conceptual Near Dupe Cluster
		String filePath = "resources\\testrepo\\TestData_PerformanceSearch.xlsx";
		Object[][] testObjArray = ExcelUtils.getArray(filePath, "perfSearch");		
		return testObjArray;		
	}
	
	@DataProvider
	public static Object[][] getCategorizationPerformanceData() throws Exception{
		//In TestData_ScalingIBMC, IBMC means Ingestion, Build, Master Cluster and Conceptual Near Dupe Cluster
		String filePath = "resources\\testrepo\\TestData_PerformanceCategorization.xlsx";
		Object[][] testObjArray = ExcelUtils.getArray(filePath, "perfCat");		
		return testObjArray;		
	}

}
