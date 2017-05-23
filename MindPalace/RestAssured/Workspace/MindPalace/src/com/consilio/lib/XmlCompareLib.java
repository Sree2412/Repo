package com.consilio.lib;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.testng.Assert;
import org.testng.asserts.Assertion;
import org.testng.asserts.SoftAssert;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class XmlCompareLib extends Assert {
	
	
	private String[] attributesToIgnore;
	private ArrayList<XmlCompareLib> instance = new ArrayList<XmlCompareLib>();
	private SoftAssert sa = new SoftAssert();
	private Assertion ha = new Assertion();
	private NodeList expNL;
	private NodeList actNL;
	private int level =0;
	
	
	public XmlCompareLib(){}
	
	
	
	private XmlCompareLib getInstance(int level)
	{
		return instance.get(level);
	}
	
	private void setInstance()
	{
		instance.add(new XmlCompareLib());
	}
	
	public String[] getAttributesToIgnore() {
		return attributesToIgnore;
	}

	public void setAttributesToIgnore(String[] attributesToIgnore) {
		this.attributesToIgnore = attributesToIgnore;
	}

	public void compareXML(String expectedXML,String actualXML) 
	{
		String sCurrentLine;
		String sCurrentLine1;
		String expXML = "";
		String actXML = "";
		BufferedReader brExp = null;
		BufferedReader brAct = null;
		try {
			
		brExp = new BufferedReader(new FileReader(expectedXML));
		brAct = new BufferedReader(new FileReader(actualXML));
		
		while ((sCurrentLine = brExp.readLine()) != null) {
			expXML = expXML + sCurrentLine;
		}
		while ((sCurrentLine1 = brAct.readLine()) != null) {
			actXML = actXML + sCurrentLine1;
		}

	} catch (IOException er) {
		er.printStackTrace();
	} finally {
		try {
			if (brExp != null)brExp.close();
			if (brAct != null)brAct.close();
		} catch (IOException ex) {
			ex.printStackTrace();
		}
	}

		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		dbf.setCoalescing(true);
		dbf.setIgnoringElementContentWhitespace(true);
		dbf.setIgnoringComments(true);
		DocumentBuilder db = null;
		
		try {
			db = dbf.newDocumentBuilder();
		} catch (ParserConfigurationException e) {
			ha.fail("Error testing XML: "+e);
		}
		
		Document expXMLDoc = null;
		Document actXMLDoc = null;
		
		try {
			expXMLDoc = db.parse(new ByteArrayInputStream(expXML.getBytes()));
			expXMLDoc.normalizeDocument();

			actXMLDoc = db.parse(new ByteArrayInputStream(actXML.getBytes()));
			actXMLDoc.normalizeDocument();
		} catch (SAXException e) {
			ha.fail("Could not parse testXML with error: "+e);
		} catch (IOException e) {
			ha.fail("Could not read testXML with error: "+e);
		}
		
		NodeList expNL = expXMLDoc.getChildNodes();
		NodeList actNL = actXMLDoc.getChildNodes();
		
		validateXML(expNL,actNL,db);
	}
	
	private void validateXML(NodeList expInput, NodeList actInput, DocumentBuilder db)
	{
		Boolean matchAttr = false;
		@SuppressWarnings("unused")
		Boolean matchNodeName = false;
		Boolean matchNodeValue = false;
		Boolean hasAttributes = false;
		
		if(expInput.getLength() == actInput.getLength())
		{
			if(expInput.getLength()>0)
			{					
			 next: for(int i=0;i<expInput.getLength();++i)
				{
					
				Node eN = expInput.item(i);
				try
				{
					if(eN.getNodeValue().trim().equals(""))
					{
						eN.setNodeValue("null");
					}
				}
				catch (NullPointerException e)
				{
					
				}
								
				 for(int j=0;j<actInput.getLength();++j)
					{
						matchAttr = false;
						matchNodeName = false;
						matchNodeValue = false;
						hasAttributes = false;
						
					 Node aN = actInput.item(j);
					 try
						{
							if(aN.getNodeValue().trim().equals(""))
							{
								aN.setNodeValue("null");
							}
						}
						catch (NullPointerException e)
						{
							
						}
					
						if(eN.getNodeName() == aN.getNodeName())
						{
							matchNodeName = true;
							if((eN.getNodeType() == Node.TEXT_NODE && eN.getTextContent().equals(aN.getTextContent())) || (eN.getNodeType() != Node.TEXT_NODE && eN.getNodeValue() == aN.getNodeValue())) 
							{
								matchNodeValue = true;
								if(eN.hasAttributes() && aN.hasAttributes())
								{
									hasAttributes = true;
									if(eN.getAttributes().getLength() == aN.getAttributes().getLength())
									{
										if(hasAttributes == true)
										{
											matchAttr = validateAttributes(eN,aN);
											if(matchAttr == true && eN.hasChildNodes() == true && aN.hasChildNodes() == true)
												{
													setInstance();
													level++;
													XmlCompareLib a = getInstance(level-1);
													a.actNL = aN.getChildNodes();
													a.expNL = eN.getChildNodes();
													a.setAttributesToIgnore(getAttributesToIgnore());
													a.validateXML(a.expNL, a.actNL, db);
												}
										}
										else
										{
											if( eN.hasChildNodes() == true && aN.hasChildNodes() == true)
											{
												level++;
												XmlCompareLib a = getInstance(level-1);
												a.actNL = aN.getChildNodes();
												a.expNL = eN.getChildNodes();
												a.setAttributesToIgnore(getAttributesToIgnore());
												a.validateXML(a.expNL, a.actNL, db);
											}	
										}
									}
								}
							}
						}
						
						if((j+1) == actInput.getLength())
						{ 
							if(matchNodeName = false)
							{
							ha.fail("Expected Node... "+eN.getNodeName()+"...was not available in actual results");
							}
							if(matchAttr == false && hasAttributes == true)
							{
							ha.fail("Expected attributes are not available in actual results.");
							}
							continue next;
						}
						else
						{
							if((hasAttributes == false && matchNodeValue == true) ||matchAttr == true)
							{
									continue next;
							}
							continue;
						}
					}
					
				}
				
			}	
		}
		else
		{
			sa.fail("XML mismatch: expected roots: "+expNL.getLength()+" but has: "+actNL.getLength());
		}
	}
	
	private Boolean validateAttributes(Node expectedNode, Node actualNode)
	{
		Boolean matchName = false;
		Boolean matched = false;
		
		if(expectedNode.getAttributes().getLength() > 0)
			{
		nextAttr: for(int i=0; i<expectedNode.getAttributes().getLength();++i)
				{
				matchName = false;
				matched = false;
					
					Node expAttributeNode = expectedNode.getAttributes().item(i);
					for(int j=0;j<actualNode.getAttributes().getLength();++j)
					{
						Node actAttributeNode = actualNode.getAttributes().item(j);
						if(expAttributeNode.getNodeName() == actAttributeNode.getNodeName())
						{
							matchName = true;
							if(expAttributeNode.getTextContent().equals(actAttributeNode.getTextContent()))
							{
								matched = true;
								if((j+1) == actualNode.getAttributes().getLength())
								{
									return true;
								}
								else
								{
									continue nextAttr;
								}
							}
							
						}
							if((j+1) == actualNode.getAttributes().getLength())
							{
								if(matchName == true && matched == false)
								{
									HashSet<String> ignoreAttributes = new HashSet<String>();
									Collections.addAll(ignoreAttributes,getAttributesToIgnore());
									if(ignoreAttributes.contains(expAttributeNode.getNodeName())==false)
									{
										return false;
									}
									else
									{
										return true;
									}
								}
								else
								{
									return false;
								}
							}
							else
							{
								continue;
							}
						}
				}
			}
		return true;
	}

}
