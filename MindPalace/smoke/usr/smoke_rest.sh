#!/bin/bash
source smoke_echo.sh

do_request()
{
    echo_status "$1"

    REQUEST_RESULT=$(curl -f -s -o /dev/null -X$2 $3)
    if [ $? != 0 ]; then
	echo_error
	return 1
    fi

    export REQUEST_RESULT
    echo_ok
    return 0
}



put_request()
{
    echo_status "$1"

    if [ -z $3 ]; then
	curl -f -s -o /dev/null -XPUT $2
    else
	if [ -f $3 ]; then
	    PUT_RESULT=$(curl -f -s -H "Content-Type: application/json" -d @$3 -XPUT $2)
	    if [ $? != 0 ]; then
		echo_error
		curl -f -H "Content-Type: application/json" -d @$3 -XPUT $2
		return 1
	    fi
	    
	    export PUT_RESULT
	else
	    echo_warning "FILE NOT FOUND"
	    echo $3
	    return 1
	fi
    fi

    echo_ok
    return 0
}


post_request()
{
    echo_status "$1"

    if [ -z $3 ]; then
	curl -f -s -o /dev/null -XPOST $2
    else
	if [ -f $3 ]; then
	    POST_RESULT=$(curl -f -s -H "Content-Type: application/json" -d @$3 -XPOST $2)
	    export POST_RESULT
	else
	    echo_warning "FILE NOT FOUND"
	    echo $3
	    return 1
	fi
    fi

    if [ $? != 0 ]; then
	echo_error
	return 1
    fi
    echo_ok
    return 0
}

post_slack()
{
    SLACK_CHANNEL=@$(git show -s | grep -hio "\b[a-z0-9.-]\+@[a-z0-9.-]\+\.[a-z]\{2,4\}\+\b" | sed -E 's/(.*)@{1}(.*)/\1/')
    curl -X POST -d "{ \"text\": \"$1\",\"channel\": \"$SLACK_CHANNEL\"}" https://hooks.slack.com/services/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
}

