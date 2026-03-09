# Files to remove (relative to repo root)
$filesToDelete = @(
    ".github\workflows\create-powershell-ci.ps1",
    ".github\workflows\download-cert.yml",
    ".github\workflows\powershell-ci.yml.*.bak"
)

foreach ($file in $filesToDelete) {
    # Expand wildcard if any
    $matches = Get-ChildItem -Path $file -ErrorAction SilentlyContinue
    if ($matches) {
        foreach ($match in $matches) {
            $answer = Read-Host "Do you want to delete '$($match.FullName)'? (Y/N)"
            if ($answer -eq 'Y') {
                Remove-Item -Path $match.FullName -Force
                Write-Host "Deleted: $($match.FullName)"
            } else {
                Write-Host "Skipped: $($match.FullName)"
            }
        }
    } else {
        Write-Host "File not found: $file"
    }
}