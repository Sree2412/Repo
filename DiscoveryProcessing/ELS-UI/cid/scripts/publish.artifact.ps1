<#
  Just a quick script to publish the artifact 
  to the nas share
#>

$PackagesRoot =  '\\hlnas00\tech\Packages\eels-ui'

$currentVersion = Get-Content 'src/.cider/build_artifact/VERSION'

$target_folder = Join-Path $PackagesRoot "v$currentVersion"

# if the folder does not exist, create it
if (-not (Test-Path $target_folder)) { 
  New-Item -ItemType Container -Path $target_folder | Out-Null
}

# move the build artifact to the target folder
Copy-Item 'src/.cider/build_artifact/eels-ui.zip' -Destination $target_folder -Force

# copy the version artifact to the target folder
Copy-Item 'src/.cider/build_artifact/VERSION' -Destination $target_folder -Force
