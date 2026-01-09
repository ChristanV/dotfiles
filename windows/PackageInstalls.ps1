# Find packages https://winget.run/
$packages = @(
    "Git.Git",
    "Microsoft.VisualStudioCode",
    "Bruno.Bruno",
    "Amazon.AWSCLI",
    "Microsoft.AzureCLI",
    "Microsoft.Azure.Kubelogin",
    "Microsoft.WSL",
    "dbeaver.dbeaver",
    "Neovim.Neovim",
    "AgileBits.1Password",
    "Notion.Notion",
    "wez.wezterm",
    "Microsoft.PowerToys",
    "Microsoft.PCManager.Beta",
    "DevToys-app.DevToys",
    "glzr-io.glazewm",
    "Microsoft.PowerBI",
    "7zip.7zip",
    "GnuPG.Gpg4win"
)

foreach ($pkg in $packages) {
    Write-Host "Installing $pkg" -ForegroundColor Cyan
    winget install -e --id $pkg --accept-package-agreements --accept-source-agreements
    Write-Host "Installed $pkg" -ForegroundColor Green
}
