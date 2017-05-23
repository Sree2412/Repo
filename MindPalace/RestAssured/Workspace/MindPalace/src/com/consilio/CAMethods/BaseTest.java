package com.consilio.CAMethods;

import static com.jayway.restassured.RestAssured.basePath;
import static com.jayway.restassured.RestAssured.baseURI;
import static com.jayway.restassured.RestAssured.given;
import static com.jayway.restassured.RestAssured.port;
import static org.hamcrest.Matchers.is;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.TreeSet;
import java.util.Map.Entry;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.stream.XMLEventReader;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamConstants;
import javax.xml.stream.events.Attribute;
import javax.xml.stream.events.Characters;
import javax.xml.stream.events.StartElement;
import javax.xml.stream.events.XMLEvent;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.log4j.PropertyConfigurator;
import org.json.JSONException;
import org.json.JSONObject;
import org.testng.asserts.SoftAssert;
import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.jayway.restassured.builder.RequestSpecBuilder;
import com.jayway.restassured.builder.ResponseSpecBuilder;
import com.jayway.restassured.path.xml.XmlPath;
import com.jayway.restassured.specification.RequestSpecification;
import com.jayway.restassured.specification.ResponseSpecification;
import com.consilio.lib.ExcelUtils;
import com.consilio.lib.Log;
import com.consilio.lib.Utilities;

public class BaseTest extends Utilities{	

	int connectorId = 0;	
	int ingestedCount = 0;
	int numProcessed = 0;
	public String currenttestCaseName = null;
	SoftAssert assertion = null;
	Instant stagingAreaStartTime = null;
	Instant stagingAreaEndTime = null;
	protected AtomicInteger automicInt = null;
	protected static Map<AtomicInteger, Object[]> metadataMetricsResultData = null;
	public static Map<AtomicInteger, Object[]> scalabilityMetricsResultData = null;	
	public static Map<AtomicInteger, Object[]> TotalResult = new LinkedHashMap<AtomicInteger, Object[]>();
	public static Map<AtomicInteger, Object[]> VolumeMetricsResultData = null;
	DocumentBuilderFactory docBuilderFactory = null;
	DocumentBuilder builder = null;
	Document resultedDoc = null;
	Node rootElement = null;
	NamedNodeMap rootElementAttributes = null;
	Node stagingAreaIdNode = null;
	Node exportDateNode = null;
	TransformerFactory transformerFactory = null;
	Transformer transformer = null;
	DOMSource source = null;	
	protected static ArrayList<Timestamp> ingestionStartTimesList = null;
	protected static ArrayList<Timestamp> ingestionEndTimesList = null;
	protected static ArrayList<Timestamp> taskStartTimesList = null;
	protected static ArrayList<Timestamp> taskEndTimesList = null;
	
	protected Timestamp ingStartTime = null;
	protected Timestamp ingEndTime = null;
	protected Timestamp tskStartTime = null;
	protected Timestamp tskEndTime = null;
		
	public void init() throws NumberFormatException, IOException{
		currenttestCaseName = this.getClass().getSimpleName();		
		setUpLogger(currenttestCaseName);
		ExcelUtils.setExcelFile();
		setupExcelHeaders();
		
		ingestionStartTimesList = new ArrayList<Timestamp>();
		ingestionEndTimesList = new ArrayList<Timestamp>();
		taskStartTimesList = new ArrayList<Timestamp>();
		taskEndTimesList = new ArrayList<Timestamp>();
		
		switch(getProperty("env")){
		case "CAAT":			
			baseURI = getProperty("baseURI_CAAT");          
			port = Integer.parseInt(getProperty("port_CAAT"));
			basePath = getProperty("basePath_CAAT");   
			break;
		case "MP":
			baseURI = getProperty("baseURI_MP");
			port = Integer.parseInt(getProperty("port_MP"));
			basePath = getProperty("basePath_MP");
			break;
		}
	}
	
	public void setUpLogger(String testCaseName) throws IOException{		
		try {
			System.setProperty("app.log", getProperty("logFileLocation") + getLogFileName(testCaseName)) ;			
			PropertyConfigurator.configure(getProperty("logPropertiesLocation"));
		} catch (IOException e) {			
			throw e;
		}		
	}
	
	public void setupExcelHeaders(){
		metadataMetricsResultData = new LinkedHashMap<AtomicInteger, Object[]>();
		metadataMetricsResultData.put(automicInt, new Object[]{"TestCaseName", "Metadata", "Precision", "Recall"});
		scalabilityMetricsResultData = new LinkedHashMap<AtomicInteger, Object[]>();
		scalabilityMetricsResultData.put(automicInt, new Object[]{"ParallelExecutionCount", "TestCaseName", "MaxDateTime", "MinDateTime", "ElapsedTimeInSeconds", "ElapsedTimeInMinutes", "ElapsedTimeInHours"});
		VolumeMetricsResultData = new LinkedHashMap<AtomicInteger, Object[]>();
		VolumeMetricsResultData.put(automicInt, new Object[]{"TestCaseName", "MaxDateTime", "MinDateTime", "ElapsedTimeInSeconds", "ElapsedTimeInMinutes", "ElapsedTimeInHours"});
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, List<String>> getMapOfAttributesToItemIdsWithStAXParser(String xmlFile, String attribute) throws Exception{		
		Log.info("Building Key-Value pairs with the Attribute: " + "'" + attribute + "'");	
	
		boolean isRequiredAttribute = false;
		String itemId = null;
		ArrayList<String> listOfItemIds = null;
		Map<String, List<String>> resultedMap = new HashMap<String, List<String>>();
		XMLInputFactory factory = XMLInputFactory.newInstance();
		XMLEventReader reader = factory.createXMLEventReader(new FileReader(new File(xmlFile)));
		Instant startTime = Instant.now();
		while(reader.hasNext()){
			XMLEvent event = reader.nextEvent();
			switch(event.getEventType()){
			case  XMLStreamConstants.START_ELEMENT:
				StartElement startElement = event.asStartElement();
				String qName = startElement.getName().getLocalPart();
				
				if(qName.equalsIgnoreCase("item")){
					Iterator<Attribute> attributes = startElement.getAttributes();
					itemId = attributes.next().getValue();
				}				
				
				if (qName.equalsIgnoreCase("meta")){
					Iterator<Attribute> attributes = startElement.getAttributes();
					String name = attributes.next().getValue();
					if(name.equalsIgnoreCase(attribute)){
						isRequiredAttribute = true;
					}
				}
				break;
			case XMLStreamConstants.CHARACTERS:
				if(isRequiredAttribute){
					Characters characters = event.asCharacters();
					String keyValue = characters.getData();
					if(resultedMap.containsKey(keyValue)){
						listOfItemIds = (ArrayList<String>) resultedMap.get(keyValue);
						listOfItemIds.add(itemId);
					}else{
						listOfItemIds = new ArrayList<String>();
						listOfItemIds.add(itemId);
					}
					resultedMap.put(keyValue, listOfItemIds);
					//Log.info("Resulted Map: " + resultedMap.entrySet().toString());
					isRequiredAttribute = false;
				}				
				break;
			}
		}		
		Log.info("Completed Building Key-Value pairs with the Attribute: " + "'" + attribute + "'");
		Instant endTime = Instant.now();
		Duration timeElapsed = Duration.between(startTime, endTime);
		//Log.info("Time taken to build the Map in milli seconds: " + timeElapsed.toMillis());
		Log.info("Time taken to build the Key-Value pairs in minutes: " + timeElapsed.toMinutes());
		//Log.info("Time taken to build the Map in hours: " + timeElapsed.toHours());
		return resultedMap;		
	}	
	
	public Map<String, List<String>> getMapOfAttributesToItemIdsWithXmlPath(String xmlFile, ArrayList<String> listOfAttributeValues, String attribute) throws Exception{		
		Log.info("Building Map of Attribute values to Item Ids");	
				
		int sizeOfListOfAttributeValues = listOfAttributeValues.size();
		StringBuilder xmlPathExp = new StringBuilder();
		Map<String, List<String>> resultedMap = new HashMap<>();		
		XmlPath xmlpath = new XmlPath(new File(xmlFile));		
		
		for(int i=0;i< sizeOfListOfAttributeValues;i++){			
			xmlPathExp.delete(0, xmlPathExp.length());			
			xmlPathExp.append("$.item.findAll{it.meta.find{it.@name == '").append(attribute).append("'}.text() == '").append(listOfAttributeValues.get(i)).append("'}.@'item-id'");
			List<String> listOfItemIds = xmlpath.getList(xmlPathExp.toString());			
			resultedMap.put(listOfAttributeValues.get(i), listOfItemIds);
		}			
		
		Log.info("Completed building Map of Attribute values to Item Ids");
		return resultedMap;		
	}	
	
	@SuppressWarnings("unused")
	private NodeList getNodeList(String xmlFile, String expression) throws Exception{
		File file = new File(xmlFile);
		XPath xpath = XPathFactory.newInstance().newXPath();
		Document doc = createDocument(file);
		NodeList nodeList = (NodeList) xpath.compile(expression.toString()).evaluate(doc,XPathConstants.NODESET);
		return nodeList;
	}
	
	public String buildConnectorConfig(String conName, String conType, String dataType, String dataSetId, Boolean isIncremental, String incQuery) throws Exception{
		String config = null;
		try{
				Log.info("Building Connector config");						
				if(conType.equalsIgnoreCase("jdbc")){
					Log.info("Building JDBC connector");					
					if(getProperty("env").equals("CAAT")){
						config = getProperty("connectorConfigJDBC").replace("connectorName", conName)
								.replace("sqlServerName", getProperty("sqlServerName_CAAT"))
								.replace("\""+ getProperty("sqlServerName_CAAT") + "\"", "" + getProperty("sqlServerName_CAAT") + "")
								.replace("sqlServerUserName", getProperty("sqlServerUserName_CAAT"))
								.replace("sqlServerPwd", getProperty("sqlServerPwd_CAAT"))
								.replace("dbName", dataSetId)
								.replace("\""+ dataSetId + "\"", "" + dataSetId + "")
								.replace("conSingleItemQuery",getProperty("conSingleItemQuery"))
								.replace("conQuery", getProperty("conQuery"))
								.replace("conMode", getProperty("conMode"));
					}else if(getProperty("env").equals("MP")){
						
						if(isIncremental == false){
							if(dataType.equalsIgnoreCase("ds01") || dataType.equalsIgnoreCase("ds02") || dataType.equalsIgnoreCase("ds03") ||
									dataType.equalsIgnoreCase("ds04") || dataType.equalsIgnoreCase("ds05") || dataType.equalsIgnoreCase("ds06") ||
									dataType.equalsIgnoreCase("ds07") || dataType.equalsIgnoreCase("ds08") || dataType.equalsIgnoreCase("ds09") ||
									dataType.equalsIgnoreCase("ds10") || dataType.equalsIgnoreCase("ds11") || dataType.equalsIgnoreCase("ds12") || 
									dataType.equalsIgnoreCase("ds13") || dataType.equalsIgnoreCase("ds14") || dataType.equalsIgnoreCase("ds15") || 
									dataType.equalsIgnoreCase("ds16") || dataType.equalsIgnoreCase("ds17") || dataType.equalsIgnoreCase("ds18") || 
									dataType.equalsIgnoreCase("ds19") || dataType.equalsIgnoreCase("ds20"))  {
								config = getProperty("connectorConfigJDBC").replace("connectorName", conName)
										.replace("sqlServerName", getProperty("sqlServerName_MP"))
										.replace("\""+ getProperty("sqlServerName_MP") + "\"", "" + getProperty("sqlServerName_MP") + "")
										.replace("sqlServerUserName", getProperty("sqlServerUserName_MP"))
										.replace("sqlServerPwd", getProperty("sqlServerPwd_MP"))
										.replace("dbName", "MPQA")
										.replace("\""+ "MPQA" + "\"", "" + "MPQA" + "")
										.replace("conSingleItemQuery", "MindPalace does not use this field")
										.replace("conQuery", "EXEC GET_DATASET_FILES " + dataSetId + ", 27, '/elasticsearch/Datasets'")
										.replace("conMode",getProperty("conMode"));
							}else{
								config = getProperty("connectorConfigJDBC").replace("connectorName", conName)
										.replace("sqlServerName", getProperty("sqlServerName_MP"))
										.replace("\""+ getProperty("sqlServerName_MP") + "\"", "" + getProperty("sqlServerName_MP") + "")
										.replace("sqlServerUserName", getProperty("sqlServerUserName_MP"))
										.replace("sqlServerPwd", getProperty("sqlServerPwd_MP"))
										.replace("dbName", "MPQA")
										.replace("\""+ "MPQA" + "\"", "" + "MPQA" + "")
										.replace("conSingleItemQuery", "MindPalace does not use this field")
										//.replace("conQuery", "EXEC get_test_by_id " + dataSetId)
										.replace("conQuery", "EXEC GET_DATASET_FILES " + dataSetId  )
										.replace("conMode",getProperty("conMode"));
							}
						}else{
							config = getProperty("connectorConfigJDBC").replace("connectorName", conName)
									.replace("sqlServerName", getProperty("sqlServerName_MP"))
									.replace("\""+ getProperty("sqlServerName_MP") + "\"", "" + getProperty("sqlServerName_MP") + "")
									.replace("sqlServerUserName", getProperty("sqlServerUserName_MP"))
									.replace("sqlServerPwd", getProperty("sqlServerPwd_MP"))
									.replace("dbName", "MPQA")
									.replace("\""+ "MPQA" + "\"", "" + "MPQA" + "")
									.replace("conSingleItemQuery", "MindPalace does not use this field")
									//.replace("conQuery", "EXEC get_test_by_id " + dataSetId)
									.replace("conQuery", incQuery )
									.replace("conMode",getProperty("conMode"));
						}
						
																		
					}					
				}else if(conType.equalsIgnoreCase("csv")){			
					if(dataType.equalsIgnoreCase("efiles")){
						Log.info("Building CSV connector for Efiles");
						config = getProperty("connectorConfigCSV").replace("connectorName", conName)
								.replace("ingestion_data_path", getProperty("ingestion_data_path").trim() + getProperty("ingestionFileName_efiles").trim());
					}else if(dataType.equalsIgnoreCase("emails")){
						Log.info("Building CSV Connector for Emails");
						config = getProperty("connectorConfigCSV").replace("connectorName", conName)
								.replace("ingestion_data_path", getProperty("ingestion_data_path").trim() + getProperty("ingestionFileName_emails").trim());
					}else if(dataType.equalsIgnoreCase("efiles_and_emails")){
						Log.info("Building CSV Connector for Efiles and Emails");
						config = getProperty("connectorConfigCSV").replace("connectorName", conName)
								.replace("ingestion_data_path", getProperty("ingestion_data_path").trim() + getProperty("ingestionFileName_efiles_and_emails").trim());
					}else if(dataType.equalsIgnoreCase("efiles_with_diff_lang")){
						Log.info("Building CSV connector for Efiles with different language");
						config = getProperty("connectorConfigCSV").replace("connectorName", conName)
								.replace("ingestion_data_path", getProperty("ingestion_data_path").trim() + getProperty("ingestionFileName_efiles_with_diff_lang").trim());
					}else if(dataType.equalsIgnoreCase("efiles_with_no_dupe_data")){
						Log.info("Building CSV connector for Efiles with no dupe data");
						config = getProperty("connectorConfigCSV").replace("connectorName", conName)
								.replace("ingestion_data_path", getProperty("ingestion_data_path").trim() + getProperty("ingestionFileName_efiles_with_no_dupes").trim());
					}			
				}		
				Log.info("Completed building Connector config");
		}catch(Exception e){
			Log.error(e.getLocalizedMessage());
			throw e;
		}		
		return config;		
	}
	
	public boolean checkForSimilarity(String areaId, String dataType, String destFileToCompare) throws IOException, ParserConfigurationException, SAXException, TransformerException{
		String strSourceXMLFile = getSourceFilePathToValidateOnEnv(areaId) + getProperty("sourceFileNameToValidate");
		String strNewSourceXMLFile = getProperty("destinationPathToValidate") + getUpdatedSourceFileNameToValidate(dataType);
		String strDestXMLFile = getProperty("destinationPathToValidate") + destFileToCompare;
		HashMap<String, String> attributeListToUpdate = new HashMap<String, String>();
		attributeListToUpdate.put("stagingAreaIdAttribute", "staging-area-id");
		attributeListToUpdate.put("exportDateAttribute","export-date");					
		updateXMLAttribute(strSourceXMLFile, strNewSourceXMLFile, attributeListToUpdate);
		return areXMLFilesSimilar(strNewSourceXMLFile,strDestXMLFile);
	}
	
	public ResponseSpecification getIngestionResponseSpecification(){
		ResponseSpecBuilder specBuilder = new ResponseSpecBuilder();		
		specBuilder
			//.expectBody("failures.failureCount", is(0))
			//.expectBody("failures.skippedCount",is(0))
			//.expectBody("status.failureCount", is(0));
			.expectBody("status.state", is("IDLE"));		
		ResponseSpecification respSpec = specBuilder.build();			
		return respSpec;
	}
	
	public ArrayList<String> getAttributeValuesFromXMLFile(String xmlFile, String xmlPathExp){
		Log.info("Collecting Attribute values from the XML file");
		File file = new File(xmlFile);
		XmlPath sourceXmlPath = new XmlPath(file);		
		//ArrayList<String> listOfValues = sourceXmlPath.get(xmlPathExp);		
		List<Object> resultObj = sourceXmlPath.getList(xmlPathExp);		
		ArrayList<String> listOfValues = (ArrayList<String>) resultObj.stream().map(object -> Objects.toString(object, null)).collect(Collectors.toList());
		Log.info("Completed Collecting Attribute values from the XML file");
		return listOfValues;
	}
	
	private String getUpdatedSourceFileNameToValidate(String dataType) throws IOException{
		String destinationFileNameToValidate = null;
		if(dataType.equalsIgnoreCase("Efiles_WDupes")){
			destinationFileNameToValidate = getProperty("destinationFileNameToValidate_EfilesWDupes");			
		}else if(dataType.equalsIgnoreCase("Efiles_WNoDupes")){
			destinationFileNameToValidate = getProperty("destinationFileNameToValidate_EfilesWNoDupes");
		}else if(dataType.equalsIgnoreCase("Efiles_WDupesAndNoDupes")){
			destinationFileNameToValidate = getProperty("destinationFileNameToValidate_EfilesWDupesAndNoDupes");
		}else if(dataType.equalsIgnoreCase("Emails_WDupes")){
			destinationFileNameToValidate = getProperty("destinationFileNameToValidate_EmailsWDupes");
		}else if(dataType.equalsIgnoreCase("Emails_WNoDupes")){
			destinationFileNameToValidate = getProperty("destinationFileNameToValidate_EmailsWNoDupes");
		}else if(dataType.equalsIgnoreCase("Emails_WDupesAndNoDupes")){
			destinationFileNameToValidate = getProperty("destinationFileNameToValidate_EmailsWDupesAndNoDupes");
		}else if(dataType.equalsIgnoreCase("Efiles_Emails")){
			destinationFileNameToValidate = getProperty("destinationFileNameToValidate_EfilesEmails");
		}else if(dataType.equalsIgnoreCase("Efiles_WDiffLang")){
			destinationFileNameToValidate = getProperty("destinationFileNameToValidate_EfilesWDiffLang");
		}else if(dataType.equalsIgnoreCase("Efiles_CJK")){
			destinationFileNameToValidate = getProperty("destinationFileNameToValidate_EfilesCJK");
		}else if(dataType.equalsIgnoreCase("Efiles_Empty")){
			destinationFileNameToValidate = getProperty("destinationFileNameToValidate_EfilesEmpty");
		}else if(dataType.equalsIgnoreCase("Efiles_LotusNotes")){
			destinationFileNameToValidate = getProperty("destinationFileNameToValidate_EfilesLotusNotes");
		}else if(dataType.equalsIgnoreCase("Docs_256K")){
			destinationFileNameToValidate = getProperty("destinationFileNameToValidate_Docs256k");
		}else if(dataType.equalsIgnoreCase("Docs_500K")){
			destinationFileNameToValidate = getProperty("destinationFileNameToValidate_Docs500k");
		}else if(dataType.equalsIgnoreCase("Emails_WAttachments")){
			destinationFileNameToValidate = getProperty("destinationFileNameToValidate_EmailsWAttachments");
		}else if(dataType.equalsIgnoreCase("Emails_WDiffLang")){
			destinationFileNameToValidate = getProperty("destinationFileNameToValidate_EmailsWDiffLang");
		}else if(dataType.equalsIgnoreCase("Emails_CJK")){
			destinationFileNameToValidate = getProperty("destinationFileNameToValidate_EmailsCJK");
		}else if(dataType.equalsIgnoreCase("Emails_LotusNotes")){
			destinationFileNameToValidate = getProperty("destinationFileNameToValidate_EmailsLotusNotes");
		}else if(dataType.equalsIgnoreCase("Emails_Empty")){
			destinationFileNameToValidate = getProperty("destinationFileNameToValidate_EmailsEmpty");
		}
		return destinationFileNameToValidate;
	}
		
	public void setUpMetricsDataHeader(){
		metadataMetricsResultData = new LinkedHashMap<AtomicInteger, Object[]>();
		metadataMetricsResultData.put(automicInt, new Object[]{"TestCaseName", "Metadata", "Precision", "Recall"});
		scalabilityMetricsResultData = new LinkedHashMap<AtomicInteger, Object[]>();
		scalabilityMetricsResultData.put(automicInt, new Object[]{"TestCaseName", "MaxTime", "MinTime", "ElapsedTime"});
	}
		
	public RequestSpecification getConnectorRequestSpecification(String conType, String newConfig) throws IOException{
		RequestSpecBuilder reqBuilder = new RequestSpecBuilder();				
		if(conType.equalsIgnoreCase("csv")){					
			reqBuilder.addHeader("Content-Type", "application/json").setBody(newConfig);
		}else if(conType.equalsIgnoreCase("jdbc")){					
			if(getProperty("env").equals("CAAT")){
				reqBuilder.addQueryParam("mimeType", "application/json").setBody(newConfig);
			}else if(getProperty("env").equals("MP")){
				reqBuilder.addHeader("Content-Type", "application/json").setBody(newConfig);
			}
		}	
		RequestSpecification reqSpec = reqBuilder.build();	
		return reqSpec;
	}
	
	protected String getSourceFilePathToValidateOnEnv(String areaId) throws IOException{
		String sourceFilePathToValidate = null;	
		if(getProperty("env").equals("CAAT")){
			sourceFilePathToValidate = getProperty("stagingAreaExportLocation").replace("stagingAreaId", areaId);
		}else if(getProperty("env").equals("MP")){
			sourceFilePathToValidate = getProperty("stagingAreaExportLocation_MP").replace("stagingAreaId", areaId);
		}		
		return sourceFilePathToValidate;		
	}	
	
	public boolean areExportedResultsMatchingByAttribute(String strSourceXMLFile, String strDestXMLFile, String attribute, String dataType, boolean isMetricsRequired) throws Exception{
		boolean areResultsMatching = false;
		Map<String, Object> resultedMap= compareXMLsWithAttributeAndGetMatchedAndUnMatchedDocumentsSize(strSourceXMLFile, strDestXMLFile, attribute);
		automicInt = new AtomicInteger(1);
		if(resultedMap.size() > 0 ){
			Log.info("Calculating Precision and Recall");
			int TP = (int) resultedMap.get("TP");
			int FP = (int) resultedMap.get("FP"); 
			int FN = (int) resultedMap.get("FN");
			areResultsMatching = (boolean) resultedMap.get("isGroupingCountMatching");
						
			float Precision =  (float) TP / (TP + FP);
			float Recall = (float) TP/ (TP + FN);			
			DecimalFormat df = new DecimalFormat("####0.000");
			String formattedPrecision = df.format(Precision * 100);
			String formattedRecall = df.format(Recall * 100);
			
			Log.info("Completed Calculating Precision and Recall");
			Log.info("Precision for the attribute: '" + attribute + "' is: '" + formattedPrecision + "' and Recall is: '" + formattedRecall + "'");			
			
			if(getProperty("enableMetrics").equalsIgnoreCase("true") && isMetricsRequired == true){
				if((!Double.isNaN(Precision)) && (!Double.isNaN(Recall))){
					Log.info("Started Writing Metrics to Excel file");
					//ExcelUtils.writeTestCaseMetricsToExcel(dataType, attribute, df.format(Precision * 100), df.format(Recall * 100));					
					metadataMetricsResultData.put(automicInt, new Object[]{dataType, attribute, formattedPrecision, formattedRecall});					
					Log.info("Completed Writing Metrics to Excel file");
				}			
			}
			
			if (!(areResultsMatching == true))
				return false;
					
			return true;
			
		}else{
			return false;
		}					
	}
	
	public Map<String, Object> compareXMLsWithAttributeAndGetMatchedAndUnMatchedDocumentsSize(String xmlFile1, String xmlFile2, String attributeToCompare) throws Exception{		
		//StringBuilder xmlPathExp = new StringBuilder();
		//xmlPathExp.append("**.findAll{it.@name == '").append(attributeToCompare).append("'}");		
		//ArrayList<String> sourceValues = getAttributeValuesFromXMLFile(xmlFile1, xmlPathExp.toString());
		//ArrayList<String> destValues = getAttributeValuesFromXMLFile(xmlFile2, xmlPathExp.toString());				
		
		Map<String, List<String>> unSortedsourceMap=  getMapOfAttributesToItemIdsWithStAXParser(xmlFile1, attributeToCompare); //getMapOfAttributesToItemIds(xmlFile1, sourceValues, attributeToCompare);
		Map<String, List<String>> unSortedDestMap= getMapOfAttributesToItemIdsWithStAXParser(xmlFile2, attributeToCompare);
				
		Map<String, List<String>> sortedSourceMap =  new LinkedHashMap<String, List<String>>();
		sortedSourceMap  = getSortedMapByValueSize(unSortedsourceMap);
		Map<String, List<String>> SortedDestMap = new LinkedHashMap<String, List<String>>(); 
		SortedDestMap = getSortedMapByValueSize(unSortedDestMap);
		
		Map<String, Object> resultedMap = new HashMap<>();
		int TP = 0;
		int FP = 0;
		int FN = 0;
				
		Log.info("Started Comparing Key-Value pairs");
		
		if(sortedSourceMap.size() > 0 && SortedDestMap.size() > 0){
			for(Entry<String, List<String>> entry1: Collections.synchronizedMap(sortedSourceMap).entrySet()){		
				Set<String> sourceSet = new TreeSet<String>();
				Set<String> destSet = new TreeSet<String>();												
				sourceSet.addAll(entry1.getValue());						
				
				List<String> tempList = new ArrayList<String>();			
				
				for(Entry<String, List<String>> entry2: SortedDestMap.entrySet()){				
					if(CollectionUtils.containsAny(entry2.getValue(), sourceSet)){										
						if(entry2.getValue().size() > tempList.size()){
							tempList = entry2.getValue();
						}				
					}					
				}					
				destSet.addAll(tempList);
				
				List<String> sourceList = new ArrayList<String>(sourceSet);
				List<String> destList = new ArrayList<String>(destSet);
				
				if(sourceList.size() > 0 && destList.size() > 0){
					if(!(sourceList.equals(destList))){
							
						//Log.info(sourceList + "and" + destList + " not matching ");
						SortedDestMap.values().removeIf(val -> CollectionUtils.containsAny(destList,val));				
						
						Collection<String> TruePositives = CollectionUtils.intersection(sourceList, destList);
						/*Collection<String> FalsePositives = CollectionUtils.disjunction(sourceSet, destSet);
						Collection<String> FalseNegatives = CollectionUtils.disjunction(TruePositives, destSet);*/
						
						Collection<String> FalsePositives = null;
						Collection<String> FalseNegatives = null;
						boolean flag = sourceList.removeAll(destList);
						if (flag == true){
							FalsePositives = sourceList;               
						}else{
							//log and throw exception
							Log.info("Something went wrong while calculating difference of two lists.");							
						}
												
						boolean flag2 = destList.removeAll(TruePositives); 
						if (flag2 == true){
							FalseNegatives = destList;                 
						}else{
							//log and throw exception
							Log.info("Something went wrong while calculating difference of two lists.");							
						}
						
						TP += TruePositives.size();
						FP += FalsePositives.size();
						FN += FalseNegatives.size();	
						
					}else{
						//Log.info(sourceList + "and" + destList + " are matching");
						Collection<String> TruePositives = CollectionUtils.intersection(sourceList, destList);
						/*Collection<String> FalsePositives = CollectionUtils.disjunction(sourceSet, destSet);
						Collection<String> FalseNegatives = CollectionUtils.disjunction(TruePositives, destSet);*/
						
						Collection<String> FalsePositives = null;
						Collection<String> FalseNegatives = null;
						boolean flag = sourceList.removeAll(destList);
						if (flag == true){
							FalsePositives = sourceList;               
						}else{
							//log and throw exception
							Log.info("Something went wrong while calculating difference of two lists.");
						}
												
						boolean flag2 = destList.removeAll(TruePositives); 
						if (flag2 == true){
							FalseNegatives = destList;                 
						}else{							
							//log and throw exception
							Log.info("Something went wrong while calculating difference of two lists.");
						}
						
						TP += TruePositives.size();
						FP += FalsePositives.size();
						FN += FalseNegatives.size();	
					}
				}								
			}
			resultedMap.put("TP", TP);
			resultedMap.put("FP", FP);
			resultedMap.put("FN", FN);
			resultedMap.put("isGroupingCountMatching", sortedSourceMap.size() == SortedDestMap.size());
			Log.info("Completed Comparing Key-Value pairs");
		}else{
			Log.warn("Metadata values are not exported to the Exported File");
		}			
		
		return resultedMap;		
	}
	
	private Map<String, List<String>> getSortedMapByValueSize(Map<String, List<String>> unsortedMap){					
		Set<Entry<String, List<String>>> setFromMap = unsortedMap.entrySet();		
		List<Entry<String, List<String>>> listFromSet = new ArrayList<Entry<String, List<String>>>(setFromMap);
		
		Collections.sort(listFromSet, new Comparator<Map.Entry<String, List<String>>>() {			
			public int compare(Entry<String, List<String>> o1, Entry<String, List<String>> o2) {				
				return o2.getValue().size() - o1.getValue().size();				
			}			
		});		
		
		Set<Entry<String, List<String>>> setFromList = new LinkedHashSet<Entry<String, List<String>>>(); 
		setFromList = listFromSet.stream().collect(Collectors.toCollection(LinkedHashSet::new));
				
		Map<String, List<String>> sortedMap = new LinkedHashMap<String, List<String>>();
		for(Entry<String, List<String>> entry: setFromList){
			sortedMap.put(entry.getKey(), entry.getValue());
		}
		
		return sortedMap;		
	}
		
	public String getConnectorStatus(String areaId, int conId) throws JSONException, IOException{
		String ingestionState = null;
		String ingestionResponse = null;
		JSONObject responseObject = null;		
		if(getProperty("env").equals("CAAT")){
			ingestionResponse = given().queryParameter("mimeType", "application/json").when().get(areaId + "/ingest/" + conId).asString();
			responseObject = new JSONObject(ingestionResponse);
			ingestionState = responseObject.getJSONObject("status").getString("state");			
		}else if(getProperty("env").equals("MP")){				
			ingestionResponse = given().header("Content-Type","application/json").when().get(areaId + "/ingest/" + conId).asString();
			responseObject = new JSONObject(ingestionResponse);
			ingestionState = responseObject.getJSONObject("status").getString("state");			
		}		
		return ingestionState;
	}
	
	public int getConnectorSuccessCount(String areaId, int conId) throws IOException, JSONException{
		int successCount = 0;
		String ingestionResponse = null;
		JSONObject responseObject = null;		
		if(getProperty("env").equals("CAAT")){
			ingestionResponse = given().queryParameter("mimeType", "application/json").when().get(areaId + "/ingest/" + conId).asString();
			responseObject = new JSONObject(ingestionResponse);
			successCount = responseObject.getJSONObject("failures").getInt("successCount");							
		}else if(getProperty("env").equals("MP")){				
			ingestionResponse = given().header("Content-Type","application/json").when().get(areaId + "/ingest/" + conId).asString();
			responseObject = new JSONObject(ingestionResponse);
			successCount = responseObject.getJSONObject("failures").getInt("successCount");			
		}
		
		return  successCount;
	}
	
	public JSONObject getTaskStatus(String areaId, String taskID) throws JSONException, InterruptedException{		
		String taskResponse = given().queryParam("mimeType","application/json").when().get(areaId + "/task/" + taskID).andReturn().getBody().asString();
		JSONObject jsonObj =  new JSONObject(taskResponse);		
		return jsonObj;
	}
	
	public JSONObject getExportStatus(String areaId, String exportID) throws JSONException{
		String exportResponse = given().queryParam("mimeType","application/json").when().get(areaId + "/export/" + exportID).andReturn().getBody().asString();
		JSONObject jsonObj =  new JSONObject(exportResponse);		
		return jsonObj;	
	}
		
	public void getIngestionExecutionTimes(String areaId) throws JSONException{		
		String ingestionResponse = given().header("Content-Type","application/json").when().get(areaId + "/ingest/" + "1").asString();
		JSONObject ingestionResponseObject = new JSONObject(ingestionResponse);
	
		long ingestioniStartTime= ingestionResponseObject.getJSONObject("status").getLong("lastRunStarted");
		long ingestionEndTime = ingestionResponseObject.getJSONObject("status").getLong("lastRunCompleted");		
		Timestamp ingestionMinTime = new Timestamp(ingestioniStartTime);
		Timestamp ingestionMaxTime = new Timestamp(ingestionEndTime);		
		ingestionStartTimesList.add(ingestionMinTime);
		ingestionEndTimesList.add(ingestionMaxTime);
		
		ingStartTime = new Timestamp(ingestioniStartTime);
		ingEndTime = new Timestamp(ingestionEndTime);		
	}
	
	public void getTaskExecutionTimes(String areaId) throws JSONException, InterruptedException{		
		String taskResponse = given().queryParam("mimeType","application/json").when().get(areaId + "/task/" + "EmailThreadingAndNearDupTask").andReturn().getBody().asString();
		JSONObject jsonObj =  new JSONObject(taskResponse);
	
		while(jsonObj.isNull("dateCompleted")){
			Thread.sleep(1000);
			jsonObj = getTaskStatus(areaId, "EmailThreadingAndNearDupTask");
		}	
				
		long taskStartTime= jsonObj.getLong("dateStarted");
		long taskEndTime= jsonObj.getLong("dateCompleted");						
		Timestamp taskMinTime = new Timestamp(taskStartTime);
		Timestamp taskMaxTime = new Timestamp(taskEndTime);		
		taskStartTimesList.add(taskMinTime);
		taskEndTimesList.add(taskMaxTime);
		
		tskStartTime = new Timestamp(taskStartTime);
		tskEndTime = new Timestamp(taskEndTime);
	}
	
	public void calculateTaskDurationInParallelRuns(String threadCount){
		
		Date ingMaxDateTime = null;
		Date ingMinDateTime = null;
		Date taskMaxDateTime = null;
		Date taskMinDateTime = null;
		long elapsedTimeForInginSeconds = 12345678910L;
		long elapsedTimeForTaskInSeconds = 12345678910L;
		long elapsedTimeForInginMinutes	 = 12345678910L;
		long elapsedTimeForTaskInMinutes = 12345678910L;
		long elapsedTimeForInginHours = 12345678910L;
		long elapsedTimeForTaskInHours = 12345678910L;
				
		if(ingestionStartTimesList.size() > 0 && ingestionEndTimesList.size() > 0){
			automicInt = new AtomicInteger(1);						
			ingMaxDateTime = ingestionEndTimesList.stream().max(Date::compareTo).get();
			ingMinDateTime = ingestionStartTimesList.stream().min(Date::compareTo).get();						
			elapsedTimeForInginSeconds = TimeUnit.MILLISECONDS.toSeconds(ingMaxDateTime.getTime() - ingMinDateTime.getTime());
			elapsedTimeForInginMinutes = TimeUnit.MILLISECONDS.toMinutes(ingMaxDateTime.getTime() - ingMinDateTime.getTime());
			elapsedTimeForInginHours = TimeUnit.MILLISECONDS.toHours(ingMaxDateTime.getTime() - ingMinDateTime.getTime());
			scalabilityMetricsResultData.put(automicInt, new Object[]{threadCount, "Ingestion", ingMaxDateTime, ingMinDateTime, elapsedTimeForInginSeconds, elapsedTimeForInginMinutes, elapsedTimeForInginHours});			
		}			
		
		if(taskStartTimesList.size() > 0 && taskEndTimesList.size() > 0){
			automicInt = new AtomicInteger(1);			
			taskMaxDateTime = taskEndTimesList.stream().max(Date::compareTo).get();
			taskMinDateTime = taskStartTimesList.stream().min(Date::compareTo).get();							
			elapsedTimeForTaskInSeconds =  TimeUnit.MILLISECONDS.toSeconds(taskMaxDateTime.getTime() - taskMinDateTime.getTime());
			elapsedTimeForTaskInMinutes =  TimeUnit.MILLISECONDS.toMinutes(taskMaxDateTime.getTime() - taskMinDateTime.getTime());
			elapsedTimeForTaskInHours =  TimeUnit.MILLISECONDS.toHours(taskMaxDateTime.getTime() - taskMinDateTime.getTime());
			scalabilityMetricsResultData.put(automicInt, new Object[]{threadCount, "Task", taskMaxDateTime, taskMinDateTime, elapsedTimeForTaskInSeconds, elapsedTimeForTaskInMinutes, elapsedTimeForTaskInHours});
		}		
		
		if(ingMinDateTime != null && taskMaxDateTime != null){
			automicInt = new AtomicInteger(1);			
			long elapsedTimeForIngAndTaskInSeconds = TimeUnit.MILLISECONDS.toSeconds(taskMaxDateTime.getTime() - ingMinDateTime.getTime());
			long elapsedTimeForIngAndTaskInMinutes = TimeUnit.MILLISECONDS.toMinutes(taskMaxDateTime.getTime() - ingMinDateTime.getTime());
			long elapsedTimeForIngAndTaskInHours = TimeUnit.MILLISECONDS.toHours(taskMaxDateTime.getTime() - ingMinDateTime.getTime());
			scalabilityMetricsResultData.put(automicInt, new Object[]{threadCount, "IngestionAndTask", taskMaxDateTime, ingMinDateTime, elapsedTimeForIngAndTaskInSeconds, elapsedTimeForIngAndTaskInMinutes, elapsedTimeForIngAndTaskInHours});
		}		
	}
	
	
	public void calculateMetricsForVolumeTest(){
		
	}
	
	public String getLogFileName(String testName){
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss");
		String logFileName = testName + "_" + dateFormat.format(new Date()) + ".log";
		return logFileName;
	}
	
	public int getConnectorId() {
		return connectorId;
	}

	public void setConnectorId(int connectorId) {
		this.connectorId = connectorId;
	}
		
	public int getIngestedCount() {
		return ingestedCount;
	}

	public void setIngestedCount(int ingestedCount) {
		this.ingestedCount = ingestedCount;
	}

	public int getNumProcessed() {
		return numProcessed;
	}

	public void setNumProcessed(int numProcessed) {
		this.numProcessed = numProcessed;
	}

	public void deleteStagingArea(){
		//TODO
	}
	
	public void deleteConnector(){
		//TODO
	}

}
