package com.consilio.CAMethods;

public class EnumFactory {
	
	protected enum indexStatus {
		indexAreaCreated,
		indexAreaFailed,
		indexAreaExist,
		indexAreaDeleted,
		urlUnavailable
	}
	
	protected enum connectorStatus {
		connectorCreated,
		connectorExist,
		connectorDeleted,
		connectorFailed,
		indexUnavailable,
		urlUnavailable
	}

	protected enum ingestionStatus {
		ingestionCompleted,
		ingestionInProgress,
		ingestionErrored,
		indexUnavailable,
		urlUnavailable,
		connectorUnavailable,
		none
	}
	
	protected enum buildStatus {
		buildCompleted,
		buildInProgress,
		buildErrored,
		indexUnavailable,
		urlUnavailable,
		none
	}
	
	protected enum queriesStatus {
		enabled,
		disabled,
		indexUnavailable,
		urlUnavailable,
		buildUnavailable
	}
	
	protected enum searchStatus {
		searchCompleted,
		searchErrored,
		indexUnavailable,
		urlUnavailable,
		searchInProgress
	}
		
	public enum guiceStage
	{
		DEVELOPMENT,
		PRODUCTION,
		TOOL,
		NULL
	}

}
