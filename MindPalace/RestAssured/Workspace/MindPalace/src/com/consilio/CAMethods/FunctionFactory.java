package com.consilio.CAMethods;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.log4j.PropertyConfigurator;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONException;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.testng.asserts.Assertion;

import com.consilio.lib.Log;
import com.consilio.lib.Utilities;

public class FunctionFactory extends Utilities{
	XSSFWorkbook outputWorkbook;
	XSSFSheet outputSheet;
	FileOutputStream fileout;
	private Assertion ha = new Assertion();
	
	public Object[] getSearchArray(String searchTerm)
	{
		if (searchTerm.length() <= 0)
		{
			Log.info("The search term \""+searchTerm+"\" requested for search is too short, please provide a valid search term.");
			ha.assertTrue(searchTerm.length()>0,"The search term \""+searchTerm+"\" requested for search is too short, please provide a valid search term.");
		}
		Object[] obj = new Object[searchTerm.trim().length()];
		for(int i =0;i<searchTerm.trim().length();i++)
		{
			obj[i]=(int)searchTerm.trim().charAt(i);
		}
		return obj;
	}
	
	public Object[] validateSearch(String testCaseID, String actResult,String expResult) throws Exception
	{
		Map<Integer,Integer> gTValue;
		Map<Integer,String> mapValue;
		List<Integer> mpGT = new ArrayList<Integer>();
		List<Integer> caatGT = new ArrayList<Integer>();
		int common = 0;
		gTValue = getGroundTruth(testCaseID);
		mapValue = compareSearchResult(expResult,actResult);
		Set<Integer> key = mapValue.keySet();
		@SuppressWarnings("rawtypes")
		Iterator itr = key.iterator();
		for(int i=0;i<mapValue.size();i++)
		{
			Object valueObj = itr.next();
			if(mapValue.get(valueObj) == "matched")
			{common++;
				mpGT.add(gTValue.get(valueObj));
				caatGT.add(gTValue.get(valueObj));
			}
			if(mapValue.get(valueObj) == "mpMatched")
			{
				mpGT.add(gTValue.get(valueObj));
			}
			if(mapValue.get(valueObj) == "caatMatched")
			{
				caatGT.add(gTValue.get(valueObj));
			}	
		}
	
		int caatHigh =0;
		int mpHigh =0;
		int ground_truth =0;
		int current =0;
		
		Set<Integer> gTruthKeys = new HashSet<Integer> (caatGT);
		for(Integer temp : gTruthKeys)
		{
			current = Collections.frequency(caatGT, temp);
			if(caatHigh< current)
			{
				caatHigh = current;
				ground_truth = temp;
			}
		}
		mpHigh = Collections.frequency(mpGT, ground_truth);
		
		
		List<Integer> tGTruthKeys = new ArrayList<Integer>();
		Set<Integer> totalKey = gTValue.keySet();
		Iterator<Integer> totalItr = totalKey.iterator();
		for(int total =0;total<gTValue.size();total++)
		{
			tGTruthKeys.add(gTValue.get(totalItr.next()));
		}
		int caatMost = Collections.frequency(tGTruthKeys, ground_truth);
		DecimalFormat df  = new DecimalFormat("0.00");
		String returnObj0 = Integer.toString(caatGT.size())+"/"+Integer.toString(caatHigh)+"/"+Integer.toString(caatMost); //caat results
		String returnObj3 = division(caatHigh,caatGT.size())+"/"+division(mpHigh,mpGT.size()); //precision values
		String returnObj1 = Integer.toString(mpGT.size())+"/"+Integer.toString(mpHigh)+"/"+Integer.toString(caatMost);//mp results
		String returnObj4 = division(caatHigh,caatMost)+"/"+division(mpHigh,caatMost); //recall values
		String returnObj2 = Integer.toString(common);
		return new Object[]{returnObj0,returnObj1,returnObj2,returnObj3,returnObj4};
		
	}
	
	public Map<Integer,String> compareSearchResult(String caatJSON,String mpJSON) throws ParseException, JSONException
		{
			List<Integer> caatItemIds = getSearchItemIds(caatJSON);
			List<Integer> mpItemIds = getSearchItemIds(mpJSON);
			Map<Integer,String> result = new HashMap<Integer,String>();
			int i = 0;
			int j = 0;
			try{
			if(caatItemIds.size() > 0 && mpItemIds.size() > 0)
			{
				for(;i<caatItemIds.size();)
				{
					for(;j<mpItemIds.size();)
					{
					
						if(caatItemIds.get(i) == mpItemIds.get(j))
						{
							 result.put(caatItemIds.get(i), "matched");
							 //.add(caatItemIds.get(i),"matched");
							++i;
							++j;
							break;
						}
						else if(caatItemIds.get(i) < mpItemIds.get(j))
						{
							result.put(caatItemIds.get(i),"caatMatched");
							++i;
							break;
						}
						else if(caatItemIds.get(i) > mpItemIds.get(j))
						{
							result.put(mpItemIds.get(j),"mpMatched");
							++j;
							continue;
						}
						result.put(mpItemIds.get(j),"mpMatched");
						++j;
						continue;
					}
					if(j==mpItemIds.size())
					{
						result.put(caatItemIds.get(i),"caatMatched");
						++i;
					}
				}
			}
			else if(caatItemIds.size() > 0 && mpItemIds.isEmpty())
			{
				for(int k = 0; k<caatItemIds.size();k++)
				{
					result.put(caatItemIds.get(k), "caatMatched");
				}
			}
			else if(caatItemIds.isEmpty() && mpItemIds.size() > 0)
			{
				for(int k = 0; k<mpItemIds.size();k++)
				{
					result.put(mpItemIds.get(k), "mpMatched");
				}
			}
			}
			catch(OutOfMemoryError e)
			{
			 System.out.println("The heap memory is out, and proceed further... /n error returned is: "+e);
			}
			return result;
		}
	
	public String[] getDataFromCSV(String filePath)
	{		
		BufferedReader br;
		
		String[] result=null;
		String[] newResult;
		try {
	        br = new BufferedReader( new FileReader(filePath));
	        String line = null;
	        @SuppressWarnings("unused")
			int lineNumber = 0;
	       
	   while((line = br.readLine()) != null) {
		   String[] tempResult = line.split(",");
		   if(result == null)
		   {
			newResult = Arrays.copyOf(tempResult, tempResult.length);   
		   }else
		   {
		  newResult = ArrayUtils.addAll(result, tempResult);
		   }
		  result = Arrays.copyOf(newResult, newResult.length);
		   }
		}
	    catch (FileNotFoundException e) {
	    	//Log.info("");
	        e.printStackTrace();
	    } catch (IOException e) {
	        e.printStackTrace();
	    }
		return result;
		
	}
	
	public JSONArray getDataFromCSVCorpus(String filePath) throws ParseException
	{		
		BufferedReader br;
		
		String[] result=null;
		String[] newResult;
		try {
	        br = new BufferedReader( new FileReader(filePath));
	        String line = null;
	        @SuppressWarnings("unused")
			int lineNumber = 0;
	       
	   while((line = br.readLine()) != null) {
		   String[] tempResult = line.split(",");
		   if(result == null)
		   {
			newResult = Arrays.copyOf(tempResult, tempResult.length);   
		   }else
		   {
		  newResult = ArrayUtils.addAll(result, tempResult);
		   }
		  result = Arrays.copyOf(newResult, newResult.length);
		   }
		}
	    catch (FileNotFoundException e) {
	    	//Log.info("");
	        e.printStackTrace();
	    } catch (IOException e) {
	        e.printStackTrace();
	    }
		
		JSONParser jp = new JSONParser();
		Object jObject = (Object) jp.parse(Arrays.toString(result));
		JSONArray returnArray = (JSONArray) jObject;
		return returnArray;
		
	}
	
	
	@SuppressWarnings("unchecked")
	public JSONArray getJSONforConceptExample(String[] trainingArray)
	 {
		JSONArray allExamples = new JSONArray();
			for(int i = 0;i<trainingArray.length;i++)
			{
		 		JSONObject example = new JSONObject();
		 		JSONArray eachItemTemp = new JSONArray();
		 		JSONObject item = new JSONObject();
		 		item.put("itemId", trainingArray[i].trim());
		 		eachItemTemp.add(item);
		 		example.put("concept", eachItemTemp);
		 		example.put("category", "1");
		 		example.put("exampleItemId",trainingArray[i].trim());
		 		allExamples.add(example);
			}
		return allExamples;
	 }
	
	
	public String[] compareCatResult(String expResult, String actResult, String testCaseID, String corpusInputPath,String trainingInputPath) throws ParseException, JSONException
	{
		String[] corpus = getDataFromCSV(corpusInputPath);
		String[] training = getDataFromCSV(trainingInputPath);
		List<Integer> trainingGT = new ArrayList<Integer>();
		DecimalFormat df = new DecimalFormat("0.00");
		Map<Integer,Integer> gTValue = getGroundTruth(testCaseID);
		for(int i=0;i<training.length;i++)
		{
			trainingGT.add(gTValue.get(Integer.parseInt(training[i])));
			
		}
		Set<Integer> uniqueCategoryTraining = new HashSet<Integer> (trainingGT);
		HashMap<Integer,Object[]> caatItemIds = getCategoryValues(expResult);
		HashMap<Integer,Object[]> mpItemIds = getCategoryValues(actResult);
		int caatResults[] = categoryMatchResults(gTValue,caatItemIds,uniqueCategoryTraining);
		int mpResults[] = categoryMatchResults(gTValue,mpItemIds,uniqueCategoryTraining);
		String caatOut = Integer.toString(caatResults[0]+caatResults[1]+caatResults[2])+"/"+Integer.toString(caatResults[0])+"/"+Integer.toString(caatResults[2])+"/"+Integer.toString(caatResults[3]);
		String mpOut = Integer.toString(mpResults[0]+mpResults[1]+mpResults[2])+"/"+Integer.toString(mpResults[0])+"/"+Integer.toString(mpResults[2])+"/"+Integer.toString(mpResults[3]);
		String totalDocs = Integer.toString(corpus.length);
		String precision = division(caatResults[0],(caatResults[0]+caatResults[1]))+"/"+division(mpResults[0],(mpResults[0]+mpResults[1]));
		String recall = division(caatResults[0],(caatResults[0]+caatResults[1]+caatResults[3]))+"/"+division(mpResults[0],(mpResults[0]+mpResults[1]+mpResults[3]));
		return new String[] {caatOut,mpOut,totalDocs,precision,recall};
	}
	
	private int[] categoryMatchResults(Map<Integer,Integer> groundTruth, HashMap<Integer,Object[]> ItemData,Set<Integer> trainingUniqueSet)
	{
		Map<Integer,Integer> gt = groundTruth;
		HashMap<Integer,Object[]> id = ItemData;
		Set<Integer> trainUniqueSet = trainingUniqueSet;
		Set<Integer> idKey = id.keySet();
		Iterator<Integer> itr = idKey.iterator();
		int categorizedMatch = 0;
		int categorizedUnmatch = 0;
		int shouldnotcategorized=0;
		int uncategorizedUnmatch = 0;
		int uncategorizedmatch =0;
		for (int i = 0; i<id.size();i++)
		{
			int docID = itr.next();
			Object[] docParams = id.get(docID);
			int exampleID = (int) docParams[0];
			if(exampleID > 0)
			{
				if(gt.get(docID).equals(gt.get(exampleID)))
				{
					categorizedMatch++;
				}
				else
				{
					if((trainUniqueSet.contains(gt.get(docID))))
					{
						categorizedUnmatch++;
					}
					else
					{
						shouldnotcategorized++;
					}
				}
			}
			else
			{
				if(!(trainUniqueSet.contains(gt.get(docID))))
				{
					uncategorizedmatch++;
				}
				else
				{
					uncategorizedUnmatch++;
				}
				
			}
		}
		return new int[] {categorizedMatch,categorizedUnmatch,shouldnotcategorized,uncategorizedUnmatch,uncategorizedmatch};
	}
	
		public void copyResultsDirectly(String outputURL,String result) throws FileNotFoundException, UnsupportedEncodingException
	{
		String fileName = outputURL+".json";
		PrintWriter writer = new PrintWriter(fileName,"UTF-8");
		writer.println(result);
		writer.close();
	}
		
	public void getSubClusters(org.json.simple.JSONObject expResult, HashMap<Integer,HashMap<Integer,Double>> itemsResult, HashMap<Integer,List<Integer>> clusterLevel,int parentClusterID) throws ParseException
	{int clusterId;
	HashMap<Integer,Double> itemSet = new HashMap<Integer,Double>();
	
	
		clusterId = Integer.parseInt(expResult.get("clusterId").toString());
		if(expResult.get("unclustered").equals(true))
		{
			clusterId = 999998;
		}
		JSONArray itemsList =(JSONArray) expResult.get("items");
		JSONArray subclustersList = (JSONArray) expResult.get("subclusters");
		
			if(!(clusterLevel.containsKey(parentClusterID)))
			{
				List<Integer> existingValue = new ArrayList<Integer>();
				existingValue.add(clusterId);
				clusterLevel.put(parentClusterID, existingValue);
			}
			else
			{
				List<Integer> existingValue = clusterLevel.get(parentClusterID);
				existingValue.add(clusterId);
				clusterLevel.replace(parentClusterID, existingValue);
			}
			
		if (itemsList.size() > 0)
		{
			@SuppressWarnings("unchecked")
			Iterator<String> itemsItr = itemsList.iterator();
			for (int i =0;i<itemsList.size();i++)
			{
				Object itemValue = itemsItr.next();
				org.json.simple.JSONObject itemsObj = (org.json.simple.JSONObject) itemValue;
				int itemId = Integer.parseInt(itemsObj.get("itemId").toString());
				double score = Double.parseDouble(itemsObj.get("score").toString());
				itemSet.put(itemId,score);
			}
			itemsResult.put(clusterId,itemSet);
		}
		else
		{		
		itemsResult.put(clusterId, itemSet);
		}
		
		JSONArray subclustersArray = (JSONArray) subclustersList;
		if(subclustersArray.size()>0)
		{
			@SuppressWarnings("unchecked")
			Iterator<String> subclustersItr = subclustersArray.iterator();
			for(int i =0;i<subclustersArray.size();i++)
			{
				Object clusterValue = subclustersItr.next(); 
				org.json.simple.JSONObject clusterObj = (org.json.simple.JSONObject) clusterValue;		
				getSubClusters(clusterObj,itemsResult,clusterLevel,clusterId);
			}
		}
	}
	
	public Object[] getClusters(String expResult)
	{
		/*
		 * HashMap<Integer,HashMap<Integer,Double>> itemsResult = new HashMap<>();
		HashMap<Integer,Integer> clusterLevel = new HashMap<Integer,Integer>();
		 */
		HashMap<Integer,HashMap<Integer,Double>> itemsResult = new HashMap<>();
		HashMap<Integer,List<Integer>> clusterLevel = new HashMap<Integer,List<Integer>>();
		
		JSONParser jp = new JSONParser();
		org.json.simple.JSONObject jObj = null;
		try {
			jObj = (org.json.simple.JSONObject) jp.parse(expResult);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		org.json.simple.JSONObject expResultCluster = (org.json.simple.JSONObject) jObj.get("cluster");
		
		try {
			getSubClusters(expResultCluster,itemsResult,clusterLevel,999999);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return new Object[]{itemsResult,clusterLevel};
	}
	
	public String[][] compareClusterResults(String expResult,String actResult,String testCaseID)
	{
		String[][] returnResult;
		HashMap<Integer,Integer[]> expResultMap = getClusterResults(expResult,testCaseID); 
		HashMap<Integer,Integer[]> actResultMap = getClusterResults(actResult,testCaseID);
		Set<Integer> expKeys = expResultMap.keySet();
		Set<Integer> actKeys = actResultMap.keySet();
		int loopInitializer = 0;
		Iterator<Integer> itr;
		
		if(expKeys.size()> actKeys.size())
		{
			loopInitializer = expKeys.size();
			itr = expKeys.iterator();
		}else
		{
			loopInitializer = actKeys.size();
			itr = actKeys.iterator();
		}
		
		returnResult = new String[loopInitializer][5];
		
		DecimalFormat df = new DecimalFormat("0.00");
		for(int i = 0;i<loopInitializer;i++)
		{
			String value = "";
			String precision = "";
			String recall = "";
			String stringObject1 = "";
			String stringObject2 = "";
			String stringObject3 = "";
			String stringObject4 = "";
			
			int clusterId = itr.next();
			if(expResultMap.containsKey(clusterId))
			{
				Integer[] expValues = expResultMap.get(clusterId);
				value = expValues[0].toString()+"/"+expValues[1].toString()+"/"+expValues[2].toString();
				precision = division(expValues[0],expValues[1]);
				recall = division(expValues[0],expValues[2]);
			stringObject1 = value;	
			stringObject3 = precision;
			stringObject4 = recall;
			}
			else
			{
				value="0/0/0";
				precision = "NA";
				recall = "NA";
				stringObject1 = value;
				stringObject3 = precision;
				stringObject4 = recall;
			}
			
			if(actResultMap.containsKey(clusterId))
			{
				Integer[] actValues = expResultMap.get(clusterId);
				value = actValues[0].toString()+"/"+actValues[1].toString()+"/"+actValues[2].toString();
				precision = division(actValues[0],actValues[1]);
				recall = division(actValues[0],actValues[1]);
				stringObject2 = value;
				stringObject3 = stringObject3+"/"+precision;
				stringObject4 = stringObject4+"/"+recall;
			}
			else
			{
				value = "";
				precision = "";
				recall = "";
				stringObject2 = value;
				stringObject3 = stringObject3+"/"+precision;
				stringObject4 = stringObject3+"/"+recall;
			}
			returnResult[i][0]= Integer.toString(clusterId);
			returnResult[i][1]= stringObject1;
			returnResult[i][2]= stringObject2;
			returnResult[i][3]= stringObject3;
			returnResult[i][4]= stringObject4;
		}
		return returnResult;
	}
	
	@SuppressWarnings({"unchecked" })
	public HashMap<Integer,Integer[]> getClusterResults(String jsonString,String testCaseID)
	{
		Object[] extractedResults = getClusters(jsonString);
		HashMap<Integer,Integer> groundTruth = getGroundTruth(testCaseID);
		HashMap<Integer,HashMap<Integer,Double>> items = (HashMap<Integer, HashMap<Integer, Double>>) extractedResults[0];
		Set<Integer> itemsKeys = items.keySet();
		Iterator<Integer> itr = itemsKeys.iterator();
		HashMap<Integer,Integer[]> returnResults = new HashMap<Integer,Integer[]>();
			for(int i = 0;i<items.size();i++)
			{
				int high = 0;
				int current = 0;
				int ground_truth = 0;
				int clusterId = itr.next();
				HashMap<Integer,Double> itemsMap = items.get(clusterId);
				Set<Integer> itemsMapKeys = itemsMap.keySet();
				Iterator<Integer> itrMap = itemsMapKeys.iterator();
				List<Integer> categories = new ArrayList<Integer>();
			if(itemsMap.size()>0)
			{
				for(int j =0;j<itemsMap.size();j++)
				{
					int itemId = itrMap.next();
					categories.add(groundTruth.get(itemId));
				}
				
				Set<Integer> uniqueCategory = new HashSet<Integer>(categories);
				for(Integer temp : uniqueCategory)
				{
					current = Collections.frequency(categories, temp);
					if(high< current)
					{
						high = current;
						ground_truth = temp;
					}
				}
				
				
				List<Integer> gtcat = new ArrayList<Integer>();
				Set<Integer> gtKeys = groundTruth.keySet();
				for(Integer gtKey : gtKeys)
				{
				gtcat.add(groundTruth.get(gtKey));
				}
				returnResults.put(clusterId, new Integer[]{high,itemsMap.size(),Collections.frequency(gtcat, ground_truth)});
			}	
			else
			{
				returnResults.put(clusterId, new Integer[]{0,0,0});
			}
				
			}
		return returnResults;
		
	}
	
	@SuppressWarnings({ "unused", "unchecked" })
	public void compareConceptNearDupeClusterResults(String expResult,String actResult,String testCaseID)
	{
		Object[] extractedCAATResults = getClusters(expResult);
		Object[] extractedMPResults = getClusters(actResult);
		HashMap<Integer,Integer> groundTruth = getGroundTruth(testCaseID);
		HashMap<Integer,HashMap<Integer,Double>> itemsCAAT = (HashMap<Integer, HashMap<Integer, Double>>) extractedCAATResults[0];
		HashMap<Integer,List<Integer>> clusterLevelCAAT = (HashMap<Integer, List<Integer>>) extractedCAATResults[0];
		HashMap<Integer,HashMap<Integer,Double>> itemsMP = (HashMap<Integer, HashMap<Integer, Double>>) extractedMPResults[0];
		HashMap<Integer,List<Integer>> clusterLevelMP = (HashMap<Integer, List<Integer>>) extractedMPResults[0];
	}
		
	public String getLogFileName(String testName){
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss");
		String logFileName = testName + "_" + dateFormat.format(new Date()) + ".log";
		return logFileName;
	}
	
	public void setUpLog4j(String testCaseName) throws IOException{
		System.setProperty("app.log", getProperty("logFileLocation") + getLogFileName(testCaseName) );
		PropertyConfigurator.configure(getProperty("logPropertiesLocation"));
	}
	
	public String getJSONStringFromFile(String filePath)
	{	
		File file = new File(filePath);
		String fileData="";
		try {
			fileData = FileUtils.readFileToString(file);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return fileData;
	}
	
	public List<Integer> getSearchItemIds(String expJSON) throws ParseException
	{
		JSONParser jp = new JSONParser();
		org.json.simple.JSONObject initObj = (org.json.simple.JSONObject) jp.parse(expJSON);
		Object value = initObj.get("foundItems");
		JSONArray expArray = (JSONArray) value;
		List<Integer> itemIds = new ArrayList<Integer>();
		@SuppressWarnings("unchecked")
		Iterator<String> arrayIterator = expArray.iterator();
		for(int i = 0;i<expArray.size();i++)
		{
			Object arrayValue = arrayIterator.next();
			org.json.simple.JSONObject itemObject = (org.json.simple.JSONObject) arrayValue;
			itemIds.add(Integer.parseInt((String) itemObject.get("itemId")));
		}
		
		Collections.sort(itemIds);
		return itemIds;
	}	
	
	public HashMap<Integer,Object[]> getCategoryValues(String expJSON) throws ParseException, JSONException
	{
		
	HashMap<Integer,Object[]> returnValue = new HashMap<Integer,Object[]>();	
	JSONParser jp = new JSONParser();
	org.json.simple.JSONObject jObj = (org.json.simple.JSONObject) jp.parse(expJSON);
	Object value = jObj.get("categorizedItems");
	JSONArray jArray = (JSONArray) value;
	int itemID;
	
	@SuppressWarnings("unchecked")
	Iterator<org.json.simple.JSONObject> iter = jArray.iterator();
	for(int i=0;i<jArray.size();i++)
	{
		Object intValue = iter.next();
		org.json.simple.JSONObject intObj = (org.json.simple.JSONObject) intValue;
		itemID = Integer.parseInt(intObj.get("itemId").toString());
		Object categories = intObj.get("categories");
		JSONArray cateArray = (JSONArray) categories;
		if(cateArray.size()>0)
		{
		org.json.simple.JSONObject cateObj = (org.json.simple.JSONObject) cateArray.get(0);
		int closestExampleItemId = Integer.parseInt(cateObj.get("closestExampleItemId").toString());
		Double score = Double.parseDouble(cateObj.get("score").toString());
		String category = cateObj.get("category").toString();
		returnValue.put(itemID, new Object[]{closestExampleItemId,score,category});
		}
		else
		{
			returnValue.put(itemID, new Object[]{0,0,0});
		}
	
	}
	return returnValue;
	
	}
	
	public void setResultFile(String Path, String SheetName) throws Exception 
	{
				try{
			outputWorkbook = new XSSFWorkbook();
			outputSheet = outputWorkbook.createSheet(SheetName);
			fileout = new FileOutputStream(Path);
			@SuppressWarnings("unused")
			XSSFRow outputRow = outputSheet.createRow(0);
		}catch(Exception e){
			throw(e);
		}
	}
	
	public void mergeCellsAddValue(int rowStart,int rowEnd, int colStart, int colEnd, String content)
	{
		XSSFRow outputRow;
		XSSFCell outputCell;
		for(int i=rowStart;i<(rowEnd+1);i++)
		{
		outputRow = outputSheet.createRow(i);
			for(int j =colStart;j<(colEnd+1);j++)
			{
				outputCell = outputRow.createCell(j);
			}
		}
		outputRow = outputSheet.getRow(rowStart);
		outputCell = outputRow.getCell(colStart);
		outputCell.setCellValue(content);
		outputCell.setCellStyle(setItalicStyle());
		outputSheet.addMergedRegion(new CellRangeAddress(rowStart,rowEnd,colStart,colEnd));
		
	}
	
	public XSSFCellStyle setBoldStyle()
	{
		XSSFCellStyle style = outputWorkbook.createCellStyle();
			XSSFFont fontStyle = outputWorkbook.createFont();
			fontStyle.setBold(true);
			//fontStyle.setColor(IndexedColors.DARK_GREEN.getIndex());
			fontStyle.setItalic(false);
		style.setFont(fontStyle);
		//style.setFillBackgroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
		style.setAlignment(HorizontalAlignment.LEFT);
		style.setVerticalAlignment(VerticalAlignment.CENTER);
	return style;
	}
	
	public XSSFCellStyle setBoldJustifyStyle()
	{
		XSSFCellStyle style = outputWorkbook.createCellStyle();
			XSSFFont fontStyle = outputWorkbook.createFont();
			fontStyle.setBold(true);
			//fontStyle.setColor(IndexedColors.DARK_GREEN.getIndex());
			fontStyle.setItalic(false);
		style.setFont(fontStyle);
		//style.setFillBackgroundColor(IndexedColors.WHITE.getIndex());
		style.setAlignment(HorizontalAlignment.LEFT);
		style.setVerticalAlignment(VerticalAlignment.JUSTIFY);
	return style;
	}
	
	public XSSFCellStyle setItalicStyle()
	{
		XSSFCellStyle style = outputWorkbook.createCellStyle();
			XSSFFont fontStyle = outputWorkbook.createFont();
			fontStyle.setItalic(true);
		//	fontStyle.setColor(IndexedColors.BLACK.getIndex());
			fontStyle.setBold(false);
		style.setFont(fontStyle);
		//style.setFillBackgroundColor(IndexedColors.AQUA.getIndex());
		style.setAlignment(HorizontalAlignment.LEFT);
		style.setVerticalAlignment(VerticalAlignment.JUSTIFY);
		return style;
	}
	
	public XSSFCellStyle setNormalStyle()
	{
		XSSFCellStyle style = outputWorkbook.createCellStyle();
			XSSFFont fontStyle = outputWorkbook.createFont();
			fontStyle.setItalic(false);
			fontStyle.setColor(IndexedColors.BLACK.getIndex());
			fontStyle.setBold(false);
		style.setFont(fontStyle);
		style.setFillBackgroundColor(IndexedColors.WHITE.getIndex());
		style.setAlignment(HorizontalAlignment.LEFT);
		style.setVerticalAlignment(VerticalAlignment.CENTER);
		return style;
	}
	
	public void setCellData(String Result, int RowNo, int ColNo, String type) throws Exception{	
		
			try{
			XSSFRow outputRow;
			if(RowNo > outputSheet.getLastRowNum())
			{
				outputRow = outputSheet.createRow(RowNo);
			}
			else
			{
				outputRow = outputSheet.getRow(RowNo);
			}
			XSSFCell outputCell = outputRow.createCell(ColNo) ;
			outputCell.setCellValue(Result);
			if(type.equals("bold"))
			{
				outputCell.setCellStyle(setBoldStyle());
			} else if(type.equals("italic"))
			{
				outputCell.setCellStyle(setItalicStyle());
			}else if(type.equals("justify"))
			{
				outputCell.setCellStyle(setBoldJustifyStyle());
			}else
			{
				outputCell.setCellStyle(setNormalStyle());
			}
			
		}catch(Exception e){
			throw(e);
		}
	}
	
	public void writeExcel()
	{
		try {
			outputWorkbook.write(fileout);
			fileout.flush();
			fileout.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}
	
	public boolean sheetExists(String SheetName)
	{
		boolean flag = false;
		int count = outputWorkbook.getNumberOfSheets();
		System.out.println(count);
		for (int i = 0;i<count;i++)
		{
			if(SheetName.equals(outputWorkbook.getSheetAt(i).getSheetName().toString()))
			{
				flag = true;
			}
		}
		return flag;
	}
	
	public void currentRow()
	{
		
	}
	
	public void readExcel(String path, String SheetName) throws IOException
	{
		FileInputStream filein = new FileInputStream(path);
		outputWorkbook = new XSSFWorkbook(filein);
		if(!sheetExists(SheetName))
		{
			outputSheet = outputWorkbook.createSheet(SheetName);
			@SuppressWarnings("unused")
			XSSFRow outputRow = outputSheet.createRow(0);
		}else{
		outputSheet = outputWorkbook.getSheet(SheetName);
		}
	}
	
	public long getTimeNow()
	{
		long timeMilli =0;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
		sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
		Date date;
		try {
			date = sdf.parse(sdf.format(new Date()));
			timeMilli = date.getTime();
		} catch (java.text.ParseException e) {
			e.printStackTrace();
		}
		return timeMilli;
	}
	
	public String getDate()
	{
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss-SSS");
		Date date = new Date();
		String dateReturn = dFormat.format(date);
		return dateReturn;
	}
	
	public String getDateForSQL(long time)
	{
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
		Date date = new Date(time);
		String dateReturn = dFormat.format(date);
		return dateReturn;
	}
	
	public String getDateYYYYMMDD()
	{
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String dateReturn = dFormat.format(date);
		return dateReturn;
	}
	
	public HashMap<Integer,Integer> getGroundTruth(String testCaseID)
	{
		
		//Method Start
		HashMap<Integer,Integer> gTruthMatrix = new HashMap<Integer,Integer>();
		String JDBC_DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
		String DB_URL = "jdbc:sqlserver://10.12.239.126;databaseName=MPQA";
		
		String USER = "sluser";
		String PASS = "Consilio@16#";
		
			Connection conn = null;
			Statement stmt = null;
			try {
				Class.forName(JDBC_DRIVER);
				conn = DriverManager.getConnection(DB_URL,USER,PASS);
				stmt = conn.createStatement();
				String sql;
				sql = "Select item_id,ground_truth from groundTruth where test_id="+testCaseID.toString();
				ResultSet rs = stmt.executeQuery(sql);
				      //while start
					while(rs.next()){
						//Retrieve by column name
						int item_id = rs.getInt("item_id");
						int ground_truth = rs.getInt("ground_truth");
						gTruthMatrix.put(item_id, ground_truth);
					}
				rs.close();
				stmt.close();
				conn.close();
				} 
					catch (SQLException se) {
						se.printStackTrace();
					}
					catch (Exception e) {
						e.printStackTrace();
					}
			finally {
			//finally block used to close resources
			    try{
			    if(stmt!=null)
			    stmt.close();
			    }
			    catch(SQLException se2){
			    }// nothing we can do
			    try{
			    if(conn!=null)
			    conn.close();
			    }
			    catch(SQLException se){
			    se.printStackTrace();
			    }//end finally try
				
			}
			return gTruthMatrix;
	}	
	
	public void writeScalingReport()
	{
		
	}
	
	public Boolean checkFileExist(String path)
	{
		boolean exists = false;
		File f = new File(path);
		if(f.exists())
		{
			exists = true;
		}
		
		return exists;
	}
	

	public void insertQAScalingInfo(String[] data)
	{
		
		String JDBC_DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
		String DB_URL = "jdbc:sqlserver://10.12.239.126;databaseName=MPQA";
		
		String USER = "sluser";
		String PASS = "Consilio@16#";
		
			Connection conn = null;
			Statement stmt = null;
			try {
				Class.forName(JDBC_DRIVER);
				conn = DriverManager.getConnection(DB_URL,USER,PASS);
				stmt = conn.createStatement();
				String sql;
				sql = "INSERT INTO QAScalingLogs VALUES ("
				+"'"+data[0].toString()+"',"
				+"'"+data[1].toString()+"',"
				+"'"+data[2].toString()+"',"
				+"'"+data[3].toString()+"',"
				+"'"+data[4].toString()+"',"
				+"'"+data[5].toString()+"',"
				+"'"+data[6].toString()+"',"
				+"'"+data[7].toString()+"',"
				+"'"+data[8].toString()+"'"
				+")";
				System.out.println(sql);
				//stmt.executeQuery(sql);
				stmt.executeUpdate(sql);
				stmt.close();
				conn.close();
				} 
					catch (SQLException se) {
						se.printStackTrace();
					}
					catch (Exception e) {
						e.printStackTrace();
					}
			finally {
			//finally block used to close resources
			    try{
			    if(stmt!=null)
			    stmt.close();
			    }
			    catch(SQLException se2){
			    }// nothing we can do
			    try{
			    if(conn!=null)
			    conn.close();
			    }
			    catch(SQLException se){
			    se.printStackTrace();
			    }//end finally try
				
			}
	}	
		
	public void insertQAScalingTasks(String[] data)
	{
		
		String JDBC_DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
		String DB_URL = "jdbc:sqlserver://10.12.239.126;databaseName=MPQA";
		
		String USER = "sluser";
		String PASS = "Consilio@16#";
		
			Connection conn = null;
			Statement stmt = null;
			try {
				Class.forName(JDBC_DRIVER);
				conn = DriverManager.getConnection(DB_URL,USER,PASS);
				stmt = conn.createStatement();
				String sql;
				sql = "INSERT INTO QAScalingTasks VALUES ("
				+"'"+data[0].toString()+"',"
				+"'"+data[1].toString()+"',"
				+"'"+data[2].toString()+"',"
				+"'"+data[3].toString()+"'"
				+")";
				System.out.println(sql);
				//stmt.executeQuery(sql);
				stmt.executeUpdate(sql);
				stmt.close();
				conn.close();
				} 
					catch (SQLException se) {
						se.printStackTrace();
					}
					catch (Exception e) {
						e.printStackTrace();
					}
			finally {
			//finally block used to close resources
			    try{
			    if(stmt!=null)
			    stmt.close();
			    }
			    catch(SQLException se2){
			    }// nothing we can do
			    try{
			    if(conn!=null)
			    conn.close();
			    }
			    catch(SQLException se){
			    se.printStackTrace();
			    }//end finally try
				
			}
	}	
	
	
	public void updateQAScalingTasks(String[] data)
	{
		String JDBC_DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
		String DB_URL = "jdbc:sqlserver://10.12.239.126;databaseName=MPQA";
		
		String USER = "sluser";
		String PASS = "Consilio@16#";
		
			Connection conn = null;
			Statement stmt = null;
			try {
				Class.forName(JDBC_DRIVER);
				conn = DriverManager.getConnection(DB_URL,USER,PASS);
				stmt = conn.createStatement();
				String sql;
				sql = "UPDATE QAScalingTasks SET end_time = "
						+"'"+data[3].toString()+"' WHERE task_id = "
				+"'"+data[0].toString()+"'";
				System.out.println(sql);
				//stmt.executeQuery(sql);
				stmt.executeUpdate(sql);
				stmt.close();
				conn.close();
				} 
					catch (SQLException se) {
						se.printStackTrace();
					}
					catch (Exception e) {
						e.printStackTrace();
					}
			finally {
			//finally block used to close resources
			    try{
			    if(stmt!=null)
			    stmt.close();
			    }
			    catch(SQLException se2){
			    }// nothing we can do
			    try{
			    if(conn!=null)
			    conn.close();
			    }
			    catch(SQLException se){
			    se.printStackTrace();
			    }//end finally try
				
			}
	}	
	
	public String division(int dividend, int divisor)
	{
		String returnValue;
		DecimalFormat df = new DecimalFormat("0.00");
		if(divisor <1 && dividend <1)
		{
			returnValue = df.format(1);
		}
		else if(divisor <1 && dividend >0)
		{
			returnValue = df.format(0);
		}
		else if(divisor>0 && dividend <1)
		{
			returnValue = df.format(0);
		}
		else
		{
			returnValue = df.format(dividend/divisor);
		}
		return returnValue;
	}


}
