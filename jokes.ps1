#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Simple joke telling script for PowerShell

.DESCRIPTION
    A fun script that tells programming jokes. Can tell all jokes, a random joke,
    or a specific joke by number.

.PARAMETER Random
    Tell a random joke

.PARAMETER Number
    Tell a specific joke by number (1-10)

.PARAMETER All
    Tell all jokes (default)

.PARAMETER Help
    Show help message

.EXAMPLE
    .\jokes.ps1
    Tells all jokes

.EXAMPLE
    .\jokes.ps1 -Random
    Tells a random joke

.EXAMPLE
    .\jokes.ps1 -Number 3
    Tells joke number 3
#>

[CmdletBinding()]
param(
    [switch]$Random,
    [int]$Number,
    [switch]$All,
    [switch]$Help
)

$jokes = @(
    @{
        Setup = "Why don't scientists trust atoms?"
        Punchline = "Because they make up everything!"
    },
    @{
        Setup = "Why did the programmer quit his job?"
        Punchline = "Because he didn't get arrays!"
    },
    @{
        Setup = "What do you call a bear with no teeth?"
        Punchline = "A gummy bear!"
    },
    @{
        Setup = "Why do programmers prefer dark mode?"
        Punchline = "Because light attracts bugs!"
    },
    @{
        Setup = "What's the object-oriented way to become wealthy?"
        Punchline = "Inheritance!"
    },
    @{
        Setup = "Why did the JavaScript developer leave the restaurant?"
        Punchline = "Because he couldn't find the 'this' keyword!"
    },
    @{
        Setup = "How many programmers does it take to change a light bulb?"
        Punchline = "None, that's a hardware problem!"
    },
    @{
        Setup = "What do you call a programmer from Finland?"
        Punchline = "Nerdic!"
    },
    @{
        Setup = "Why do Java developers wear glasses?"
        Punchline = "Because they can't C#!"
    },
    @{
        Setup = "What's a programmer's favorite hangout place?"
        Punchline = "Foo Bar!"
    }
)

function Show-Help {
    Write-Host @"

🎭 Joke Teller Script (PowerShell)
Usage: .\jokes.ps1 [options]

Options:
  -Random              Tell a random joke
  -Number N            Tell joke number N (1-$($jokes.Count))
  -All                 Tell all jokes
  -Help                Show this help message

Examples:
  .\jokes.ps1                    Tell all jokes
  .\jokes.ps1 -Random            Tell a random joke
  .\jokes.ps1 -Number 3          Tell joke number 3

"@
}

function Show-Joke {
    param([int]$Index)
    
    if ($Index -lt 0 -or $Index -ge $jokes.Count) {
        Write-Host "Invalid joke index!" -ForegroundColor Red
        return
    }
    
    $joke = $jokes[$Index]
    Write-Host ""
    Write-Host $joke.Setup -ForegroundColor Cyan
    Write-Host "..." -ForegroundColor Gray
    Start-Sleep -Milliseconds 500
    Write-Host $joke.Punchline -ForegroundColor Yellow
    Write-Host ""
}

function Show-RandomJoke {
    $randomIndex = Get-Random -Minimum 0 -Maximum $jokes.Count
    Show-Joke -Index $randomIndex
}

function Show-AllJokes {
    Write-Host ""
    Write-Host "🎭 Here are all $($jokes.Count) jokes:" -ForegroundColor Green
    Write-Host ""
    
    for ($i = 0; $i -lt $jokes.Count; $i++) {
        Write-Host "$($i + 1). " -NoNewline -ForegroundColor White
        Write-Host $jokes[$i].Setup -ForegroundColor Cyan
        Write-Host "   " -NoNewline
        Write-Host $jokes[$i].Punchline -ForegroundColor Yellow
        Write-Host ""
    }
}

# Main logic
if ($Help) {
    Show-Help
}
elseif ($Random) {
    Show-RandomJoke
}
elseif ($Number -gt 0) {
    if ($Number -ge 1 -and $Number -le $jokes.Count) {
        Show-Joke -Index ($Number - 1)
    }
    else {
        Write-Host ""
        Write-Host "Please specify a joke number between 1 and $($jokes.Count)" -ForegroundColor Red
        Write-Host ""
    }
}
else {
    # Default: show all jokes
    Show-AllJokes
}
