function _deploy {
<#
    Shared logic to deploy project service artifacts
#>
  [CmdletBinding()]
  param(
    # the path to the artifact to deploy
    [Parameter(Mandatory=$true)]
      [String]$DeployArtifact,

    # where to deploy the web components
    [Parameter(Mandatory=$true)]
      [String]$TargetPath,

    [Parameter()]
      [bool]$ReportOnly = $true,

    [Parameter(Mandatory=$true)]
      [String]$WebServer
  )

  Write-Verbose 'Service Deployment'

  # make sure the path to the deployment artifact is valid
  if (-not (Test-Path $DeployArtifact)) { Throw "$DeployArtifact does not exist or you do not have permission to it!" }

  # make sure the target path is valid
  if (-not (Test-Path $TargetPath)) { Throw "$TargetPath is invalid or you do not have permission to it!" }

  ### Local Vars
  #$_exclude_from_compare = @('Web.config')

  # create a temp folder to hold the extracted archive  
  $_workFolder = Join-Path $([System.IO.Path]::GetTempPath()) "cider-$([Guid]::NewGuid())"
  New-Item -Path $_workFolder -ItemType Container | Out-Null

  Write-Verbose "Extracting $DeployArtifact..."

  # extract the archive
  & 7z x $DeployArtifact -o"$_workFolder" | Out-Null

  # get the current version
  $current_version = Get-Content $(Join-Path $TargetPath 'VERSION')

  # get the version to be upgraded to
  $deploy_version = Get-Content $(Join-Path $_workFolder 'VERSION')

  Write-Verbose "Comparing the artifact version ($deploy_version) to $TargetPath (currently at version $current_version)..."

  # get the compare results
  $results = Compare-Directory -Source $_workFolder -Target $TargetPath # -Exclude $_exclude_from_compare

  # organize the results
  $new_files =  @($results | Where-Object { $_.SourceOnly -eq $true })
  $updated_files = @($results | Where-Object { $_.IsDifferent -eq $true })
  
  if ($ReportOnly) {
    Write-Verbose "There are $($new_files.Count) new files and $($updated_files.Count) updated files waiting to be deployed...`n"
    Write-Verbose "New Files: `n $(@($new_files | Select-Object -ExpandProperty RelativePath) -join "`n")`n`nUpdated Files: `n$(@($updated_files | Select-Object -ExpandProperty RelativePath) -join "`n")"
    Write-Verbose "`nEnd of Report`n"
  }
  else { 

    Write-Verbose "Deploying version $deploy_version (currently at version $current_version)..."
    Write-Verbose "There are $($new_files.Count) new files and $($updated_files.Count) updated files that will be deployed..."

    foreach ($f in $new_files) { 
      Write-Verbose "`nDeploying NEW file $($f.RelativePath)..."

      # make sure the parent directory exists at the destination!
      if (-not (Test-Path $(Split-Path -Parent $(Join-Path $TargetPath $f.RelativePath)))) {
        New-Item -ItemType Container -Path $(Split-Path -Parent $(Join-Path $TargetPath $f.RelativePath)) | Out-Null
      }

      Copy-Item -Path $f.FullName -Destination $(Join-Path $TargetPath $f.RelativePath) -Force -Recurse
    }
    
    foreach ($f in $updated_files) {
      Write-Verbose "`nDeploying UPDATED file $($f.RelativePath)..."
      Copy-Item -Path $f.FullName -Destination $(Join-Path $TargetPath $f.RelativePath) -Force
    }

    # nice sanity message if there are no changes to deploy
    if ($new_files.Count -eq 0 -and $updated_files.Count -eq 0) {
      Write-Verbose 'Wait, there are no files to be deployed!'
    }
    else {
      Write-Verbose "Recycling the app pool on $WebServer..."
      Invoke-Command -ComputerName "$WebServer.consilio.com" -ScriptBlock { Restart-WebAppPool -Name $($args[0]) } -ArgumentList "$serviceOrSiteName"
    }
  }

  Write-Verbose "Cleaning up..."

  #cleanup
  Remove-Item $_workFolder -Force -Recurse

  Write-Verbose "Done!"
}