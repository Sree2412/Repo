package com.consilio.lib;

import java.io.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.atomic.AtomicInteger;

import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.xssf.usermodel.*;

public class ExcelUtils {

	static Workbook workBook;
	static Workbook metadataMetricsWBook;
	static Workbook scalabilityMetricsWBook;
	static Sheet sheet;
	static Sheet metadataSheet;
	static Sheet scalabilitySheet;
	static Cell cell;
	static Row row;

	public static Object[][] getArray(String filePath, String sheetName) throws Exception{
		String[][] tabArray = null;
		workBook = null;
		sheet = null;
		cell = null;
		row = null;		
		
		DataFormatter formatter = new DataFormatter();
		File file = new File(filePath);
		workBook = new XSSFWorkbook(file.getAbsolutePath());		
		sheet = workBook.getSheet(sheetName);				
		
		int totalRows = sheet.getLastRowNum();
		int totalCols = sheet.getRow(0).getLastCellNum();
		tabArray = new String[totalRows][totalCols];
		int startRow = 1;
		for (int i=startRow;i<=totalRows;i++) {
			   for (int j=0;j<=totalCols-1;j++){
				   cell = sheet.getRow(i).getCell(j);
				   tabArray[i-1][j]=formatter.formatCellValue(cell);
					}			
		}		
		return (tabArray);		
	}
	
	public static Object[][] getArrayBasedOnRowCount(String filePath, String sheetName, int rowCount) throws Exception{
		String[][] tabArray = null;
		workBook = null;
		sheet = null;
		cell = null;
		row = null;		
		
		DataFormatter formatter = new DataFormatter();
		File file = new File(filePath);
		workBook = new XSSFWorkbook(file.getAbsolutePath());		
		sheet = workBook.getSheet(sheetName);				
		
		int totalRows = rowCount; //sheet.getLastRowNum();
		int totalCols = sheet.getRow(0).getLastCellNum();
		tabArray = new String[totalRows][totalCols];
		int startRow = 1;
		for (int i=startRow;i<=totalRows;i++) {
			   for (int j=0;j<=totalCols-1;j++){
				   cell = sheet.getRow(i).getCell(j);
				   tabArray[i-1][j]=formatter.formatCellValue(cell);
					}			
		}		
		return (tabArray);		
	}
			
	public static void setExcelFile(){
		metadataMetricsWBook = new XSSFWorkbook();
		scalabilityMetricsWBook = new XSSFWorkbook();
		metadataSheet = metadataMetricsWBook.createSheet("ET_ND_Metrics");
		scalabilitySheet = scalabilityMetricsWBook.createSheet("ScalabilityMetrics");		
	}
	
	public static void writeMetricsToExcelNew(String testName, String type, Map<AtomicInteger, Object[]> resultData) throws FileNotFoundException, IOException{
		Set<AtomicInteger> keySet = resultData.keySet();
		
		if(type.equalsIgnoreCase("metadata")){
			sheet = metadataSheet;
			workBook = metadataMetricsWBook;
		}else{
			sheet = scalabilitySheet;
			workBook = scalabilityMetricsWBook;
		}
		
		int rowNo = 0;
		for (AtomicInteger key: keySet){
			Row row = sheet.createRow(rowNo++);
			Object[] objArr = resultData.get(key);
			int cellNo = 0;
			for (Object obj: objArr){
				Cell cell = row.createCell(cellNo++);
				if(obj instanceof Date)
					cell.setCellValue((Date) obj);
				else if(obj instanceof Boolean)
					cell.setCellValue((Boolean) obj);
				else if(obj instanceof String)
					cell.setCellValue((String) obj);
				else if(obj instanceof Double)
					cell.setCellValue((Double) obj);	
				else if(obj instanceof Long)
					cell.setCellValue((Long) obj);
			}
		}				
		String metricsLogFileName = getMetricsLogFileName(testName);
		FileOutputStream fos = new FileOutputStream("resources\\metrics\\" + metricsLogFileName);
		workBook.write(fos);
		fos.close();		
	}
	
	public static void writeMetricsToExcel(String testName, String type, Map<AtomicInteger, Object[]> resultData) throws FileNotFoundException, IOException{
		Set<AtomicInteger> keySet = resultData.keySet();
		
		if(type.equalsIgnoreCase("metadata")){
			sheet = metadataSheet;
			workBook = metadataMetricsWBook;
		}else{
			sheet = scalabilitySheet;
			workBook = scalabilityMetricsWBook;
		}
		
		int rowNo = 0;
		for (AtomicInteger key: keySet){
			Row row = sheet.createRow(rowNo++);
			Object[] objArr = resultData.get(key);
			int cellNo = 0;
			for (Object obj: objArr){
				sheet.autoSizeColumn(cellNo);
				Cell cell = row.createCell(cellNo++);				
				if(obj instanceof Date)
					cell.setCellValue((Date) obj);
				else if(obj instanceof Boolean)
					cell.setCellValue((Boolean) obj);
				else if(obj instanceof String)
					cell.setCellValue((String) obj);
				else if(obj instanceof Double)
					cell.setCellValue((Double) obj);	
				else if(obj instanceof Long)
					cell.setCellValue((Long) obj);
			}
		}				
		String metricsLogFileName = getMetricsLogFileName(testName);		
		FileOutputStream fos = new FileOutputStream("resources\\metrics\\" + metricsLogFileName);
		workBook.write(fos);
		fos.close();		
	}
	
	public static String getMetricsLogFileName(String testName){
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss");
		String logFileName = testName + "_" + dateFormat.format(new Date()) + ".xlsx";
		return logFileName;
	}
	
	/*public static void setExcelHeader(){
		workBook = new XSSFWorkbook();
		sheet = workBook.createSheet();
		Font font = workBook.createFont();
		font.setBoldweight(Font.BOLDWEIGHT_BOLD);
		CellStyle style = workBook.createCellStyle();
		style.setFont(font);
		style.setFillForegroundColor(IndexedColors.LIGHT_ORANGE.index);
		
		row = sheet.createRow(0);
		Cell hdTestCaseName = row.createCell(0);
		hdTestCaseName.setCellValue("TestCaseName");
		hdTestCaseName.setCellStyle(style);
		
		Cell hdMetadataField = row.createCell(1);
		hdMetadataField.setCellValue("Metadata Field");
		hdMetadataField.setCellStyle(style);
		
		Cell hdTotalNoOfDocsInDataset = row.createCell(2);
		hdTotalNoOfDocsInDataset.setCellValue("Precision");
		hdTotalNoOfDocsInDataset.setCellStyle(style);
		
		Cell hdTotalNoOfMatchedDocs = row.createCell(3);
		hdTotalNoOfMatchedDocs.setCellValue("Recall");
		hdTotalNoOfMatchedDocs.setCellStyle(style);		
	}
	
	public static void writeMetricsToExcel1(String testName, Map<AtomicInteger, Object[]> resultData) throws FileNotFoundException, IOException{
		workBook.write(new FileOutputStream("resources\\metrics\\" + getMetricsLogFileName(testName)));
		workBook.close();
		
		Set<AtomicInteger> keySet = resultData.keySet();
		int rowNo = 0;
		for (AtomicInteger key: keySet){
			Row row = metadataSheet.createRow(rowNo++);
			Object[] objArr = resultData.get(key);
			int cellNo = 0;
			for (Object obj: objArr){
				Cell cell = row.createCell(cellNo++);
				if(obj instanceof Date)
					cell.setCellValue((Date) obj);
				else if(obj instanceof Boolean)
					cell.setCellValue((Boolean) obj);
				else if(obj instanceof String)
					cell.setCellValue((String) obj);
				else if(obj instanceof Double)
					cell.setCellValue((Double) obj);				
			}
		}
				
		String metricsLogFileName = getMetricsLogFileName(testName);
		FileOutputStream fos = new FileOutputStream("resources\\metrics\\" + metricsLogFileName);
		metadataMetricsWBook.write(fos);
		fos.close();		
	}
	
	public static void writeTestCaseMetricsToExcel(String testCaseName, String attrToCompare, String precision, String recall){
		int newRowIndex = sheet.getLastRowNum() + 1;			  
		row = sheet.createRow(newRowIndex);	 
		Cell name = row.createCell(0);
		name.setCellValue(testCaseName);
		Cell attribute = row.createCell(1);
		attribute.setCellValue(attrToCompare);			
		Cell totalDocs = row.createCell(2);
		totalDocs.setCellValue(precision);
		Cell matchedDocs1 = row.createCell(3);
		matchedDocs1.setCellValue(recall);
				
		for(int colNo = 0; colNo < row.getLastCellNum(); colNo++){
			sheet.autoSizeColumn(colNo);
		}
	}
	
	public static void setExcelFile(String Path, String SheetName) throws IOException {
		// Open the Excel file
		FileInputStream ExcelFile = new FileInputStream(Path);
		// Access the required test data sheet
		workBook = new XSSFWorkbook(ExcelFile);
		sheet = workBook.getSheet(SheetName);
	}

	public static String getCellData(int RowNum, int ColNum) {
		cell = sheet.getRow(RowNum).getCell(ColNum);
		int dataType = cell.getCellType();
		if (dataType == 3) {
			return "";
		} else {
			String CellData = cell.getStringCellValue();
			return CellData;
		}
	}

	public void setCellData(String Result, int RowNo, int ColNo, String Path, String SheetName) throws Exception {
		try {
			workBook = new XSSFWorkbook();
			sheet = workBook.createSheet(SheetName);
			row = sheet.createRow(RowNo);
			cell = row.createCell(ColNo);
			cell.setCellValue(Result);

			FileOutputStream fileout = new FileOutputStream(Path);
			workBook.write(fileout);
			fileout.flush();
			fileout.close();
		} catch (Exception e) {
			throw (e);
		}
	}*/
}
