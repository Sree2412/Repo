package com.consilio.tests;

import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;
import com.consilio.CAMethods.APIFactory;
import com.consilio.CAMethods.DataFactory;
import com.consilio.lib.Log;

public class SearchRequest{
	APIFactory apiFunction= new APIFactory();;
	final String dir = System.getProperty("user.dir");
	final String mockPath = "\\\\10.12.235.31\\MPQATeam\\MockReferences\\ConceptualSearch\\";
	final String matrixPath = "\\\\10.12.235.31\\MPQATeam\\MatrixReferences\\ConceptualSearch\\"+"TestOutput_"+apiFunction.function.getDate()+".xlsx";
	HashMap<String,Object[][]> allResults ;
	
	
	@BeforeTest
	public void preRequisite() throws Exception
	{
		apiFunction.setupEnv();
		allResults = new HashMap<String,Object[][]>();
		apiFunction.function.setResultFile(matrixPath,"searchResults");
	}	
	
	@Test(dataProvider = "getConceptSearchData",dataProviderClass=DataFactory.class)
	public void searchRequestMethod(String description, String searchTerm, String searchCoherence, String indexName, String connectorName, String DBName_MP,String testCaseID, String mockFileName, String createIndex, String Iterate) throws Exception
	{
		String searchCoh = searchCoherence;
		Object[] valResult = null;
		double sCDouble = Double.parseDouble(searchCoherence);
		double itera = Double.parseDouble(Iterate);
		int count = (100/(int)(itera*100)) - ((int)(sCDouble*100)/(int)(itera*100))+1;
		Object[][] putResults = new Object[count][];
		String actResult;
		apiFunction.function.setUpLog4j(description);
		Log.startTestCase(description);
		apiFunction.environmentSetup(indexName,createIndex,DBName_MP,connectorName,testCaseID);
	for(int i =0;i<count;i++)
	{
		
		Boolean complete = false;
		DecimalFormat decim = new DecimalFormat("0.00");
		double nwSearchCoh = Double.parseDouble(decim.format(sCDouble+(itera*i)));
		if(nwSearchCoh <= 1.00)
		{
			searchCoh = Double.toString(nwSearchCoh);
			actResult = apiFunction.createSearchRequest(indexName,searchTerm,Double.toString(nwSearchCoh));
			String expResult = apiFunction.function.getJSONStringFromFile(mockPath+mockFileName+"_"+Integer.toString((int)(nwSearchCoh*100))+".json");
			valResult = apiFunction.function.validateSearch(testCaseID,actResult,expResult);
			putResults[i] = new Object[] {searchTerm,searchCoh,valResult[0],valResult[1],valResult[2],valResult[3],valResult[4]};
		}
	}
	
	allResults.put(description,putResults);
		apiFunction.disableQueries(indexName);
		Log.endTestCase(description);
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
			apiFunction.function.setCellData("SearchTerm",row,col++,"bold");
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
					apiFunction.function.setCellData(values[j][0].toString(),intRow,intCol,"justify");
					intCol = 2+j;
					apiFunction.function.setCellData(values[j][1].toString(),intRow,intCol,"bold");
					++intRow;
					apiFunction.function.setCellData("CAAT",intRow,1,"bold");
					apiFunction.function.setCellData(values[j][2].toString(),intRow,intCol,"normal");
					++intRow;
					apiFunction.function.setCellData("MP",intRow,1,"bold");
					apiFunction.function.setCellData(values[j][3].toString(),intRow,intCol,"normal");
					++intRow;
					apiFunction.function.setCellData("Common",intRow,1,"bold");
					apiFunction.function.setCellData(values[j][4].toString(),intRow,intCol,"normal");
					++intRow;
					apiFunction.function.setCellData("Precision(CAAT/MP)",intRow,1,"bold");
					apiFunction.function.setCellData(values[j][5].toString(),intRow,intCol,"normal");
					++intRow;
					apiFunction.function.setCellData("Recall(CAAT/MP)",intRow,1,"bold");
					apiFunction.function.setCellData(values[j][6].toString(),intRow,intCol,"normal");
				}
					row = row+6;
			}
			apiFunction.function.writeExcel();	
		}

			
		}

}
