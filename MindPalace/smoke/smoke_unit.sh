#!/bin/bash
source smoke_echo.sh

cd ../api

echo_status 'Activating virtual environment'
source env/bin/activate
echo_ok

echo_status 'Running unit tests'
echo ''

python app_test.py
UNIT_RESULTS=$?
echo_status 'Checking unit tests results'
if [ $UNIT_RESULTS -ne 0 ]; then
    echo_error
    exit 1
else
    echo_ok
fi

deactivate
