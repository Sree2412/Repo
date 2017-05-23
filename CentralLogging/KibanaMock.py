# URLs
kibana_home = "http://mtpvpseslg02.consilio.com:5601/app/kibana#/discover?_g=(refreshInterval:(display:Off,pause:!f,value:0),time:(from:now-1m,mode:quick,to:now))&_a=(columns:!(_source),index:logging,interval:auto,query:(query_string:(analyze_wildcard:!t,query:'*')),sort:!('@timestamp',desc),uiState:(spy:(mode:(fill:!f,name:!n))))"
kibana_et_home = "http://mtpvpseslg02.consilio.com:5601/app/kibana#/discover?_g=(refreshInterval:(display:Off,pause:!f,value:0),time:(from:now-1m,mode:quick,to:now))&_a=(columns:!(_source),index:logging,interval:auto,query:(query_string:(analyze_wildcard:!t,query:'elapsed_id:%20%22TEST-1%22')),sort:!('@timestamp',desc),uiState:(spy:(mode:(fill:!f,name:!n))))"

# Web Elements
hits_xpath = '//*[@id="kibana-body"]/div[2]/div/div/div/div[2]/div[2]/div[1]/strong'
results_load = '//*[@id="kibana-body"]/div[2]/div/div/div/div[2]/div[2]/div[2]/div[3]/div[1]/header/center/span[2]/a'
no_results_load = '//*[@id="kibana-body"]/div[2]/div/div/div/div[2]/div[2]/div[2]/div[1]/div/div[2]/p[2]/a'
sidebar = '//*[@id="kibana-body"]/div[2]/div/div/div/div[2]/div[1]/disc-field-chooser/div/div[4]/h5/i'
available_fields = '//*[@id="kibana-body"]/div[2]/div/div/div/div[2]/div[1]/disc-field-chooser/div/div[4]/h5/button'
field_name = '//*[@id="kibana-body"]/div[2]/div/div/div/div[2]/div[1]/disc-field-chooser/div/div[5]/form/div[4]/input'
tags_vis = '//*[@id="kibana-body"]/div[2]/div/div/div/div[2]/div[1]/disc-field-chooser/div/ul[3]/li/a'
elapsed_time = '//*[@id="kibana-body"]/div[2]/div/div/div/div[2]/div[1]/disc-field-chooser/div/ul[3]/li[12]/div/field-name'

# Log Counts
logs_before = '0'
logs_after = '200'
etlogs_before = '0'
etlogs_start = '1'
etlogs_stop = '2'

# Log Field Values
app_names = ['basketball', 'baseball', 'football']
tags = ['elapsed_start', 'elapsed_match', 'elapsed', 'elapsed_stop']
