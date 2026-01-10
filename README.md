# os-test

A test repository for Windows Node.js setup automation on GitHub Actions runners.

## Overview

This repository contains automation scripts and workflows designed to set up Node.js in GitHub Actions Windows environments. It's particularly useful for scenarios where you need a specific version of Node.js available in a controlled location for GitHub Copilot coding agents or other automation tasks.

## Repository Structure

```
os-test/
├── script/
│   └── setup.ps1          # PowerShell script to set up Node.js on Windows
├── .github/
│   └── workflows/
│       ├── copilot-setup-steps.yaml  # Workflow for Copilot setup
│       └── node-test.yaml            # Workflow to test Node.js setup
├── node-req.env           # Node.js version requirements
└── README.md             # This file
```

## What Does It Do?

### The Setup Script (`script/setup.ps1`)

The core component is a PowerShell 7+ script that:

1. **Locates Node.js**: Searches for a compatible Node.js version in the GitHub Actions tool cache
2. **Downloads if Needed**: If not found in cache, downloads the specified version from nodejs.org
3. **Creates a Link**: Sets up a junction point (Windows symlink) to make Node.js available at a specified location
4. **Verifies Installation**: Confirms Node.js is working correctly

### Version Configuration (`node-req.env`)

Defines the Node.js version requirements:
- `TARGET_NODE_VERSION`: Pattern for the desired Node.js version (e.g., '22.*')
- `FALLBACK_DL_NODE_VERSION`: Specific version to download if not found in cache
- `FALLBACK_DL_URL`: Alternative download URL (primarily for Linux environments)

## Usage

### Running the Setup Script

On a Windows GitHub Actions runner:

```powershell
.\script\setup.ps1 "D:\path\to\target\location"
```

If no target location is provided, defaults to `$env:RUNNER_TEMP/ghcca-node`.

### Requirements

- **PowerShell 7.0+**: The script requires PowerShell 7 or later
- **GitHub Actions Environment**: Expects `RUNNER_TOOL_CACHE` and `RUNNER_TEMP` environment variables
- **Internet Access**: Required if Node.js needs to be downloaded

### GitHub Actions Workflow Example

```yaml
- name: Run setup script
  shell: pwsh
  run: |
    & ".\script\setup.ps1" "D:\a\_temp\ghcca-node"

- name: Verify Node.js works
  shell: pwsh
  run: |
    $nodePath = "D:\a\_temp\ghcca-node\node\node.exe"
    if (-not (Test-Path $nodePath)) {
      $nodePath = "D:\a\_temp\ghcca-node\node\bin\node.exe"
    }
    & $nodePath --version
```

## Workflows

### `copilot-setup-steps.yaml`
A basic workflow that checks out the repository on Windows runners. Can be triggered manually via workflow dispatch.

### `node-test.yaml`
Tests the Node.js setup process:
1. Checks out the repository
2. Runs the setup script
3. Verifies Node.js installation and functionality

## Features

- **Tool Cache First**: Leverages GitHub Actions tool cache for faster setup
- **Automatic Download**: Falls back to downloading if not cached
- **Windows Optimized**: Uses junction points to avoid requiring administrator privileges
- **Flexible Versioning**: Supports version patterns (e.g., 22.*) and specific versions
- **Error Handling**: Includes fallback mechanisms and clear error messages

## Use Cases

This repository is ideal for:
- Setting up Node.js for GitHub Copilot coding agents on Windows
- Testing Node.js availability in GitHub Actions Windows environments
- Creating reusable Node.js setup patterns for Windows-based CI/CD pipelines
- Ensuring consistent Node.js versions across workflow runs

## Technical Details

### How It Works

1. **Cache Check**: The script first looks in `$env:RUNNER_TOOL_CACHE/node` for matching versions
2. **Pattern Matching**: Uses regex to match version patterns (e.g., 22.* matches any 22.x.x version)
3. **Download & Extract**: If not cached, downloads the Windows x64 zip from nodejs.org and extracts it
4. **Linking**: Creates a junction point (directory symlink) for easy access
5. **Fallback**: If junction creation fails, copies the directory instead

### Directory Structure After Setup

```
<TargetLocation>/
└── node/
    ├── node.exe         (or in bin/ subdirectory)
    ├── npm
    ├── npx
    └── node_modules/
```

## Contributing

This is a test repository, but improvements to the setup script or workflows are welcome!

## License

This is a test repository for OS and Node.js setup automation.