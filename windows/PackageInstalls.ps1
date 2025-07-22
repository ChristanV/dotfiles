# Find packages https://community.chocolatey.org/packages
$packages = @("git", "vscode", "bruno", "awscli", "azure-cli", "azure-kubelogin", "wsl", "dbeaver")

foreach ($pkg in $packages) {
    Write-Host "Installing $pkg" -ForegroundColor Cyan
    choco install $pkg -y
    Write-Host "Installed $pkg" -ForegroundColor Cyan
}