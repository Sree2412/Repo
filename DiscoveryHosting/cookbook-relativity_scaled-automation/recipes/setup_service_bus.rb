
# Install .Net 3.5
include_recipe 'dotnet::dotnet-3.5'

# Apply Recommended Windows Optimization
include_recipe 'relativity-scaled-automation-sri::optimize_windows'
