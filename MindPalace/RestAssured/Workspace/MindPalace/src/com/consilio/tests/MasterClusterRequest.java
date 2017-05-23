package com.consilio.tests;

import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;

import org.json.JSONException;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;

import com.consilio.CAMethods.APIFactory;
import com.consilio.CAMethods.DataFactory;
import com.mp.lib.Log;

public class MasterClusterRequest {
	APIFactory apiFunction = new APIFactory();
	final String dir = System.getProperty("user.dir");
	final String mockPath = "\\\\10.12.235.31\\MPQATeam\\MockReferences\\MasterCluster\\";
	final String matrixPath = "\\\\10.12.235.31\\MPQATeam\\MatrixReferences\\MasterCluster\\"+"TestOutput_"+apiFunction.function.getDate()+".xlsx";
	HashMap<String,String[][]> allResults ;
	
	@BeforeTest
	public void preRequisite() throws Exception
	{
		apiFunction.setupEnv();
		allResults = new HashMap<String,String[][]>();
		apiFunction.function.setResultFile(matrixPath,"MasterClusterResults");
	}
	
	@Test(dataProvider="getClusterData",dataProviderClass=DataFactory.class)	
	public void masterClusterRequestMethod(String description,String indexName,String DBName_MP,String ConnectorName, String testCaseID) throws JSONException, InterruptedException, IOException
	{
		String actResult;
		String clusterID = "MasterCluster-"+indexName;
		apiFunction.function.setUpLog4j(description);
		Log.startTestCase(description);
		apiFunction.environmentSetup(indexName,"yes",DBName_MP,ConnectorName,testCaseID);
		apiFunction.createClusterMigrationplus(indexName, clusterID);
		apiFunction.runClusterQuery(indexName,clusterID,"MasterCluster");
		actResult = apiFunction.getClusterResults(indexName,clusterID);
		String expResult = apiFunction.function.getJSONStringFromFile(mockPath+"MasterCluster-"+indexName+".json");
		//apiFunction.function.copyResultsDirectly(dir+"\\test\\"+clusterID,actResult);
		apiFunction.function.compareClusterResults(expResult,actResult,testCaseID);
		allResults.put(description, apiFunction.function.compareClusterResults(expResult,actResult,testCaseID));
		apiFunction.disableQueries(indexName);
	}
	

	@AfterTest
	public void postRequisite() throws Exception
	{
		int row =0;
		int col=0;
		Set<String> keySets = allResults.keySet();
		Iterator<String> itr = keySets.iterator();
		if(allResults.size() > 0)
		{
			apiFunction.function.mergeCellsAddValue(row,(row+3),col,col+13,"Reference to results in \"MP\" or \"CAAT\".");
			row = row+4;
			col=0;
			apiFunction.function.setCellData("Scenario",row,col++,"bold");
			apiFunction.function.setCellData("ClusterID",row,col,"bold");

			for(int i =0;i<keySets.size();i++)
			{
				++row;
				Object keys = itr.next();
				String[][] values = allResults.get(keys);
			
				for(int j =0;j<values.length;j++)
				{
					int intRow =row;
					int intCol = 0;
					apiFunction.function.setCellData(keys.toString(),intRow,intCol,"justify");
					intCol = 2+j;
					apiFunction.function.setCellData(values[j][0].toString(),intRow,intCol,"bold");
					++intRow;
					apiFunction.function.setCellData("CAAT",intRow,1,"bold");
					apiFunction.function.setCellData(values[j][1].toString(),intRow,intCol,"normal");
					++intRow;
					apiFunction.function.setCellData("MP",intRow,1,"bold");
					apiFunction.function.setCellData(values[j][2].toString(),intRow,intCol,"normal");
					++intRow;
					apiFunction.function.setCellData("Precision(CAAT/MP)",intRow,1,"bold");
					apiFunction.function.setCellData(values[j][3].toString(),intRow,intCol,"normal");
					++intRow;
					apiFunction.function.setCellData("Recall(CAAT/MP)",intRow,1,"bold");
					apiFunction.function.setCellData(values[j][4].toString(),intRow,intCol,"normal");
				}
					row = row+5;
			}
			apiFunction.function.writeExcel();	
		}
	}

}
