package com.consilio.lib;

import java.util.List;

import org.testng.IAlterSuiteListener;
import org.testng.xml.XmlSuite;

public class dataProviderThreadCountChanger implements IAlterSuiteListener {

	private int count = 0;
	
	public dataProviderThreadCountChanger(int count)
	{
	 this.count = count;	
	}
	
	@Override
	public void alter(List<XmlSuite> suites) {
		for (XmlSuite suite : suites)
		{
			suite.setDataProviderThreadCount(count);
			System.out.println(suite.getDataProviderThreadCount());
		}
		
	}

}
