$ErrorActionPreference = 'Stop'

# Set up log file on the Public Desktop so any user can see it
$publicDesktop = Join-Path $Env:Public 'Desktop'
if (-not (Test-Path $publicDesktop)) {
    New-Item -ItemType Directory -Path $publicDesktop -Force | Out-Null
}

$logPath = Join-Path $publicDesktop 'LabSoftwareInstall.log'

function Write-Log {
    param(
        [string]$Message
    )

    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $entry = "$timestamp`t$Message"
    $entry | Out-File -FilePath $logPath -Append -Encoding utf8
}

Write-Log '===== Lab software install script starting ====='

# Ensure TLS 1.2 for downloads (Chocolatey bootstrap, etc.)
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072
    Write-Log 'Set TLS protocol to include TLS 1.2.'
}
catch {
    Write-Log "Failed to set TLS protocol: $($_.Exception.Message)"
}

# Install Chocolatey if not already present
if (-not (Get-Command choco.exe -ErrorAction SilentlyContinue)) {
    Write-Log 'Chocolatey not found. Installing Chocolatey...'
    try {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        $chocoScript = 'https://community.chocolatey.org/install.ps1'
        Write-Log "Downloading Chocolatey install script from $chocoScript"
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString($chocoScript))
        Write-Log 'Chocolatey installation completed.'
    }
    catch {
        Write-Log "Chocolatey installation failed: $($_.Exception.Message)"
    }
}
else {
    Write-Log 'Chocolatey is already installed.'
}

function Install-ChocoPackage {
    param(
        [string]$PackageName
    )

    Write-Log "Installing package '$PackageName' with Chocolatey..."
    try {
        choco install $PackageName -y --no-progress 2>&1 | Tee-Object -FilePath $logPath -Append | Out-Null
        Write-Log "Package '$PackageName' installation command completed (check log for details)."
    }
    catch {
        Write-Log "Package '$PackageName' installation failed: $($_.Exception.Message)"
    }
}

# Install Docker (Docker Desktop) for lab use
Install-ChocoPackage -PackageName 'docker-desktop'

# Install VLC media player
Install-ChocoPackage -PackageName 'vlc'

# Install Visual Studio Code
Install-ChocoPackage -PackageName 'vscode'

# Install Node.js (includes npm)
Install-ChocoPackage -PackageName 'nodejs-lts'

# Install Codex CLI via npm (best-effort; may need adjustment for your environment)
$npmCmd = Get-Command npm.exe -ErrorAction SilentlyContinue
if ($npmCmd) {
    Write-Log 'npm found. Attempting to install Codex via npm (npm install -g codex)...'
    try {
        npm install -g codex 2>&1 | Tee-Object -FilePath $logPath -Append | Out-Null
        Write-Log 'Codex npm install command completed (check log for details).'
    }
    catch {
        Write-Log "Codex installation via npm failed: $($_.Exception.Message)"
    }
}
else {
    Write-Log 'npm was not found; skipping Codex installation. Ensure Node.js/npm is installed and rerun manually if needed.'
}

Write-Log '===== Lab software install script completed ====='

