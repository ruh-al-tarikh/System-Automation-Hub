Describe "System Automation Hub Structure" {
    It "Should have the main entry point (start-automation.ps1)" {
        Test-Path "./start-automation.ps1" | Should -Be \$true
    }

    It "Should have the webhooks/listener.ps1 script" {
        Test-Path "./webhooks/listener.ps1" | Should -Be \$true
    }

    It "Should have at least one script in the scripts/ directory" {
        (Get-ChildItem "./scripts/*.ps1").Count | Should -BeGreaterOrEqual 1
    }
}

Describe "PowerShell Script Syntax Verification" {
    Context "Checking all .ps1 files" {
        \$psFiles = Get-ChildItem -Path . -Include *.ps1 -Recurse

        foreach (\$file in \$psFiles) {
            It "Should have valid syntax for \$(\$file.Name)" {
                \$errorActionPreference = "Stop"
                Get-Command -ErrorAction SilentlyContinue -Name Out-Null # Ensure we can run commands

                # Check for syntax errors by parsing the script
                { [Microsoft.PowerShell.Commands.ScriptAnalyzer.Helper]::GetTokens(\$file.FullName, [ref]\$null, [ref]\$null) } | Should -Not -Throw
            }
        }
    }
}
