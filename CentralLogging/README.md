# CentralLogging

Three simple tests for centralized logging written in Python to leverage the function that sends logs through Kafka. 

1. Verifies the initial state
2. Sends sample logs to ES through Kafka, verifies the correct count of logs, and an expected field / values pair present in logs
3. Validates elapsed time functionality

Since it is not possible to remove logs from ES, thereby restoring the initial state, these tests are designed to be executed only once per minute. They can be modified to be rerun by changing the Kibana URL to a different display interval or updating the log count variables to account for the number present in the time interval at the start of the test run.


