#
# Full Reset - Take down current environment (if exists, build a new one)
# 
#

# requires the dns server module
Import-Module DNSserver -Verbose:$false

# the staging node name
$NodeName = 'eels-ui-master'
$Branch = 'master'
$serviceOrSiteName = 'eels-ui'

### Load helper functions
".\cid\helpers\*.ps1" |
    Resolve-Path |
        Where-Object { -not ($_.ProviderPath.ToLower().Contains('.tests.')) } |
            ForEach-Object { . $_.ProviderPath }

function fullreset {
  <#
    This function will:
    
    1. remove the current chefnode/client (if exists)
        Save the old "vm" to destroy it at the end

    2. Get/Create new VM

    3. Bootstrap it

    4. Get Current Production Version

    5. Deploy production version

    6. Delete old "vm" (if exists)
  #>
  [CmdletBinding()]
  param()

  # get the current state (save for later)
  $_current_state = _getEnvironmentState

  # get a new vm
  $webServer = _getVM

  # remove the old chef node/client
  Remove-ChefNode -NodeName $NodeName

  # reprovision the machine
  _provision

  # update the CNAME
  $oldRecord = Get-DnsServerResourceRecord -Name test-els -RRtype CNAME -ZoneName consilio.com -ComputerName mtpvpsdc01.consilio.com
  $newRecord = $oldRecord.Clone()
  $newRecord.RecordData.HostNameAlias = "$webServer.consilio.com"
  Set-DnsServerResourceRecord -NewInputObject $newRecord -OldInputObject $oldRecord -ComputerName mtpvpsdc01.consilio.com -ZoneName consilio.com -PassThru

  # delete the old VM (if exists)
  if ($_current_state.vRAFQDN) {
    try {
      Invoke-CiderCleanup -Machine $_current_state.vRAFQDN -SkipChef
    }
    catch {
      Write-Output 'Cleaning up failed, but not a huge deal.'
    }
  }
}

function softReset {
  [CmdletBinding()]
  param()
  <#
    function to deploy the latest artifact to staging. 

    ### REMEMBER
      when we have a production instance, we'll want this function to grab
      the version and deploy the binaries from it. 
    ###
  #>

  # shouldn't do anything but run chef-client
  _provision 

  $currentState = _getEnvironmentState
  
  $PackagesRoot =  '\\hlnas00\tech\Packages\eels-ui'

  # get the latest one on the nas share
  $_deployArtifactPath = Get-ChildItem -Path $PackagesRoot | Where-Object { $_.Name -match 'v(\d).' } | Sort-Object $_.LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName
  $_deployArtifact = Join-Path $_deployArtifactPath 'eels-ui.zip'
  
  # calculate the target path
  $target_path = "\\$($currentState.VRAFQDN)\c$\inetpub\wwwroot\GlobalServices\eels-ui\v1"
  _deploy -DeployArtifact $_deployArtifact -TargetPath $target_path -ReportOnly:$false -WebServer $currentState.VRAFQDN
}

function integration {
  [CmdletBinding()]
  param()  
  $url = "https://test-els.consilio.com/eels-ui/v1/#/project/H11824"
  _integration -URL $url
}

function stageArtifact {
<#
  function that deploys the artifact to the staging environment, runs the 
  integration tests, and if either fails, resets the staging environment
#>
  [CmdletBinding()]
  param()

  $deploy_artifact = "src/.cider/build_artifact/eels-ui.zip"
  $currentState = _getEnvironmentState

  try {
    $target_path = "\\$($currentState.VRAFQDN)\c$\inetpub\wwwroot\GlobalServices\eels-ui\v1"
    _deploy -DeployArtifact $deploy_artifact -TargetPath $target_path -ReportOnly:$false -WebServer $currentState.VRAFQDN

    _integration -URL "https://test-els.consilio.com/eels-ui/v1/#/project/H11824"
  }
  catch {
    Write-Verbose 'Staging failed! Rolling back the staging environment... '
    softReset
    Throw 'Code failed to stage, stopping the pipeline.'
  }
}
