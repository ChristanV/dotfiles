#Requires -Version 5.1
<#
.SYNOPSIS
    Create dotfile symlinks for GlazeWM, Zebar, and Windows Terminal.
.DESCRIPTION
    Links config files from this dotfiles repo into the locations expected by
    each app. Requires Administrator (symlinks on Windows need elevated rights
    unless Developer Mode is enabled). Backs up any existing file or folder
    before replacing it.
.PARAMETER Force
    Overwrite existing items without prompting.
.EXAMPLE
    .\Symlinks.ps1
.EXAMPLE
    .\Symlinks.ps1 -Force
#>
param(
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ── Elevate if needed ─────────────────────────────────────────────────────────
$principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
$isAdmin   = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Warning "Symlinks require Administrator. Re-launching elevated..."
    $args = "-NoExit -File `"$PSCommandPath`""
    if ($Force) { $args += " -Force" }
    Start-Process powershell -Verb RunAs -ArgumentList $args
    exit
}

# ── Helpers ───────────────────────────────────────────────────────────────────
function Write-Section([string]$label) {
    Write-Host ""
    Write-Host $label -ForegroundColor Magenta
}

function Write-Ok  ([string]$msg) { Write-Host "  [ok] $msg" -ForegroundColor Green  }
function Write-Skip([string]$msg) { Write-Host "  [--] $msg" -ForegroundColor DarkGray }
function Write-Bak ([string]$msg) { Write-Host "  [bk] $msg" -ForegroundColor Yellow }
function Write-Err ([string]$msg) { Write-Host "  [!!] $msg" -ForegroundColor Red    }

function New-DotfileLink {
    param(
        [string]$Link,      # destination path (where the app looks)
        [string]$Target,    # source path (inside dotfiles repo)
        [switch]$Force
    )

    # Resolve target to an absolute path for clean comparison
    $Target = [System.IO.Path]::GetFullPath($Target)

    if (-not (Test-Path $Target)) {
        Write-Err "Source not found, skipping: $Target"
        return
    }

    # Ensure parent directory exists
    $parent = Split-Path $Link -Parent
    if (-not (Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    # Check for an existing item at the link path
    if (Test-Path $Link -PathType Any) {
        $existing = Get-Item -LiteralPath $Link -Force

        # Already a symlink pointing to the right place — nothing to do
        if ($existing.LinkType -eq 'SymbolicLink') {
            $existingTarget = ($existing.Target | Select-Object -First 1)
            $existingTarget = [System.IO.Path]::GetFullPath($existingTarget)
            if ($existingTarget -eq $Target) {
                Write-Skip "Already linked: $(Split-Path $Link -Leaf)"
                return
            }
        }

        # Prompt unless -Force
        if (-not $Force) {
            $answer = Read-Host "  '$Link' exists. Back up and replace? [Y/n]"
            if ($answer -match '^[Nn]') {
                Write-Skip "Skipped: $Link"
                return
            }
        }

        # Back up
        $backup = "$Link.bak"
        Move-Item -LiteralPath $Link -Destination $backup -Force
        Write-Bak "Backed up to: $backup"
    }

    New-Item -ItemType SymbolicLink -Path $Link -Target $Target -Force | Out-Null
    Write-Ok  "$Link"
    Write-Host "       -> $Target" -ForegroundColor DarkGray
}

# ── Paths ─────────────────────────────────────────────────────────────────────
$winDot   = $PSScriptRoot                   # …\dotfiles\windows
$appData  = $env:APPDATA                    # %APPDATA%  (Roaming)
$localApp = $env:LOCALAPPDATA               # %LOCALAPPDATA%

# ── Header ────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "Dotfiles symlink setup" -ForegroundColor White
Write-Host ("─" * 50) -ForegroundColor DarkGray

# ── GlazeWM ───────────────────────────────────────────────────────────────────
Write-Section "GlazeWM"
New-DotfileLink `
    -Link   "$appData\GlazeWM\config.yaml" `
    -Target "$winDot\glazewm\config.yaml" `
    -Force:$Force

# ── Zebar ─────────────────────────────────────────────────────────────────────
Write-Section "Zebar"
New-DotfileLink `
    -Link   "$appData\zebar\settings.json" `
    -Target "$winDot\zebar\settings.json" `
    -Force:$Force

# Link the custom pack as a directory symlink so Zebar can discover it
New-DotfileLink `
    -Link   "$appData\zebar\packs\christan.bar" `
    -Target "$winDot\zebar\packs\christan.bar" `
    -Force:$Force

# ── Windows Terminal ──────────────────────────────────────────────────────────
Write-Section "Windows Terminal"

# Try all known install locations (Store, Preview Store, portable/winget)
$wtCandidates = @(
    "$localApp\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
    "$localApp\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json",
    "$appData\Microsoft\Windows Terminal\settings.json"
)

$wtLinked = $false
foreach ($wtPath in $wtCandidates) {
    $wtDir = Split-Path $wtPath -Parent
    if (Test-Path $wtDir) {
        New-DotfileLink `
            -Link   $wtPath `
            -Target "$winDot\terminal\settings.json" `
            -Force:$Force
        $wtLinked = $true
        break
    }
}

if (-not $wtLinked) {
    Write-Host "  [--] Windows Terminal not found — skipped." -ForegroundColor DarkGray
    Write-Host "       Run this script again after installing it." -ForegroundColor DarkGray
}

# ── Done ──────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host ("─" * 50) -ForegroundColor DarkGray
Write-Host "Done. Restart GlazeWM and Zebar to apply the new configs." -ForegroundColor White
Write-Host ""
