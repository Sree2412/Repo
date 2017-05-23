#!/bin/bash
source smoke_echo.sh
source smoke_rest.sh

do_request "Elasticsearch cleanup" DELETE http://localhost:9200/_all

cp config/smoke_config_local.py ../api/config_local.py
cd ../api

echo_status 'Creating vitual environment'

# sudo apt-get install python3-dev
virtualenv -q -p /usr/bin/python3 env 1>/dev/null

if [ $? != 0 ]; then
    echo_error
    virtualenv -p /usr/bin/python3 env
    exit 1;
else
    echo_ok
fi

source env/bin/activate
echo_status 'Installing requirements'

cat requirements.txt | xargs -n 1 -L 1 pip3 -q install

if [ $? != 0 ]; then
    echo_error
    echo_status 'Running in verbose mode'
    echo ""
    cat requirements.txt | xargs -n 1 -L 1 pip3 install
    exit 1;
else
    echo_ok
fi

deactivate
