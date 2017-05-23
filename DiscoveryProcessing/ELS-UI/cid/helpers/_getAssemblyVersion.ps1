function _getAssemblyVersion {
<#
.SYNOPSIS
Gets the current assembly version

.DESCRIPTION
This function gets the current assembly version by parsing the AssemblyInfo.cs file in src\ReportingPortal\Properties\
and can be run from the repo root or from the .\src directory

.EXAMPLE
Get-AssemblyVersion

Returns the current assembly version
#>
  [CmdletBinding()]
  param()
  
  # find the version file. 
  if (Test-Path 'package.json') {
    $version_file = 'package.json'
  }
  else {
    $version_file = '.\src\package.json'
  }
  
  $app_config = Get-Content $version_file -Raw

  if ($app_config -match '\"version\"\:(\s)+\"(.*)\"') {
    $_version = $Matches[2]
  }
  else {
    $_version = '0.0.0'
  }

  Write-Output $_version
}