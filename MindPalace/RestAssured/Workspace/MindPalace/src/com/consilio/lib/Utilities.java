package com.consilio.lib;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Properties;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathFactory;

import org.custommonkey.xmlunit.Diff;
import org.custommonkey.xmlunit.ElementNameAndAttributeQualifier;
import org.custommonkey.xmlunit.XMLUnit;
import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class Utilities {
	DocumentBuilderFactory docBuilderFactory;
	DocumentBuilder builder;
	Document resultedDoc;
	Node rootElement;
	Node stagingAreaIdNode;
	Node exportDateNode;
	NamedNodeMap rootElementAttributes;
	TransformerFactory transformerFactory;
	Transformer transformer;
	DOMSource source;
	StreamResult result;	
	Properties p;
	
	public Properties getProperties() throws IOException{			
		p = new Properties();
		File file = new File("resources\\properties\\prop.properties");
		FileInputStream fis = new FileInputStream(file.getAbsolutePath());
		p.load(fis);		
		return p;
	}
	
	public String getProperty(String key) throws IOException{
		return getProperties().getProperty(key);		
	}	
	
	public String getDataFromTestRepoXml(String tagName) throws Exception {
		DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
		File xmlFile=new File("resources/testrepo/TestRepo.xml");
		Document doc = docBuilder.parse (xmlFile.getAbsolutePath());	
		return doc.getElementsByTagName(tagName).item(0).getTextContent();
	}
	
	public boolean areXMLFilesSimilar(String sourceFile, String destinationFile) throws ParserConfigurationException, FileNotFoundException, SAXException, IOException{		
		docBuilderFactory = DocumentBuilderFactory.newInstance();
		builder = docBuilderFactory.newDocumentBuilder();
		Document mockDoc = builder.parse(new FileInputStream(sourceFile));
		Document updatedResultDoc = builder.parse(new FileInputStream(destinationFile));
		
		Diff diff = XMLUnit.compareXML(mockDoc, updatedResultDoc);
		diff.overrideElementQualifier(new ElementNameAndAttributeQualifier());
		//System.out.println(diff);		
		//System.out.println(diff.similar());
		//Assert.assertTrue(diff.similar());
		return diff.similar();
	}
	
	public boolean areXMLFilesIdentical(String sourceFile, String destinationFile) throws ParserConfigurationException, FileNotFoundException, SAXException, IOException{		
		if (sourceFile != null && destinationFile != null){
			docBuilderFactory = DocumentBuilderFactory.newInstance();
			builder = docBuilderFactory.newDocumentBuilder();
			Document mockDoc = builder.parse(new FileInputStream(sourceFile));
			Document updatedResultDoc = builder.parse(new FileInputStream(destinationFile));
			
			Diff diff = XMLUnit.compareXML(mockDoc, updatedResultDoc);
			diff.overrideElementQualifier(new ElementNameAndAttributeQualifier());
			//System.out.println(diff);		
			//System.out.println(diff.identical());
			//Assert.assertTrue(diff.identical());
			return diff.identical();
		}else{
			return false;
		}		
	}
	
	public void updateXMLAttribute(String sourceXMLFile, String destXMLFile, HashMap<String, String> attributeList) throws ParserConfigurationException, FileNotFoundException, SAXException, IOException, TransformerException{
		String stagingAreaIdAttribute = attributeList.get("stagingAreaIdAttribute");
		String exportDateAttribute = attributeList.get("exportDateAttribute");		
		//File resultedFile = new File(sourceFilePath.trim() + sourceFileName.trim());
		File resultedFile = new File(sourceXMLFile.trim());
		docBuilderFactory = DocumentBuilderFactory.newInstance();
		builder = docBuilderFactory.newDocumentBuilder();
		resultedDoc = builder.parse(new FileInputStream(resultedFile));
		rootElement = resultedDoc.getFirstChild();
		rootElementAttributes = rootElement.getAttributes();
		stagingAreaIdNode = rootElementAttributes.getNamedItem(stagingAreaIdAttribute);
		stagingAreaIdNode.setTextContent("1");
		exportDateNode = rootElementAttributes.getNamedItem(exportDateAttribute);
		exportDateNode.setTextContent("1");		
		transformerFactory = TransformerFactory.newInstance();
		transformer = transformerFactory.newTransformer();
		source = new DOMSource(resultedDoc);
		File modifiedFile = new File(destXMLFile.trim());
		result = new StreamResult(new File(modifiedFile.getAbsolutePath()));			
		transformer.transform(source, result);			
	}
	
	public Document createDocument(File file) throws Exception{
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db;
		Document doc;
		try {
			db = dbf.newDocumentBuilder();
			doc = db.parse(file);
		} catch (ParserConfigurationException | SAXException | IOException e) {
			throw e;
		}				
		return doc;
	}
	
	 public XPath createXPath() {
			final XPathFactory xpathFactory = XPathFactory.newInstance();
			final XPath xpath = xpathFactory.newXPath();
			return xpath;
	}

	public static Collection<String> convertToCollection(final NodeList nodes) {
	        final Collection<String> result = new ArrayList<String>();
	        if (nodes != null) {
	            for (int i = 0; i < nodes.getLength(); i++) {
	                result.add(nodes.item(i).getNodeValue());
	            }
	        }	       
	        return result;
    }	
	
	public void waitFor(int millisec){

		try {
			Thread.sleep(millisec);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
}
