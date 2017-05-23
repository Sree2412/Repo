# Copyright (c) 2016 The Authors, All Rights Reserved.

# Stop Agent Service
windows_service 'W3SVC' do
  action :start
end
