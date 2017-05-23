### Required Parameters
if (-not $env:deploy_version) { Throw "deploy_version is a required parameter! Aborting..." }

$deploy_artifact = "\\hlnas00\tech\Packages\eels-ui\v$($env:deploy_version)\eels-ui.zip"
$deploy_target_path = '\\MTPVPWEELS01\c$\inetpub\wwwroot\GlobalServices\eels-ui\v1'
$deploy_web_server = 'MTPVPWEELS01'
$serviceOrSiteName = 'eels-ui'

### Load helper functions
".\cid\helpers\*.ps1" |
    Resolve-Path |
        Where-Object { -not ($_.ProviderPath.ToLower().Contains('.tests.')) } |
            ForEach-Object { . $_.ProviderPath }

function deploy {
  [CmdletBinding()]
  param()
  
  _deploy -DeployArtifact $deploy_artifact -TargetPath $deploy_target_path -ReportOnly:$false -WebServer $deploy_web_server
}

function smoke {
  [CmdletBinding()]
  param()

  _integration -URL 'https://els.consilio.com/eels-ui/v1/#/project/H11824'
}

function report { 
  [CmdletBinding()]
  param()

  _deploy -DeployArtifact $deploy_artifact -TargetPath $deploy_target_path -ReportOnly:$true -WebServer $deploy_web_server
}
