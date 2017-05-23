package com.consilio.tests;

import java.io.IOException;
import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;
import org.json.JSONException;
import org.json.simple.parser.ParseException;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;
import com.consilio.CAMethods.APIFactory;
import com.consilio.CAMethods.DataFactory;
import com.consilio.lib.Log;

public class CategorizationRequest{
	APIFactory apiFunction = new APIFactory();
	final String mockPath = "\\\\10.12.235.31\\MPQATeam\\MockReferences\\Categorization\\";
	final String matrixPath = "\\\\10.12.235.31\\MPQATeam\\MatrixReferences\\Categorization\\"+"TestOutput_"+apiFunction.function.getDate()+".xlsx";
	final String basePath = "\\\\10.12.235.31\\MPQATeam\\InputReferences\\categorizationInputCSVFiles\\functional\\";
	HashMap<String,Object[][]> allResults ;
	
	
	@BeforeTest
	public void preRequisite() throws Exception
	{
		apiFunction.setupEnv();
		allResults = new HashMap<String,Object[][]>();
		apiFunction.function.setResultFile(matrixPath,"categorizationResults");
	}
	
	@Test(dataProvider="getCategorizationData",dataProviderClass=DataFactory.class)
	public void categorizationTest(String description, String catCoherence, String indexName, String connectorName, String DBName_MP, String testCaseID, String createIndex, String Iterate ) throws JSONException, InterruptedException, IOException, ParseException
	{
		String catTraining = description+"_training.csv";
		String catCorpus=description+"_corpus.csv";
		String mockFileName= testCaseID+"_"+description;
		String catCoh = catCoherence;
		double catCD = Double.parseDouble(catCoherence);
		double catI = Double.parseDouble(Iterate);
		int catCI = (int) (catCD *100);
		int catII = (int) (catI*100);
		int count = (100/catII)-(catCI/catII)+1;
		Object[][] putResults = new Object[count][];
		String actResult;
		apiFunction.function.setUpLog4j(description);
		Log.info("Test case started....");
		apiFunction.environmentSetup(indexName,createIndex,DBName_MP,connectorName,testCaseID);
		
		for (int i =0;i<count;i++)
		{
			apiFunction.enableQueries(indexName);
			DecimalFormat decim = new DecimalFormat("0.00");
			double nwCatCoh = Double.parseDouble(decim.format(catCD+(catI*i)));
			catCoh = Double.toString(nwCatCoh);
			String categorizationID = description+"_Categorization_Request_"+nwCatCoh;		

			apiFunction.createCategorizationRequest(indexName,catCoh,categorizationID, basePath+catTraining, basePath+catCorpus);
			apiFunction.runCategorizeQuery(indexName,categorizationID);
		actResult = apiFunction.getCategorizationResult(indexName,categorizationID);
	/*
		apiFunction.function.copyResultsDirectly("D:\\new\\MockFiles\\Categorization\\"+mockFileName+"_"+Integer.toString((int)(nwCatCoh*100)),actResult);
		*/
		String expResult = apiFunction.function.getJSONStringFromFile(mockPath+mockFileName+"_"+Integer.toString((int)(nwCatCoh*100))+".json");
		Object[] result4Matrix = apiFunction.function.compareCatResult(actResult,expResult,testCaseID,basePath+catCorpus,basePath+catTraining);
		putResults[i] = new Object[result4Matrix.length+1];
		putResults[i][0] = catCoh;
		System.arraycopy(result4Matrix, 0, putResults[i], 1, 5);
		
		apiFunction.deleteCategoryID(indexName,categorizationID);
		}
		allResults.put(description, putResults);
		
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
			apiFunction.function.mergeCellsAddValue(row,(row+3),col,col+13,"Reference to results in \"MP\" or \"CAAT\", lets say a/b/c where a is total documents searched by MP/CAAT, b is total documents matched to expected ground truth and c is total documents ingested in project from expected ground truth. In \"common\" a/b/c, where a is total documents commonly identified by MP and CAAT, b is total documents identified by CAAT and c is total documents ingested in project.");
			row = row+4;
			col=0;
			apiFunction.function.setCellData("Scenario",row,col++,"bold");
			apiFunction.function.setCellData("CoherenceScore",row,col,"bold");

			for(int i =0;i<keySets.size();i++)
			{
				++row;
				Object keys = itr.next();
				Object[][] values = allResults.get(keys);
			
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
					apiFunction.function.setCellData("Total Docs",intRow,1,"bold");
					apiFunction.function.setCellData(values[j][3].toString(),intRow,intCol,"normal");
					++intRow;
					apiFunction.function.setCellData("Precision",intRow,1,"bold");
					apiFunction.function.setCellData(values[j][4].toString(),intRow,intCol,"normal");
					++intRow;
					apiFunction.function.setCellData("Recall",intRow,1,"bold");
					apiFunction.function.setCellData(values[j][5].toString(),intRow,intCol,"normal");
				}
					row = row+6;
			}
			apiFunction.function.writeExcel();	
		}
	}

}
