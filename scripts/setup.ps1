#!/usr/bin/env pwsh
#Requires -Version 7.0

<#
.SYNOPSIS
    Sets up Node.js for the GitHub Copilot coding agent on Windows.

.DESCRIPTION
    This script downloads and sets up the required version of Node.js from the tool cache
    or downloads it if not available. It creates a symlink to the Node.js installation
    in the specified target location.

.PARAMETER TargetLocation
    The target location where Node.js will be linked. Defaults to $env:RUNNER_TEMP/ghcca-node

.EXAMPLE
    .\setup.ps1 "C:\runner\temp\ghcca-node"
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$TargetLocation
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# Get the script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Validate required environment variables
if ([string]::IsNullOrEmpty($env:RUNNER_TOOL_CACHE) -or [string]::IsNullOrEmpty($env:RUNNER_TEMP)) {
    Write-Error "RUNNER_TOOL_CACHE or RUNNER_TEMP is not set. Please set them to the correct paths."
    exit 1
}

# Set default target location if not provided
if ([string]::IsNullOrEmpty($TargetLocation)) {
    $TargetLocation = Join-Path $env:RUNNER_TEMP "ghcca-node"
}

# Read node requirements from node-req.env
$nodeReqFile = Join-Path $ScriptDir "..\node-req.env"
if (-not (Test-Path $nodeReqFile)) {
    Write-Error "node-req.env file not found at $nodeReqFile"
    exit 1
}

$nodeReqContent = Get-Content $nodeReqFile -Raw
$targetNodeVersion = if ($nodeReqContent -match "TARGET_NODE_VERSION='([^']+)'") { $Matches[1] } else { "22.*" }
$fallbackDlNodeVersion = if ($nodeReqContent -match "FALLBACK_DL_NODE_VERSION=([^\r\n]+)") { $Matches[1] } else { "22.15.0" }
# Note: The fallback URL in node-req.env is for Linux. We'll construct the Windows URL dynamically.
$fallbackDlUrlBase = "https://github.com/actions/node-versions/releases/download"

Write-Host "Target Node version pattern: $targetNodeVersion"
Write-Host "Fallback Node version: $fallbackDlNodeVersion"

# Create target directory
New-Item -ItemType Directory -Force -Path $TargetLocation | Out-Null

# Try to find Node.js in the tool cache
$cacheDir = $null
$nodeBasePath = Join-Path $env:RUNNER_TOOL_CACHE "node"

if (Test-Path $nodeBasePath) {
    # Find matching version directories (e.g., 22.15.0)
    $versionPattern = $targetNodeVersion -replace '\.\*', '.*'
    $matchingDirs = Get-ChildItem -Path $nodeBasePath -Directory |
        Where-Object { $_.Name -match "^$versionPattern" } |
        Sort-Object Name |
        Select-Object -Last 1

    if ($matchingDirs) {
        # Use x64 subdirectory
        $cacheDir = Join-Path $matchingDirs.FullName "x64"
        if (Test-Path $cacheDir) {
            Write-Host "Using Node.js from tool cache: $cacheDir"
        } else {
            $cacheDir = $null
        }
    }
}

# If not found in cache, download it
if (-not $cacheDir) {
    Write-Host "Acquiring required version of Node.js: $fallbackDlNodeVersion"

    $version = $fallbackDlNodeVersion
    $cacheDir = Join-Path $env:RUNNER_TOOL_CACHE "node\$version\x64"

    # Create cache directory
    New-Item -ItemType Directory -Force -Path $cacheDir | Out-Null

    # Construct Windows download URL
    # GitHub Actions releases node versions with timestamps, we'll use a simpler direct nodejs.org URL
    # or construct the actions URL format: https://github.com/actions/node-versions/releases/download/VERSION-TIMESTAMP/node-VERSION-win-x64.zip
    # For simplicity, we'll use nodejs.org which is more reliable for Windows
    $downloadUrl = "https://nodejs.org/dist/v$version/node-v$version-win-x64.zip"
    $zipFile = Join-Path $cacheDir "node.zip"

    Write-Host "Downloading Node.js from $downloadUrl"

    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFile -ErrorAction Stop

        # Extract the zip file to temp location first
        Write-Host "Extracting Node.js..."
        $tempExtract = Join-Path $env:TEMP "node-extract-temp"
        New-Item -ItemType Directory -Force -Path $tempExtract | Out-Null
        Expand-Archive -Path $zipFile -DestinationPath $tempExtract -Force

        # The extracted folder will be node-v$version-win-x64
        $extractedFolder = Join-Path $tempExtract "node-v$version-win-x64"

        if (Test-Path $extractedFolder) {
            # Create bin directory to match GitHub Actions tool cache structure
            $binDir = Join-Path $cacheDir "bin"
            New-Item -ItemType Directory -Force -Path $binDir | Out-Null

            # Move executables to bin/
            Move-Item -Path (Join-Path $extractedFolder "node.exe") -Destination $binDir -Force

            # Move other files/folders to cache root
            $itemsToMove = Get-ChildItem -Path $extractedFolder -Exclude "node.exe"
            foreach ($item in $itemsToMove) {
                $destPath = if ($item.PSIsContainer) { $cacheDir } else { $binDir }
                Move-Item -Path $item.FullName -Destination $destPath -Force -ErrorAction SilentlyContinue
            }

            # Clean up
            Remove-Item -Path $tempExtract -Recurse -Force
        }

        # Remove the zip file
        Remove-Item -Path $zipFile -Force

        Write-Host "Node.js downloaded and extracted successfully."
    }
    catch {
        Write-Error "Failed to download or extract Node.js: $_"
        exit 1
    }
}

# Create symlink/junction to Node.js
$linkLocation = Join-Path $TargetLocation "node"

# Remove existing link if it exists
if (Test-Path $linkLocation) {
    Remove-Item -Path $linkLocation -Force -Recurse
}

# On Windows, we'll create a junction (directory symlink) instead of a symbolic link
# because junctions don't require admin privileges
try {
    # Use cmd /c mklink /J for junction which doesn't require elevation
    $cacheDirResolved = Resolve-Path $cacheDir
    cmd /c mklink /J "$linkLocation" "$cacheDirResolved" | Out-Null

    if ($LASTEXITCODE -ne 0) {
        # Fallback: just copy the directory if junction fails
        Write-Warning "Failed to create junction, copying directory instead..."
        Copy-Item -Path $cacheDir -Destination $linkLocation -Recurse -Force
    }
}
catch {
    # Fallback: just copy the directory
    Write-Warning "Failed to create junction: $_. Copying directory instead..."
    Copy-Item -Path $cacheDir -Destination $linkLocation -Recurse -Force
}

# Verify Node.js installation
# On Windows, node.exe may be at the root (tool cache) or in bin\ (downloaded)
$nodeExe = Join-Path $linkLocation "node.exe"
if (-not (Test-Path $nodeExe)) {
    $nodeExe = Join-Path $linkLocation "bin\node.exe"
}

if (Test-Path $nodeExe) {
    $nodeVersion = & $nodeExe --version
    Write-Host "Node.js setup complete. Version: $nodeVersion"
    Write-Host "Node.js location: $linkLocation"
    Write-Host "Node.js executable: $nodeExe"
}
else {
    Write-Error "Node.js executable not found at $linkLocation\node.exe or $linkLocation\bin\node.exe"
    exit 1
}
