function _integration { 
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)]
      [String]$URL
  )

  # test return codes on failing suites and rerun the suite three times before failing stage
  $retrycount = 1
  $success = $false
  $retries = 3

  While (!$success) {
    try {
      $testResults = Invoke-Pester -Script @{ Path='./test/integration/pester'; Parameters = @{URL= $URL };} -PassThru
      if ($testResults.FailedCount -gt 0) {Throw}
      $success = $true
      # reset any prior error states
      $Global:LastExitCode = $null
    }
    catch {
      if ($retrycount -ge $retries) {
        Write-Verbose ("Tests failed the maximum number of {0} times." -f $retrycount)
        $Global:LastExitCode = 1
        Throw 'integration: tests failed!'
      }
      else {
        Write-Verbose "Tests failed, retrying in 10 seconds."
        Start-Sleep 10
        $retrycount++
      }
    }
  }  
}

