#
# Required Parameters: 
# $URL - The machine/host name to target for tests
#

param(
  # example:  $URL = 'https://mtpctscid666.consilio.com/eels-ui/v1/#/project/H11824'
  [Parameter(Mandatory)]
    [string]$URL
)

Describe 'ELS Data Service Integration Tests' {
  it 'it returns a good status code' {
    $return_value = Invoke-WebRequest -Method Get -Uri $URL -UseDefaultCredentials
    $return_value.StatusCode | Should Be 200
  }
}