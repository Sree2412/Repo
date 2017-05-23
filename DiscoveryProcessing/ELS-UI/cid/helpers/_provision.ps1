function _provision {
<#
  Putting the logic in a private script (_) so that we can
  unit test it a little easier

  _provision & _getVM are a little bit simliar for my liking, 
  possible to combine these? 
#>
  [CmdletBinding()]
  param()

  $RunList = 'recipe[consilio_globalservices::ui_eels]'
    

  <#
      Get the machine: 
        This function is run as part of the Jenkins workflow. What that means is this function must be "stateful"
        The machine can be expired, non-existent (new environment/feature), or valid/ready to deploy.
        Need to ping chef to get machine name... then validate the machine's state. 

        This function will also need to be shared, as other functions rely on the machine/node information (deploy, integration)
  #>

  $currentState = _getEnvironmentState

  # the only time we need to request a machine is if $currentState.vRAFQDN is $null
  if (-not $currentState.vRAFQDN) {
    Write-Verbose 'provision: determined we needed a new machine, sending that request in'
    $webServer = _getVM
  }
  else {
    $webServer = $currentState.vRAFQDN
  }

  # if $currentState.ChefNode exists BUT ChefFQDN does NOT.. .then we'll need to 
  # delete the node objects before bootstrapping the webserver
  if ($currentState.ChefNode -and (-not $currentState.ChefFQDN)) {
    Write-Verbose 'provision: determined that an old chef node existed. Cleaning it up'
    Remove-ChefNode -NodeName $NodeName
  }

  if ($Branch -eq 'master') {
    $NodeEnvironment = 'staging_mtp'
  }
  else {
    $NodeEnvironment = 'dev_mtp'
  }

  # bootstrap runs every time (to bring the machine up to spec)
  Invoke-CiderBootstrap -MachineName $webServer -NodeName $NodeName -RunList $RunList -Environment $NodeEnvironment
  
  $currentState = _getEnvironmentState
  
  # return a machine name/ save state somewhere?
  Write-Output $currentState
}