# Build and run the patched PdfCraft (printer paper sizes) on Windows, for the Zebra test.
# Run in PowerShell:  Set-ExecutionPolicy -Scope Process Bypass; .\windows-build.ps1
# First run: installs the build tools (Visual Studio Build Tools C++ workload, Rust, Git) with winget,
# which asks for admin approval; a reboot is not needed. Then clones the test branch and builds
# (20 to 40 minutes the first time, far less afterwards).
$ErrorActionPreference = "Stop"
$Root = Join-Path $HOME "pdfcraft-printerpapers"

function Need($cmd) { -not (Get-Command $cmd -ErrorAction SilentlyContinue) }

if (Need git)   { winget install --id Git.Git -e --accept-package-agreements --accept-source-agreements }
if (Need cargo) { winget install --id Rustlang.Rustup -e --accept-package-agreements --accept-source-agreements }
if (-not (Test-Path "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC")) {
  winget install --id Microsoft.VisualStudio.2022.BuildTools -e --accept-package-agreements --accept-source-agreements `
    --override "--wait --passive --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"
}
# New installs are not on this shell's PATH yet.
$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")

if (-not (Test-Path $Root)) {
  git clone --branch test/windows-build https://github.com/MaxFairwinds/pdfcraft $Root
} else {
  git -C $Root fetch origin
  git -C $Root checkout test/windows-build
  git -C $Root pull --ff-only
}

$env:PDFCRAFT_BUILD_LABEL = "printerpapers"
Push-Location $Root
cargo build --release -p pdfcraft
Pop-Location

$exe = Join-Path $Root "target\release\pdfcraft.exe"
Write-Host ""
Write-Host "Built: $exe"
Write-Host "Starting it. File > Print, choose the Zebra, open Paper: its own sizes follow the standard ones."
Start-Process $exe
