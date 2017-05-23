function _buildPackage {
<#
    
#>
  [CmdletBinding()]
  param()

  try {
   $CurrentLocation = (Get-Location).Path
   
   # set the location to where the .sln file is
   Set-Location '.\src'

   $build_package = ".cider\build_artifact\$serviceOrSiteName.zip"
   $version_artifact = '.cider\build_artifact\VERSION'

   # cleanup the prior runs
   if (Test-Path $build_package) { Remove-Item $build_package }
   if (Test-path $version_artifact) { Remove-Item $version_artifact }

   # just in case cider stops creating the build_artifact folder on a -nopackage op
   if(-not (Test-Path .cider\build_artifact)) { New-Item -ItemType Container -Path .cider\build_artifact | Out-Null }

   # and write out a new version file
   _getAssemblyVersion | Out-File -FilePath $version_artifact -Encoding ascii -NoNewline

   & npm install;

   # try to guess the build output. this SHOULD be overridden based on the project
   $package_dir = '.'

   if (-not (Test-Path $package_dir)) { Throw "The package directory is invalid $package_dir" }

   # package it up
   7z @('a',$build_package,'-tzip',"-i!$package_dir\*", "-x!.cider", "-x!app-settings.js" ) | Write-Verbose

   # add the version artifact to the package
   7z @('a','-tzip',$build_package,".\$version_artifact") | Write-Verbose

   Write-Verbose "Packaged! Located here: $build_package"
  }
  catch {
    $Global:LastExitCode = 1
    Throw
  }
  finally {
    Set-Location $CurrentLocation
  }
}