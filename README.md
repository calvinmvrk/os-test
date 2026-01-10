# os-test

## 🎭 Joke Teller

This repository includes a fun joke-telling feature! Use the joke scripts to brighten your day with programming jokes.

### Usage

#### Node.js Version

Tell all jokes:
```bash
node jokes.js
```

Tell a random joke:
```bash
node jokes.js --random
```

Tell a specific joke (1-10):
```bash
node jokes.js --number 3
```

Get help:
```bash
node jokes.js --help
```

#### PowerShell Version

Tell all jokes:
```powershell
.\jokes.ps1
```

Tell a random joke:
```powershell
.\jokes.ps1 -Random
```

Tell a specific joke (1-10):
```powershell
.\jokes.ps1 -Number 3
```

Get help:
```powershell
.\jokes.ps1 -Help
```

### Examples

**Node.js:**
```bash
# Tell a random joke
node jokes.js -r

# Tell joke number 5
node jokes.js -n 5

# See all available jokes
node jokes.js --all
```

**PowerShell:**
```powershell
# Tell a random joke
.\jokes.ps1 -Random

# Tell joke number 5
.\jokes.ps1 -Number 5

# See all available jokes
.\jokes.ps1 -All
```