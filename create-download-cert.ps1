# Workflow folder
$workflowDir = ".github\workflows"
if (-not (Test-Path $workflowDir)) {
    New-Item -ItemType Directory -Path $workflowDir -Force | Out-Null
}

# download-cert.yml content
$downloadCertYaml = @'
name: Download TLS Certificate

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  download:
    runs-on: windows-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '20'

      - name: Download TLS Certificate
        shell: pwsh
        run: |
          $certPath = ".\bin\checkScripts\download_ca_cert.pem"
          if (Test-Path $certPath) {
              $timestamp = Get-Date -Format yyyyMMddHHmmss
              Rename-Item $certPath "$certPath.$timestamp.bak"
              Write-Host "Existing certificate backed up."
          }
          node .\bin\checkScripts\runDownloadCert.js github.com
'@

# Save download-cert.yml
$downloadCertFile = Join-Path $workflowDir "download-cert.yml"
$downloadCertYaml | Set-Content -Path $downloadCertFile -Force
Write-Host "$downloadCertFile created successfully."

# Optionally, create powershell-ci.yml (minimal version)
$powershellCiYaml = @'
name: PowerShell CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:

jobs:
  lint-and-test:
    runs-on: windows-latest
    steps:
      - name: Checkout repo
        uses: actions/checkout@v4

      - name: Install PSScriptAnalyzer
        shell: pwsh
        run: Install-Module PSScriptAnalyzer -Force -Scope CurrentUser

      - name: Run PSScriptAnalyzer
        shell: pwsh
        run: |
          $results = Invoke-ScriptAnalyzer -Path . -Recurse -Severity Error,Warning
          if ($results) {
              $results | Format-Table
              throw "PSScriptAnalyzer found issues"
          }

      - name: Install Pester
        shell: pwsh
        run: Install-Module Pester -Force -Scope CurrentUser -SkipPublisherCheck

      - name: Run Pester Tests
        shell: pwsh
        run: |
          if (Test-Path ./tests) {
              Import-Module Pester
              Invoke-Pester -Path ./tests -Verbose
          } else {
              Write-Host "No Pester tests found."
          }
'@

$powershellCiFile = Join-Path $workflowDir "powershell-ci.yml"
$powershellCiYaml | Set-Content -Path $powershellCiFile -Force
Write-Host "$powershellCiFile created successfully."