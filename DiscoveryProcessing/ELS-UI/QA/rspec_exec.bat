call bundle exec rspec spec\smoke_test_specs\a_addAnalyticsServer_spec.rb --format progress --format documentation --format html --out result_rspec_analytics.html
echo "Ran Add Analytics Server"
call bundle exec rspec spec\smoke_test_specs\b_addWMS_spec.rb --format progress --format documentation --format html --out result_rspec_addWMS.html
echo "Ran WMS and added Agent and Worker servers to resource pool"
call bundle exec rspec spec\smoke_test_specs\c_smoke_add_cmug_spec.rb --format progress --format documentation --format html --out result_rspec_add_cmug.html
echo "Added smoke client, matter, user and group"
call bundle exec rspec spec\smoke_test_specs\d_smokeUser_WorkSpace_Creation_spec.rb --format progress --format documentation --format html --out result_rspec_user_workspace_creation.html
echo "Created smoke user and created a new workspace"
call bundle exec rspec spec\smoke_test_specs\e_importSmokeTestData_spec.rb --format progress --format documentation --format html --out result_importtestData.html
echo "Imported test data into the workspace"
call bundle exec rspec spec\smoke_test_specs\f_documentImportValidation_spec.rb --format progress --format documentation --format html --out result_docImportValidation.html
echo "Validated imported documents"
call bundle exec rspec spec\smoke_test_specs\f_processTranscript_spec.rb --format progress --format documentation --format html --out result_processTranscript.html
echo "Process Transcript validated"
call bundle exec rspec spec\smoke_test_specs\g_create_workspaceElements_spec.rb --format progress --format documentation --format html --out result_createdWorspaceElements.html
echo "Workspace Elements created"
call bundle exec rspec spec\smoke_test_specs\h_code_docs_responsive_spec.rb --format progress --format documentation --format html --out result_docsResponsive.html
echo "Code docs Responsive verified"
call bundle exec rspec spec\smoke_test_specs\i_createRelativityAnalytics_spec.rb --format progress --format documentation --format html --out result_createAnalytics.html
echo "created Analytics"
call bundle exec rspec spec\smoke_test_specs\j_createnewSTR_spec.rb --format progress --format documentation --format html --out result_createSTR.html
echo "created STR"
echo "SMOKE TESTING COMPLETED"
