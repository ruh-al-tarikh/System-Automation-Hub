# Bolt's Performance Journal ⚡

## 2025-05-14 - [Webhook Latency Optimization & PowerShell Efficiency]
**Learning:** In event-driven systems like webhook listeners, the "Early Response" pattern is critical for minimizing sender-side latency. By closing the HTTP response immediately after reading the payload, we decouple the processing/logging time from the network turnaround time. Additionally, in PowerShell, cmdlets like `Get-Date` and the use of the pipeline (`|`) introduce significant overhead compared to direct .NET methods and parameter passing (`-InputObject`).

**Action:**
1. Move `$response.Close()` to immediately follow the request body read.
2. Replace `Get-Date` with `[DateTime]::Now` for timestamping.
3. Replace pipeline operations with direct parameter passing in high-frequency loops.
4. Pre-allocate static buffers (like response bytes) outside the main request loop.
