package com.consilio.lib;

import org.apache.log4j.Logger;

public class Log {

	private static Logger log = Logger.getLogger(Log.class.getName());

	public static void startTestCase(String sTestCaseName) {
		log.info("************************************************************");
		log.info("************************************************************");
		log.info("$$$$$$$$$$$$$$$$$$$ " + sTestCaseName + " $$$$$$$$$$$$$$$$$$$$");
		log.info("************************************************************");
		log.info("************************************************************");
	}

	public static void endTestCase(String sTestCaseName) {
		log.info("XXXXXXXXXXXXXXXXXXXX" + "-E---N---D-" + "XXXXXXXXXXXXXXXXXXX");
		log.info("X");
		log.info("X");
		log.info("X");
		log.info("X");
	}

	public static void info(String message) {
		log.info(message);
	}

	public static void warn(String message) {
		log.warn(message);
	}

	public static void error(String message) {
		log.error(message);
	}

	public static void fatal(String message) {
		log.fatal(message);
	}

	public static void debug(String message) {
		log.debug(message);
	}
}
