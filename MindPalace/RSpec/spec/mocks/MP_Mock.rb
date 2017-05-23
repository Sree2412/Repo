
module TestData

  JsonSample = '{
                  "fruits": [
                              {"name": "Apple", "location": "Harbor"},
                              {"name": "Banana", "location": "Kitchen"},
                              {"name": "Mango", "location": "Bedroom"}
                            ]
                }'

  NestedJson = '[
            {"store":
              {"bicycle":
                {"price":19.95, "color":"red"},
                "book":[
                  {"price":8.95, "category":"reference", "title":"Sayings of the Century", "author":"Nigel Rees"},
                  {"price":12.99, "category":"fiction", "title":"Sword of Honour", "author":"Evelyn Waugh"},
                  {"price":8.99, "category":"fiction", "isbn":"0-553-21311-3", "title":"Moby Dick", "author":"Herman Melville","color":"blue"},
                  {"price":22.99, "category":"fiction", "isbn":"0-395-19395-8", "title":"The Lord of the Rings", "author":"Tolkien"}
                ]
              }
            }
          ]'

  JsonOutputCAAT = '[
                {"created": 1465812321182, "crossLingual": false, "id": "12345_", "indexDiskMB": 0, "lastBuildStarted": null, "numItems": 0, "queriesEnabled": true, "queryMemoryMB": 0, "queryState": "ENABLED", "type": "Staging Area", "uri": "/staging/12345_" },

                {"created": 1465452138277, "crossLingual": false, "id": "dbe0bc0d-3e17-45c5-b82c-da64115ed92b", "indexDiskMB": 11, "lastBuildStarted": 1465815613569, "numItems": 1059, "queriesEnabled": false, "queryMemoryMB": 6, "queryState": "DISABLED", "type": "Search Index", "uri": "/index/dbe0bc0d-3e17-45c5-b82c-da64115ed92b" },

                {"created": 1465452135356, "crossLingual": false, "id": "dbe0bc0d-3e17-45c5-b82c-da64115ed92b_", "indexDiskMB": 0, "lastBuildStarted": null, "numItems": 1059, "queriesEnabled": true, "queryMemoryMB": 0, "queryState": "ENABLED", "type": "Staging Area", "uri": "/staging/dbe0bc0d-3e17-45c5-b82c-da64115ed92b_" },

                {"created": 1465968004396, "crossLingual": false, "id": "e8b1c5af-db0e-4ac2-8876-b58548d60b27", "indexDiskMB": 11, "lastBuildStarted": 1465975836738, "numItems": 1065, "queriesEnabled": false, "queryMemoryMB": 6, "queryState": "DISABLED", "type": "Search Index", "uri": "/index/e8b1c5af-db0e-4ac2-8876-b58548d60b27" },

                {"created": 1465968003786, "crossLingual": false, "id": "e8b1c5af-db0e-4ac2-8876-b58548d60b27_", "indexDiskMB": 0, "lastBuildStarted": null, "numItems": 1065, "queriesEnabled": true, "queryMemoryMB": 0, "queryState": "ENABLED", "type": "Staging Area", "uri": "/staging/e8b1c5af-db0e-4ac2-8876-b58548d60b27_" }
              ]'

  GetStudents = '{
                    students:
                    [
                      {
                        id: 4,
                        first_name: "Doctor",
                        last_name: "Who",
                        email: "doctor_who@whoville.com"
                      }
                    ]
                  }'
end
