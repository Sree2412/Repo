milestone()
lock(resource: "${env.JOB_BASE_NAME}-Release", inversePrecedence: true) {
  
  stage('Deploy Report') {
    bat 'powershell -command "cider report -verbose -CiderFile \'cid/scripts/cider.release.ps1\'; exit $LASTEXITCODE;"'
  }
  
  milestone()
  stage('Deploy Ready') {
    // run any last minute checks here etc;
    input "Deploy to Production?"
    milestone()
  }

  stage('Deploy') {
    bat 'powershell -command "cider deploy -verbose -CiderFile \'cid/scripts/cider.release.ps1\'; exit $LASTEXITCODE;"'
    milestone()
  }

  stage('Smoke Test') {
    bat 'powershell -command "cider smoke -verbose -CiderFile \'cid/scripts/cider.release.ps1\'; exit $LASTEXITCODE;"'
    milestone()
  }
}

milestone()