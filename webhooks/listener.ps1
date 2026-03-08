<<<<<<< HEAD
﻿[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "")]
# =============================================
# System Automation Hub - Webhook Listener
# =============================================
=======
﻿# =============================================
# System Automation Hub - Webhook Listener
# =============================================
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "")]
param()

>>>>>>> origin/remote-control-bridge-12936344523257638862
$port = 9000
$endpoint = "http://localhost:$port/"

# Ensure we don't try to start another listener if one is already running in this session
if ($null -ne $listener) {
    try { $listener.Stop() } catch { Write-Verbose "Listener already stopped." }
}

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($endpoint)

try {
    $listener.Start()
<<<<<<< HEAD
    Write-Host "🚀 Listener started on $endpoint" -ForegroundColor Cyan
    Write-Host "Press Ctrl+C to stop.`n" -ForegroundColor DarkGray

    Write-Host "💡 To test locally, run:" -ForegroundColor Green
    Write-Host "curl -X POST $endpoint -d '{""test"": ""hello""}' -H 'Content-Type: application/json'" -ForegroundColor DarkGray
    Write-Host "`nWaiting for events..." -ForegroundColor Cyan
=======
    Write-Host "🚀 Listener started on $endpoint"
    Write-Host "Press Ctrl+C to stop.`n"
>>>>>>> origin/remote-control-bridge-12936344523257638862

    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

<<<<<<< HEAD
        $timestamp = Get-Date -Format 'HH:mm:ss'
        $method = $request.HttpMethod
        $remote = $request.RemoteEndPoint
        $userAgent = $request.UserAgent
        $isGitHub = $userAgent -match "GitHub-Hookshot"

        $sourceIcon = if ($isGitHub) { "🐙 GitHub " } else { "🔗 Web " }

        Write-Host "[$timestamp] " -ForegroundColor Gray -NoNewline
        Write-Host "$sourceIcon" -ForegroundColor Magenta -NoNewline
        Write-Host "$method " -ForegroundColor Yellow -NoNewline
        Write-Host "from " -ForegroundColor Gray -NoNewline
        Write-Host "$remote" -ForegroundColor White
=======
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Received $($request.HttpMethod) request from $($request.RemoteEndPoint)"
>>>>>>> origin/remote-control-bridge-12936344523257638862

        # Read body if available
        if ($request.HasEntityBody) {
            $reader = New-Object System.IO.StreamReader($request.InputStream, [System.Text.Encoding]::UTF8)
            $body = $reader.ReadToEnd()
<<<<<<< HEAD

            try {
                if ($request.ContentType -match "application/json") {
                    $jsonObj = $body | ConvertFrom-Json
                    $prettyBody = $jsonObj | ConvertTo-Json -Depth 10
                    Write-Host "Payload (JSON):" -ForegroundColor Cyan
                    Write-Host $prettyBody -ForegroundColor DarkGray
                } else {
                    Write-Host "Payload:" -ForegroundColor Cyan
                    Write-Host $body -ForegroundColor DarkGray
                }
            } catch {
                Write-Host "Payload (Raw):" -ForegroundColor Cyan
                Write-Host $body -ForegroundColor DarkGray
            }
=======
            Write-Host "Payload: $body"
>>>>>>> origin/remote-control-bridge-12936344523257638862
        }

        # Simple response
        $buffer = [System.Text.Encoding]::UTF8.GetBytes("System Automation Hub: Event Received")
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
        $response.Close()
<<<<<<< HEAD
        Write-Host "Done.`n" -ForegroundColor DarkGray
    }
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
=======
    }
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)"
>>>>>>> origin/remote-control-bridge-12936344523257638862
} finally {
    if ($null -ne $listener) {
        $listener.Stop()
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> origin/remote-control-bridge-12936344523257638862
