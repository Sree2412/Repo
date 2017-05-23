# web template
$serviceOrSiteName = 'eels-ui'

# these variables can be overriden by declaring & setting them
# BEFORE the cider calls
if (-not $Branch) { $Branch = $env:USERNAME }
if (-not $NodeName) {$NodeName = "$serviceOrSiteName-$Branch" }

".\cid\helpers\*.ps1" |
    Resolve-Path |
        Where-Object { -not ($_.ProviderPath.ToLower().Contains('.tests.')) } |
            ForEach-Object { . $_.ProviderPath }


function build {
  [CmdletBinding()]
  param() 

  _buildPackage
}

function provision {
  [CmdletBinding()]
  param()
  
  _provision
}

function deploy {
  [CmdletBinding()]
  param()

  $currentState = _getEnvironmentState

  $target_path = "\\$($currentState.VRAFQDN)\c$\inetpub\wwwroot\GlobalServices\$serviceOrSiteName\v1"
  $deploy_artifact = "src\.cider\build_artifact\$serviceOrSiteName.zip"

  _deploy -DeployArtifact $deploy_artifact -TargetPath $target_path -ReportOnly:$false -WebServer $currentState.VRAFQDN
}

function version {
  [CmdletBinding()]
  param()

  _getAssemblyVersion
}

function integration {
  [CmdletBinding()]
  param()

  $currentState = _getEnvironmentState

  $url = "https://$($currentState.VRAFQDN).consilio.com/eels-ui/v1/#/project/H11824"

  _integration -URL $url
}