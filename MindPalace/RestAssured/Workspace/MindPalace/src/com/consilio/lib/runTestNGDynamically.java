package com.consilio.lib;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.testng.TestNG;
import org.testng.reporters.JUnitXMLReporter;
import org.testng.xml.XmlClass;
import org.testng.xml.XmlInclude;
import org.testng.xml.XmlSuite;
import org.testng.xml.XmlTest;
import org.uncommons.reportng.HTMLReporter;

import com.consilio.CAMethods.EnumFactory.guiceStage;

public class runTestNGDynamically {
	private List<XmlInclude> xmlincludes = new ArrayList<XmlInclude>();
	private Boolean includeMethod = false;
	private String suiteName;
	private String testName;
	private guiceStage gStage = guiceStage.NULL;
	private int threadCount;
	private Boolean preserveOrder = true;
	private String className;
	
	public void setClassName(String className)
	{
		this.className = className;
	}
	
	private void setPreserveOrder(Boolean preserveOrder)
	{
		this.preserveOrder = preserveOrder;
	}
	
	public void setTestName(String testName)
	{
		this.testName = testName;
	}
	
	public void setThreadCount(int threadCount)
	{
		this.threadCount = threadCount;
	}
	
	public void setGuiceStage(guiceStage gStage )
	{
		this.gStage = gStage;
	}
	
	public void setSuiteName(String suiteName)
	{
		this.suiteName = suiteName;
	}
	
	public String getSuiteName()
	{
		return suiteName;
	}
	
	public guiceStage getGuiceStage()
	{
		if(gStage.equals(guiceStage.NULL))
		{
			gStage = guiceStage.DEVELOPMENT;
		}
		return gStage;
	}
	
	public int getThreadCount()
	{
		return threadCount;
	}
	
	public String getTestName()
	{
		return testName;
	}
	
	public String getPreserveOrder()
	{
		return preserveOrder.toString();
	}
	
	public String getClassName()
	{
		return className;
	}
	
	
	public void setIncludeMethodList(List<String> includeMethods)
	{
		if(includeMethods.size() > 0)
		{
			includeMethod = true;
		}
			
		if(includeMethods.size() == 1){
		xmlincludes.add(new XmlInclude(includeMethods.get(0)));
		}	
		else if(includeMethods.size() >1)
		{
			for(int i =0; i<includeMethods.size();i++)
			{
				xmlincludes.add(new XmlInclude(includeMethods.get(i)));
			}
		}
	}
	
	public List<XmlInclude> getIncludeMethodList()
	{
		return xmlincludes;
	}
	
	public void runTestNGTest(Map<String,String> testngParams)
	{
		TestNG testng = new TestNG();
		XmlTest test = new XmlTest();
		XmlSuite suite = new XmlSuite();
		List<XmlClass> classes = new ArrayList<XmlClass>();
		List<XmlTest> tests = new ArrayList<XmlTest>();
		List<XmlSuite> suites = new ArrayList<XmlSuite>();
				
		testng.addListener(new HTMLReporter());
		testng.addListener(new JUnitXMLReporter());
		
		suite.setName(getSuiteName());
		suite.setGuiceStage(getGuiceStage().toString());
		suite.setDataProviderThreadCount(getThreadCount());
		
		test.setName(getTestName());
		test.setVerbose(2);
		test.setPreserveOrder(getPreserveOrder());
		test.setParameters(testngParams);
		test.setSuite(suite);
		
		XmlClass class1 = new XmlClass(getClassName());
		classes.add(class1);
		test.setClasses(classes);
		
		//this is the addition for include method
		if(includeMethod.equals(true))
		{
		class1.getIncludedMethods().addAll(getIncludeMethodList());
		}
		
		tests.add(test);
		suite.setTests(tests);
		
		suites.add(suite);
		testng.setXmlSuites(suites);
		
		System.out.println(suites.toString());
		testng.run();
	}
}
