# Copyright (c) 2016 The Authors, All Rights Reserved.

# Stop Agent Service
windows_service 'kCura EDDS Agent Manager' do
  action :start
end

