Describe "System Automation Hub Structure" {
    It "Should have the main entry point (start-automation.ps1)" {
        Test-Path "./start-automation.ps1" | Should -Be $true
    }

    It "Should have the webhooks/listener.ps1 script" {
        Test-Path "./webhooks/listener.ps1" | Should -Be $true
    }

    It "Should have at least one script in the scripts/ directory" {
        (Get-ChildItem "./scripts/*.ps1").Count | Should -BeGreaterOrEqual 1
    }
}

Describe "PowerShell Script Syntax Verification" {
    Context "Checking all .ps1 files" {
        $psFiles = Get-ChildItem -Path $PSScriptRoot/.. -Include *.ps1 -Recurse

        It "Should have valid syntax for <Name>" -ForEach $psFiles {
            $errors = $null
            $tokens = $null
            # Use the built-in Parser to verify syntax without external module dependencies
            [System.Management.Automation.Language.Parser]::ParseFile($_.FullName, [ref]$tokens, [ref]$errors) | Out-Null

            if ($errors) {
                $errorMessages = $errors | ForEach-Object { "$($_.Message) at line $($_.Extent.StartLineNumber):$($_.Extent.StartColumnNumber)" }
                throw "Syntax errors found in $($_.Name):`n$($errorMessages -join "`n")"
            }
        }
    }
}
