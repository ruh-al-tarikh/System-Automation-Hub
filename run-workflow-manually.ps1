[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "")]
param()

# Hardcoded GitHub Personal Access Token (with repo/workflows scope)
$token = $env:GITHUB_TOKEN

# GitHub repo info
$owner = "Ruh-Al-Tarikh"
$repo  = "System-Automation-Hub"

# Get list of workflow files
$workflowDir = ".github/workflows"
if (Test-Path $workflowDir) {
    $workflows = Get-ChildItem $workflowDir -Filter *.yml | Select-Object -ExpandProperty Name
} else {
    $workflows = @()
}

Write-Host "Available workflows to run:"
if ($workflows.Count -eq 0) {
    Write-Host "No workflows found in $workflowDir" -ForegroundColor Yellow
    return
}

$workflows | ForEach-Object { Write-Host "- $_" }

# Prompt user to choose workflow
$workflowFile = Read-Host "Enter the workflow file to trigger (e.g., ci.yml)"

if (-not ($workflows -contains $workflowFile)) {
    Write-Host "Workflow file not found!" -ForegroundColor Red
    return
}

# Confirm before dispatch
$answer = Read-Host "Trigger workflow '$workflowFile'? (Y/N)"
if ($answer -ne 'Y') {
    Write-Host "Cancelled."
    return
}

# GitHub API endpoint
$uri = "https://api.github.com/repos/$owner/$repo/actions/workflows/$workflowFile/dispatches"

# Prepare request headers
$headers = @{
    Authorization = "Bearer $token"
    "User-Agent"  = "PowerShell"
    Accept        = "application/vnd.github+json"
}

# Body with branch (main) to run workflow on
$body = @{ ref = "main" } | ConvertTo-Json

# Trigger the workflow
try {
    Invoke-RestMethod -Uri $uri -Headers $headers -Method Post -Body $body
    Write-Host "Workflow '$workflowFile' dispatched successfully!"
    Write-Host "Check https://github.com/$owner/$repo/actions for status."
} catch {
    Write-Host "Error triggering workflow: $($_.Exception.Message)" -ForegroundColor Red
}