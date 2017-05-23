package com.consilio.lib;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.testng.asserts.Assertion;
import org.testng.asserts.SoftAssert;




public class JsonCompareLib{
	
	String[] objectsToIgnore;
	private ArrayList<JsonCompareLib> instance = new ArrayList<JsonCompareLib>();
	private SoftAssert sa = new SoftAssert();
	private Assertion ha = new Assertion();
	private int level = 0;
	
	
	public void setObjectsToIgnore(String[] objectsToIgnore)
	{
		this.objectsToIgnore = objectsToIgnore;
	}
	
	private String[] getObjectsToIgnore()
	{
		return this.objectsToIgnore;
	}	
	
	private JsonCompareLib getInstance(int level)
	{
		return instance.get(level);
	}
	
	private void setInstance()
	{
		instance.add(new JsonCompareLib());
	}
	
	
	public void compareJSON(String expJson,String actJson) throws ParseException
	{
		boolean matchObject = false;
		
		JSONParser jp = new JSONParser();
		
		Object expObj = jp.parse(expJson);
		Object actObj = jp.parse(actJson);	
		
		if (expObj instanceof JSONObject && actObj instanceof JSONObject)
		{
		JSONObject expJO = (JSONObject) expObj;
		JSONObject actJO = (JSONObject) actObj;
		matchObject = validateJSON(expJO,actJO);
		ha.assertTrue(matchObject);
		}
		else if(expObj instanceof JSONArray && actObj instanceof JSONArray)
		{
			JSONArray expArrayJO = (JSONArray) expObj;
			JSONArray actArrayJO = (JSONArray) actObj;
			matchObject = validateJSONArray(expArrayJO,actArrayJO);
			ha.assertTrue(matchObject);
		}
		else if((expObj instanceof JSONArray != actObj instanceof JSONArray) || (expObj instanceof JSONObject != actObj instanceof JSONObject))
		{
			matchObject = false;
			ha.assertTrue(matchObject);
		}
		else
		{
			System.out.println("the expected and actual are not JSON");
		}
	}
	
	@SuppressWarnings("unchecked")
	private boolean validateJSON(JSONObject expectedJson, JSONObject actualJson) throws ParseException
	{
		boolean matchObject = false;
		boolean matchArray = false;
		boolean matchValue = false;
		boolean matchKey =false;
		int misMatch = 0;
		
		Iterator<String> expIterator = expectedJson.keySet().iterator();	
		
		retryExpObject: for(int i=0;i<expectedJson.size();i++)
		{
			matchObject = false;
			matchArray = false;
			matchValue = false;
			matchKey = false;
			String expKey = expIterator.next();
			Iterator<String> actIterator = actualJson.keySet().iterator();
			retryActObject: for(int j=0;j<actualJson.size();j++)
			{
				matchKey =false;
				String actKey = actIterator.next();
				HashSet<String> objectsIgnore = new HashSet<String>();
				Collections.addAll(objectsIgnore,getObjectsToIgnore());
				if(expKey.equals(actKey))
				{
					matchKey = true;					
					if(objectsIgnore.contains(expKey.toString()) == false)
					{
						Object expValue = expectedJson.get(expKey);
						Object actValue = actualJson.get(actKey);
						if(expValue instanceof JSONObject && actValue instanceof JSONObject)
						{
						setInstance();
						JsonCompareLib a = getInstance(level);
						level++;
						a.setObjectsToIgnore(getObjectsToIgnore());
						matchObject = a.validateJSON((JSONObject) expValue,(JSONObject) actValue);
						}
						else if(expValue instanceof JSONArray && actValue instanceof JSONArray)
						{
							JSONArray expArray = (JSONArray) expValue;
							JSONArray actArray = (JSONArray) actValue;
							
							if((expArray.size() == actArray.size()) && expArray.size()>0)
							{
							matchArray = validateJSONArray((JSONArray) expValue,(JSONArray) actValue);
							}
						}
						else if((expValue instanceof JSONArray != actValue instanceof JSONArray) || (expValue instanceof JSONObject != actValue instanceof JSONObject))
						{}
						else
						{
							try{
								if(expValue == null)
								{
									expValue =0;
								}
								if(actValue == null)
								{
									actValue =0;
								}
							}
							catch(NullPointerException e)
							{
								
							}
							if(expValue.equals(actValue))
							{
								matchValue = true;
							}
						}
					}
					else
					{
						matchValue = true;
					}
					}
				 if((j+1) == actualJson.size() && matchKey == false)
				{
					misMatch++;
					continue retryExpObject;
				}
				else if(matchKey == true && (matchValue == true || matchObject ==true ||matchArray == true))
				{
					continue retryExpObject;
				}
				else if(matchKey == true && matchValue == false && matchObject == false && matchArray == false)
				{
					return false;
				}
				else if((j+1) < actualJson.size() && matchKey == false)
				{
					continue retryActObject;
				}
			}
		}
		if (misMatch>0)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	
	private boolean validateJSONArray(JSONArray expArray, JSONArray actArray) throws ParseException
	{
		boolean matchObject = false;
		boolean matchArray = false;
		boolean matchValue = false;
		int misMatch = 0;
				Iterator<String> expArrayIterator = expArray.iterator();
			retryExpArray:	for(int i=0;i<expArray.size();i++)
				{
				matchObject = false;
				matchArray = false;
				matchValue = false;
					Object expArrayValue = expArrayIterator.next();
					Iterator<String> actArrayIterator = actArray.iterator();
				retryActArray:	for(int j=0;j<actArray.size();j++)
					{
						Object actArrayValue = actArrayIterator.next();
						
								if(expArrayValue instanceof JSONObject && actArrayValue instanceof JSONObject)
								{
									setInstance();
									JsonCompareLib a = getInstance(level);
									level++;
									a.setObjectsToIgnore(getObjectsToIgnore());
									matchObject = a.validateJSON((JSONObject) expArrayValue,(JSONObject) actArrayValue);
								}
								else if(expArrayValue instanceof JSONArray && actArrayValue instanceof JSONArray)
								{
									setInstance();
									JsonCompareLib a = getInstance(level);
									level++;
									a.setObjectsToIgnore(getObjectsToIgnore());
									matchArray = a.validateJSONArray((JSONArray) expArrayValue,(JSONArray) actArrayValue);
								}
								else if((expArrayValue instanceof JSONArray != actArrayValue instanceof JSONArray) || (expArrayValue instanceof JSONObject != actArrayValue instanceof JSONObject))
								{}
								else
								{
									try{
										if(expArrayValue == null)
										{
											expArrayValue =0;
										}
										if(actArrayValue == null)
										{
											actArrayValue =0;
										}
									}
									catch(NullPointerException e)
									{
										
									}
									if(expArrayValue.equals(actArrayValue))
									{
										matchValue = true;
									}
								}
								if((j+1)==actArray.size() && (matchObject == false && matchArray ==false && matchValue == false) )
								{
									misMatch++;
								sa.fail("this expValue is not available in actual value: "+expArrayValue);
								}
								else if(matchObject == false && matchArray ==false && matchValue == false )
								{
									continue retryActArray;
								}
								else if(matchObject == true || matchArray ==true || matchValue==true)
								{
								continue retryExpArray;	
								}
					}
				}
				if(misMatch>0)
				{
					return false;
				}
				else
				{
					return true;
				}
	}
}
