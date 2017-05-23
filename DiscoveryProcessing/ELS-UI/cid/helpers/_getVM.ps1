# provisions a machine with Invoke-CiderProvision &&
# changes the machine file created to be ($config.nodename).txt
function _getVM {
  [CmdletBinding()]
  param()

  # staging environment should last 5 days
  if ($Branch -eq 'master') {
    $leaseDays = 5
  }
  else {
    $leaseDays = 1
  }

  Write-Verbose "Getting a VM from vRA"
  $_webserver = Invoke-CiderProvision -CatalogItem Test_Kitchen_Windows_v01 -CPU 1 -LeaseDays $leaseDays

  $_machine_file_path = ".cider\provision_artifact\$NodeName.txt"

  # remove the old machine file (if exists)
  # delete the old machine file (if exists)
  if (Test-Path $_machine_file_path) {
    Remove-Item $_machine_file_path
  }

  # rename the machine file
  Rename-Item -Path ".cider\provision_artifact\$($_webserver).json" -NewName "$NodeName.txt"
    
  # put the name of the machine as the content
  Set-Content -Value $_webserver -Path $_machine_file_path

  # set currentState (if Exists)
  if ($currentState) {
    $currentState.vRAFQDN = $_webserver
  }

  # see issue https://github.consilio.com/CID/cider/issues/119
  & ipconfig /flushdns | Out-Null
  Start-Sleep -s 60
    
  return $_webserver
}