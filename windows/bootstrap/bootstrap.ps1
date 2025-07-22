Write-Host "Setting execution policy..." -ForegroundColor Cyan
Set-ExecutionPolicy Bypass -Scope Process -Force

Write-Host "Downloading Chocolatey installation script..." -ForegroundColor Cyan
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$chocoInstallScript = 'https://community.chocolatey.org/install.ps1'

Write-Host "Running installation script..." -ForegroundColor Cyan
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString($chocoInstallScript))

Write-Host "Verifying installation..." -ForegroundColor Cyan
choco -v

# Find packages https://community.chocolatey.org/packages
$packages = @("git", "vscode", "bruno", "awscli", "azure-cli", "azure-kubelogin", "wsl")

foreach ($pkg in $packages) {
    Write-Host "Installing $pkg" -ForegroundColor Cyan
    choco install $pkg -y
    Write-Host "Installed $pkg" -ForegroundColor Cyan
}

