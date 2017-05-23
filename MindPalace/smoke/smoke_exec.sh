#!/bin/bash
source smoke_echo.sh

echo_status 'Checking if test is already running'
pgrep python > /dev/null
if [ $? == 0 ]; then
    echo_warning "RUNNING"
    echo "Smoke test might be running now by another user."
    echo "Use sudo stop-smoke to stop smoke test or wait until other smoke test finish"
    exit 1
else
    echo_ok
fi


cd ../api

echo_status 'Activating virtual environment'
source env/bin/activate
echo_ok

echo_status 'Starting REST interface'
screen -dmS rest python app.py
echo_ok

echo_status 'Starting daemon application'
screen -dmS daemon python app_daemon.py
echo_ok

REST_SCREEN_PID=`screen -ls | awk '/\.rest\t/ {print strtonum($1)}'`
DAEMON_SCREEN_PID=`screen -ls | awk '/\.daemon\t/ {print strtonum($1)}'`

export REST_SCREEN_PID
export DAEMON_SCREEN_PID

if [ -n "$1" ]; then
    ../smoke/smoke_run.sh
fi


