[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "")]
param (
    [Parameter(Mandatory=$false)]
    [string]$Username = "octocat"
)

Write-Host "🔍 Fetching GitHub profile for: $Username..." -ForegroundColor Cyan

try {
    $uri = "https://api.github.com/users/$Username"
    $githubProfile = Invoke-RestMethod -Uri $uri -Method Get

    Write-Host "`n👤 Profile Information:" -ForegroundColor Green
    Write-Host "---------------------------"
    Write-Host "Login:      $($githubProfile.login)"
    Write-Host "Name:       $($githubProfile.name)"
    Write-Host "Bio:        $($githubProfile.bio)"
    Write-Host "Repos:      $($githubProfile.public_repos)"
    Write-Host "Followers:  $($githubProfile.followers)"
    Write-Host "Following:  $($githubProfile.following)"
    Write-Host "URL:        $($githubProfile.html_url)"
    Write-Host "---------------------------"
} catch {
    Write-Host "❌ Error: Could not fetch profile for '$Username'. Details: $($_.Exception.Message)" -ForegroundColor Red
}