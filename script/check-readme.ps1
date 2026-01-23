#!/usr/bin/env pwsh
#Requires -Version 7.0

<#
.SYNOPSIS
    Checks if README.md file exists in the repository.

.DESCRIPTION
    This script checks if a README.md file exists in the repository root
    using shell commands and provides appropriate output.

.EXAMPLE
    .\check-readme.ps1
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# Get the repository root (parent of the script directory)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir

# Define the README.md path
$ReadmePath = Join-Path $RepoRoot "README.md"

Write-Host "Checking for README.md in repository root..." -ForegroundColor Cyan
Write-Host "Repository root: $RepoRoot" -ForegroundColor Gray
Write-Host "Looking for: $ReadmePath" -ForegroundColor Gray
Write-Host ""

# Check if README.md exists
if (Test-Path $ReadmePath) {
    Write-Host "✓ README.md exists!" -ForegroundColor Green
    Write-Host "  Location: $ReadmePath" -ForegroundColor Gray
    
    # Get file info
    $fileInfo = Get-Item $ReadmePath
    Write-Host "  Size: $($fileInfo.Length) bytes" -ForegroundColor Gray
    Write-Host "  Last modified: $($fileInfo.LastWriteTime)" -ForegroundColor Gray
    
    exit 0
} else {
    Write-Host "✗ README.md not found!" -ForegroundColor Red
    Write-Host "  Expected location: $ReadmePath" -ForegroundColor Gray
    
    exit 1
}
