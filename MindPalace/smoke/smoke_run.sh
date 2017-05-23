#!/bin/bash
source smoke_rest.sh
source smoke_echo.sh

stop_mind_palace() {

    if [ -n "$REST_SCREEN_PID" ]; then
        echo_status "Stopping rest interface"
        kill $REST_SCREEN_PID > /dev/null
        if [ $? == 0 ]; then
            echo_ok
        else
            echo_error
            exit 1
        fi
    fi

    if [ -n "$DAEMON_SCREEN_PID" ]; then
        echo_status "Stopping daemon"
        kill $DAEMON_SCREEN_PID > /dev/null
        if [ $? == 0 ]; then
            echo_ok
        else
            echo_error
            exit 1
        fi
    fi
}


smoke_test_success() {

    stop_mind_palace
    echo ''
    echo_status "SMOKE TEST COMPLETE"
    echo_ok
    echo ''
}


smoke_test_failed() {

    stop_mind_palace
    echo ''
    echo_status "SMOKE TEST COMPLETE"
    echo_error
    echo ''
    exit 1
}


echo_export_progress() {
    #echo -e -n "\033[1K\r\e[38;5;15mExport completed in $SECONDS seconds\e[0m"
    echo -e -n "."
}


get_connector_state() {
    curl -s -XGET $1 | jq -r .status.state
}

get_document_count() {
    DOCUMENT_COUNT=`curl -s -XGET http://localhost:9200/$STAGING_AREA/items/_count | jq .count`
}

echo_connector_progress() {
    #echo -e -n "\033[1K\r\e[38;5;15mIngested in $SECONDS seconds:$ECHO_RESULT\e[38;5;15m[\e[38;5;11m $DOCUMENT_COUNT \e[38;5;15m]\e[0m"
    echo -e -n "."
}

echo_ingestion_results() {
    echo ""
    echo_line "Ingested $DOCUMENT_COUNT documents in $SECONDS seconds."
}

get_email_threading_and_near_dup_task_error() {
    curl -s -XGET http://localhost:5000/staging/$STAGING_AREA/task/EmailThreadingAndNearDupTask | jq .error
}

get_email_threading_and_near_dup_task_state() {
    curl -s -XGET http://localhost:5000/staging/$STAGING_AREA/task/EmailThreadingAndNearDupTask | jq -r .runningInfo
}

get_email_threading_processed_count() {
    curl -s -XGET http://localhost:5000/staging/$STAGING_AREA/task/EmailThreadingAndNearDupTask | jq -r .numProcessed
}

echo_task_progress() {
    #echo -e -n "\033[1K\r\e[38;5;15mElasped $SECONDS seconds:$ECHO_RESULT\e[38;5;15m[\e[38;5;11m $TASK_STATE \e[38;5;15m]\e[0m"
    echo -e -n "."
}

echo_task_results() {
    #echo -e -n "\033[1K\r\e[38;5;15mElasped $SECONDS seconds:$ECHO_RESULT\e[38;5;15m[\e[38;5;11m $TASK_STATE \e[38;5;15m]\e[0m"
    echo_line "Task completed in $SECONDS seconds..."
}


execute_export_results() {

    post_request "$1" http://localhost:5000/staging/$STAGING_AREA/export?op=startExport ../smoke/json/$2
    echo_status "Exporting"
    if [ $? == 0 ]; then

	EXPORT_ID=$POST_RESULT
	IS_COMPLETED=$(curl -s -XGET http://localhost:5000/staging/$STAGING_AREA/export/$EXPORT_ID | jq .dateCompleted)
	SECONDS=0
	while [ "$IS_COMPLETED" = "null" ]; do
	echo_export_progress
	    sleep 1
	    IS_COMPLETED=$(curl -s -XGET http://localhost:5000/staging/$STAGING_AREA/export/$EXPORT_ID | jq .dateCompleted)
	done
	echo_ok
    else
	echo_error
	smoke_test_failed
    fi
}


validate_export() {

    echo_status "Validating $1 export"
    sleep 2
    if [ -f ../../filedata/$STAGING_AREA/$1 ]; then
        echo_ok
        rm -rf ../../filedata/$STAGING_AREA
    else
        echo_error
        smoke_test_failed
    fi
}


echo_status "Checking if REST interface is running"
screen -ls | grep .rest > /dev/null
if [ $? == 0 ]; then
    echo_ok
else
    echo_error
    smoke_test_failed
fi

echo_status "Checking if daemon is running"
screen -ls | grep .daemon > /dev/null
if [ $? == 0 ]; then
    echo_ok
else
    echo_error
    smoke_test_failed
fi



echo_status 'Connecting to REST interface'

WAIT_SECONDS=0
while [ $WAIT_SECONDS -lt 30 ]; do

    curl -s --output /dev/null -XGET http://localhost:5000/system/hostname 
    if [ $? == 0 ]; then
        echo_ok
        break;
    fi
    sleep 1
    let WAIT_SECONDS=WAIT_SECONDS+1
done

curl -s --output /dev/null -XGET http://localhost:5000/system/hostname 
if [ $? != 0 ]; then
    echo_error
    smoke_test_failed
fi


curl -s -XGET http://localhost:5000/system/hostname | jq .


INDEX_AREA=$(cat /proc/sys/kernel/random/uuid)
STAGING_AREA=$INDEX_AREA"_"

put_request "Creating new index" http://localhost:5000/index/$INDEX_AREA
if [ $? != 0 ]; then
    echo_error
    smoke_test_failed
fi


do_request "Accessing index $INDEX_AREA" GET http://localhost:5000/index/$INDEX_AREA
if [ $? != 0 ]; then
    echo_error
    smoke_test_failed
fi

put_request "Creating connector for index" http://localhost:5000/index/$INDEX_AREA/ingest/-1?mimeType=application/json ../smoke/json/smoke_index_connector.json
if [ $? == 0 ]; then
    INDEX_CONNECTOR_ID=$(echo $PUT_RESULT | jq .id)
    echo $PUT_RESULT | jq .
else
    smoke_test_failed
fi

do_request "Accessing connector for index" GET http://localhost:5000/index/$INDEX_AREA/ingest/$INDEX_CONNECTOR_ID
if [ $? != 0 ]; then
    smoke_test_failed
fi

do_request "Starting connector for index area" POST http://localhost:5000/index/$INDEX_AREA/ingest/$INDEX_CONNECTOR_ID?op=start .
if [ $? == 0 ]; then
    curl -s -XGET http://localhost:5000/index/$INDEX_AREA/ingest/$INDEX_CONNECTOR_ID | jq .status
else
    smoke_test_failed
fi







put_request "Creating new staging area" http://localhost:5000/staging/$STAGING_AREA
if [ $? != 0 ]; then
    echo_error
    smoke_test_failed
fi


do_request "Accessing staging $STAGING_AREA" GET http://localhost:5000/staging/$STAGING_AREA
if [ $? != 0 ]; then
    echo_error
    smoke_test_failed
fi



echo_status "Creating export folder"
if [ -d ../../filedata ]; then
    echo_ok
else
    mkdir ../../filedata
    echo_ok
fi



execute_export_results "Testing export" smoke_export_near_dupe.json
validate_export "TextualNearDupe.xml"


put_request "Creating connector for staging area" http://localhost:5000/staging/$STAGING_AREA/ingest/-1?mimeType=application/json ../smoke/json/smoke_staging_connector.json
if [ $? != 0 ]; then
    echo_error
    smoke_test_failed
fi




wait_for_connector()
{

    do_request "Accessing connector for staging area" GET $1
    do_request "Starting connector for staging area" POST $1?op=start .

    curl -s -XGET $1 | jq .status

    PREV_STATE=`get_connector_state $1`
    LAST_COUNT=0
    WAIT_SECONDS=0
    SECONDS=0


    while [ $WAIT_SECONDS -lt 240 ]; do
        CONNECTOR_STATE=`get_connector_state $1`
    
        if [ "$CONNECTOR_STATE" = "IDLE" ]; then
	    break;
        fi
    
        if [ "$CONNECTOR_STATE" = "ERROR" ]; then
	    break;
        fi

	if [ $CONNECTOR_STATE != $PREV_STATE ]; then
	    echo ''
	    echo_status "Ingestion"
    	    echo_warning $CONNECTOR_STATE
	    PREV_STATE="$CONNECTOR_STATE"
	    echo_status "Ingesting"
	fi

        if [ "$CONNECTOR_STATE" = "RUNNING" ]; then
	    get_document_count
	    echo_connector_progress
	    if [ $DOCUMENT_COUNT != $LAST_COUNT ]; then
		WAIT_SECONDS=0
	    fi
        fi

        sleep 1
	let WAIT_SECONDS=WAIT_SECONDS+1
    done

    sleep 1
    get_document_count
    echo_ingestion_results

    echo ''
    echo_status "Ingestion complete"
    if [ $CONNECTOR_STATE == "RUNNING" ]; then
        echo_error
        echo "Ingestion is taking too long..."
        smoke_test_failed
    fi


    if [ $CONNECTOR_STATE == "ERROR" ]; then
        echo_error
        curl -s -XGET $1 | jq .status.lastRunError | tee
        smoke_test_failed
    fi

    if [ $CONNECTOR_STATE == "IDLE" ]; then
        echo_ok
    fi
}


wait_for_connector http://localhost:5000/staging/$STAGING_AREA/ingest/1

wait_for_connector http://localhost:5000/index/$INDEX_AREA/ingest/$INDEX_CONNECTOR_ID


echo_status "Checking ingestion failures"
FAILURE_COUNT=`curl -s -XGET http://localhost:5000/staging/$STAGING_AREA/ingest/1 | jq .failures.failureCount`

if [ "$FAILURE_COUNT" != "0" ]; then
    echo_error
    curl -s -XGET http://localhost:5000/staging/$STAGING_AREA/ingest/1 | jq -r '.failures.failures[] | "\(.itemId): " + "\(.error)"'
    echo_status "Ingestion failures"
    echo_warning $FAILURE_COUNT

    #exit 1
else
    echo_ok
fi










put_request "Creating EmailThreadingAndNearDupTask" http://localhost:5000/staging/$STAGING_AREA/task/EmailThreadingAndNearDupTask ../smoke/json/smoke_email_threading_and_near_dup_task.json
curl -s -XGET http://localhost:5000/staging/$STAGING_AREA/task/EmailThreadingAndNearDupTask | jq .



SECONDS=0
while [ "$TASK_STATE" != "null" ]; do
    TASK_STATE=`get_email_threading_and_near_dup_task_state`
    TASK_ERROR=`get_email_threading_and_near_dup_task_error`

    if [ "$TASK_STATE" = "null" ]; then
	break;
    fi

    sleep 1
    echo_task_progress
done
echo ''
echo_task_results

echo_status "Task completed"

TASK_ERROR=`get_email_threading_and_near_dup_task_error`

if [ "$TASK_ERROR" != "null" ]; then
    echo_error
    echo $TASK_ERROR
    stop_mind_palace
    exit 1
else
    echo_ok
fi


PROCESSED_DOCUMENTS=`get_email_threading_processed_count`

echo_status "Processed documents"
echo_warning $PROCESSED_DOCUMENTS

echo_status "Checking processed document count"

if [ $PROCESSED_DOCUMENTS -ne 0 ]; then
    echo_ok
else
    echo_error
    stop_mind_palace
fi


execute_export_results "Creating near dupe results export" smoke_export_near_dupe.json
validate_export "TextualNearDupe.xml"

execute_export_results "Creating email threading results export" smoke_export_email_threading.json
validate_export "EmailThreadingResults.xml"



smoke_test_success
