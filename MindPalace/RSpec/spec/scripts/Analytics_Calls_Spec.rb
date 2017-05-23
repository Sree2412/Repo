require_relative '../../lib/ServiceBase'
require_relative '../../lib/Utilities'
require 'rubygems'
require 'json_spec'
require 'jsonpath'

describe "Analytics Calls" do

  before :context do
    #@base_url = "http://10.55.79.18:8080/nexus/r1/staging"
    @base_url = "http://10.55.79.18:8080/nexus/r1/"
    @staging_area_id = "101_"
    @connector_id = "1011"
    @connector_name = "2206161"
    @ingestion_data_path = "//10.55.79.37//Data//srkumar_test//ingestdata2.csv"
    @email_thread_task_id = "EmailThreadingTask"
  end

  def getStagingArea @staging_area_id
    puts @staging_area_id
  end

  context "Staging Area operations" do

    it "Should create Staging area" do
      # staging_url = @base_url << @staging_area_id
      # puts staging_url

      getStagingArea(@staging_area_id)

      # staging_obj = ServiceBase.new(staging_url)
      # staging_obj.put('')
      # expect(staging_obj.get[:code]).to eq(200)
    end

    xit "Should create Connector for Staging Area" do
        connector_url = @base_url + "/" + @staging_area_id + "/ingest/" + @connector_id
        connector_config_csv = '{"config": {"filterProportion": 0.0,"limit": 0,"mode": "ADD_ITEMS","name": "' + @connector_name + '","params": {"dataColumn": "data","includesHeaderRow": "true","encoding": null,"urlColumn": null,"metadataColumns": null,"itemIdColumn": "id","csvPath": "' + @ingestion_data_path + '"},"schedule": null},"type": "CSVConnector"}'
        connector_obj = ServiceBase.new(connector_url)
        connector_obj.put(connector_config_csv)
        expect(connector_obj.get[:code]).to eq(200)
    end

    xit "Should ingest data to the Staging Area" do
      connector_url = @base_url + "/" + @staging_area_id + "/ingest/" + @connector_id + "?op=startOver"
      connector_obj = ServiceBase.new(connector_url)
      connector_obj.post('')
      expect(connector_obj.get[:code]).to eq(200)
    end

    xit "Should create EmailThreading task" do
      email_thread_task_url = @base_url + "/" + @staging_area_id + "/task/" + @email_thread_task_id
      email_thread_task_config = '{
                                     "config": {
                                      "parameters": {
                                       "startOver": "true",
                                       "useMessageIdsIfAvailable": "true"
                                      }
                                     },
                                     "limiters": null
                                    }'
      email_thread_task_obj = ServiceBase.new(email_thread_task_url)
      email_thread_task_obj.put(email_thread_task_config)
      expect(email_thread_task_obj.get[:code]).to eq(200)
      #puts email_thread_task_obj.get[:body]
    end

    xit "Should create Textual Near Dup task" do
      textual_near_dup_url = @base_url + "/" + @staging_area_id + "/task/" + "TextualNearDupTask"
      textual_near_dup_config = '{
                                   "config": {
                                    "parameters": {
                                     "ignoreNumerics": "true",
                                     "minSimilarity": "0.9",
                                     "retainGroupIds": "true",
                                     "textKeys": null
                                    }
                                   },
                                   "limiters": null
                                  }'
      textual_near_dup_obj = ServiceBase.new(textual_near_dup_url)
      textual_near_dup_obj.put(textual_near_dup_config)
      expect(textual_near_dup_obj.get[:code]).to eq(200)
    end

    xit "Should create EmailThreadingTaskAndNearDupTask" do
      email_thread_neardup_task_url = @base_url + "/" + @staging_area_id + "/task/" + "EmailThreadingAndNearDupTask"
      email_thread_neardup_task_config = '{
                                     "config": {
                                      "parameters": {
                                       "ignoreNumerics": "true",
                                       "minSimilarity": "0.9",
                                       "retainGroupIds": "true",
                                       "startOver": "true",
                                       "textKeys": null,
                                       "useMessageIdsIfAvailable": "true"
                                      }
                                     },
                                     "limiters": null
                                    }'
      email_thread_neardup_task_obj = ServiceBase.new(email_thread_neardup_task_url)
      email_thread_neardup_task_obj.put(email_thread_neardup_task_config)
      expect(email_thread_neardup_task_obj.get[:code]).to eq(200)
    end

    xit "Should export Staging area" do
      staging_url = @base_url + "/" + @staging_area_id + "/export?op=startExport"
      export_config = '{
                        	"continueOnError":true,
                        	"dataKeys":["none"],	"exportType":"XML",
                        	"ignoreContainers":true,
                        	"ignoreItemsWithoutData":true,
                        	"includeEmailMeta":true,
                        	"includeGeneralMeta":true,
                        	"includeNearDupMeta":true,
                        	"limiters":null,
                        	"metadataKeys":
                        		[
                        			"to","from","cc","bcc","sent-date","subject","parent-item-id","conversation-index","in-reply-to",
                        			"message-id","references","sender-name","sent-representing","sender-email-address","sent-representing-email-address",
                        			"caat-derived-primary-language","caat-derived-locale"
                        		],
                        	"params":
                        		{
                        			"filename":"EmailThreadingResults.xml",
                        			"overwrite":"true"
                        		}
                        }'
      export_obj = ServiceBase.new(staging_url)
      export_obj.post(export_config)
      #expect(export_obj.get[:code]).to eq(200)
    end

  end

end
