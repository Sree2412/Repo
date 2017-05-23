#!/bin/bash

./smoke_build.sh $1
if [ $? == 0 ]; then
    ./smoke_unit.sh    
    if [ $? == 0 ]; then
	./smoke_exec.sh "with test run"
    fi
fi
