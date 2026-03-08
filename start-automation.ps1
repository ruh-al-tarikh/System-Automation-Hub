# =============================================
# System Automation Hub Launcher
# =============================================
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
param()

# --- Config ---
$port = 9000
$listenerScript = ".\webhooks\listener.ps1"

# --- Function to start listener in a new window ---
function Start-Listener {
    Start-Process pwsh -ArgumentList "-NoExit -Command `"$listenerScript`""
    Write-Host "✅ Listener started on port $port"
}

# --- Function to start ngrok and display public URL ---
function Start-Ngrok {
    $ngrokPath = "ngrok"  # Make sure ngrok is in PATH
    $null = Start-Process $ngrokPath -ArgumentList "http $port" -NoNewWindow -PassThru -WindowStyle Minimized
    Start-Sleep -Seconds 3

    # Fetch the public URL
    try {
        $ngrokApi = Invoke-RestMethod http://127.0.0.1:4040/api/tunnels
        $publicUrl = $ngrokApi.tunnels[0].public_url
        Write-Host "🌐 ngrok tunnel started: $publicUrl"
        return $publicUrl
    } catch {
        Write-Host "⚠️ Could not fetch ngrok URL automatically. Open http://127.0.0.1:4040 for details."
    }
}

# --- Main ---
Write-Host "🚀 Starting System Automation Hub..."

Start-Listener
$ngrokUrl = Start-Ngrok

Write-Host "`n✅ All set! You can now add this webhook URL to GitHub:"
if ($ngrokUrl) { Write-Host $ngrokUrl } else { Write-Host "Use ngrok dashboard to get URL." }
Write-Host "Make a push to your repository to see automation logs."
