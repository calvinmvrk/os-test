#!/usr/bin/env pwsh
#Requires -Version 7.0

<#
.SYNOPSIS
    Lists all files in the current directory.

.DESCRIPTION
    This script lists all files in the current directory using PowerShell.
    It displays the files in a simple format showing their names.

.EXAMPLE
    .\list-files.ps1
    Lists all files in the current directory
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# Get all files in the current directory
Write-Host "Files in current directory:"
Write-Host "----------------------------"

Get-ChildItem -Path . -File | ForEach-Object {
    Write-Host $_.Name
}
