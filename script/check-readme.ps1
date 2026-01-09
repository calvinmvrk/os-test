#!/usr/bin/env pwsh
#Requires -Version 7.0

<#
.SYNOPSIS
    Checks if README.md file exists in the repository.

.DESCRIPTION
    This script verifies the presence of a README.md file in the repository root directory.
    Returns exit code 0 if README.md exists, exit code 1 if it doesn't exist.

.EXAMPLE
    .\check-readme.ps1
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# Get the repository root directory (parent of script directory)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$ReadmePath = Join-Path $RepoRoot "README.md"

Write-Host "Checking for README.md in repository..."
Write-Host "Repository root: $RepoRoot"
Write-Host "Expected README.md path: $ReadmePath"
Write-Host ""

if (Test-Path $ReadmePath) {
    Write-Host "✓ SUCCESS: README.md exists!" -ForegroundColor Green
    Write-Host "Location: $ReadmePath" -ForegroundColor Green
    
    # Display file info
    $fileInfo = Get-Item $ReadmePath
    Write-Host ""
    Write-Host "File Details:" -ForegroundColor Cyan
    Write-Host "  Size: $($fileInfo.Length) bytes"
    Write-Host "  Last Modified: $($fileInfo.LastWriteTime)"
    
    exit 0
}
else {
    Write-Host "✗ FAILURE: README.md does not exist!" -ForegroundColor Red
    Write-Host "Expected location: $ReadmePath" -ForegroundColor Red
    exit 1
}
