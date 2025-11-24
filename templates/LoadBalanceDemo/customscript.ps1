# install IIS server role
Install-WindowsFeature -name Web-Server -IncludeManagementTools

# remove default htm file
 remove-item  C:\inetpub\wwwroot\iisstart.htm

# Add a simple landing page with a bit more flair
$page = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Hello from $($env:COMPUTERNAME)</title>
  <style>
    body { margin: 0; font-family: 'Segoe UI', Arial, sans-serif; color: #0f172a; background: linear-gradient(135deg, #d9e8ff 0%, #f5f7ff 100%); display: grid; place-items: center; min-height: 100vh; }
    .card { background: #fff; border-radius: 14px; box-shadow: 0 10px 30px rgba(15, 23, 42, 0.1); padding: 32px 40px; max-width: 640px; text-align: center; }
    h1 { margin: 0 0 12px; font-size: 32px; letter-spacing: -0.5px; }
    p { margin: 6px 0; font-size: 16px; color: #334155; }
    .badge { display: inline-block; margin-top: 14px; padding: 8px 14px; border-radius: 999px; background: #e0f2fe; color: #0369a1; font-weight: 600; }
  </style>
</head>
<body>
  <div class="card">
    <h1>Hello there!</h1>
    <p>You have reached <strong>$($env:COMPUTERNAME)</strong>.</p>
    <p>The current time is <strong>$((Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))</strong>.</p>
    <p class="badge">Served by IIS on Windows</p>
    <p style="margin-top:18px; font-weight:600;">Grab the VM name from a terminal:</p>
    <pre style="text-align:left; background:#0f172a; color:#e2e8f0; padding:12px 14px; border-radius:10px; overflow:auto; font-size:13px;">
Invoke-WebRequest http://YOUR-VM-OR-LB | Select-String "reached &lt;strong&gt;(.+?)&lt;/strong&gt;" | %% { $_.Matches[0].Groups[1].Value }</pre>
  </div>
</body>
</html>
"@

$page | Set-Content -Path "C:\inetpub\wwwroot\iisstart.htm" -Encoding UTF8
