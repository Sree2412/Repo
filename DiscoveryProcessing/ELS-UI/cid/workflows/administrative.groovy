milestone()

lock(resource: "${env.JOB_BASE_NAME}", inversePrecedence: true) {
  stage('Staging - Full Reset') {
    bat 'powershell -command "cider fullreset -verbose -CiderFile \'./cid/scripts/cider.staging.ps1\'; exit $LASTEXITCODE;"'
  }
}

milestone()
