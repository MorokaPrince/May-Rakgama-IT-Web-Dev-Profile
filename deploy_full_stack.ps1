# PowerShell script for automating React project setup, GitHub connection, and deployment

# Set execution policy to allow scripts
Set-ExecutionPolicy Unrestricted -Scope Process -Force

# Function to install Node.js if not found
function Install-Node {
    if (!(Get-Command "node" -ErrorAction SilentlyContinue)) {
        Write-Host "Node.js not found. Installing..."
        Start-Process "https://nodejs.org/en/download/" -Wait
        Read-Host "Install Node.js and press Enter to continue..."
    }
}

# Function to install Git if not found
function Install-Git {
    if (!(Get-Command "git" -ErrorAction SilentlyContinue)) {
        Write-Host "Git not found. Installing..."
        Start-Process "https://git-scm.com/download/win" -Wait
        Read-Host "Install Git and press Enter to continue..."
    }
}

# Function to install required npm packages
function Install-NPM-Tools {
    Write-Host "Installing deployment tools (Vercel, Netlify, Firebase, GitHub CLI)..."
    npm install -g vercel netlify-cli firebase-tools gh-pages @githubnext/github-copilot-cli
}

# Install Node.js and Git if missing
Install-Node
Install-Git

# Install required npm tools
Install-NPM-Tools

# Clone the existing repository
Write-Host "Cloning your GitHub repository..."
git clone https://github.com/MorokaPrince/May-Rakgama-IT-Web-Dev-Profile.git
Set-Location May-Rakgama-IT-Web-Dev-Profile

# Install project dependencies
Write-Host "Installing dependencies..."
npm install

# Build the React project
Write-Host "Building the project..."
npm run build

# Ask user where to deploy
Write-Host "Choose a deployment platform:"
Write-Host "1. Vercel"
Write-Host "2. Netlify"
Write-Host "3. GitHub Pages"
Write-Host "4. Firebase Hosting"
$choice = Read-Host "Enter the number of your choice"

# Deploy based on user's choice
if ($choice -eq "1") {
    Write-Host "Deploying to Vercel..."
    vercel login
    vercel --prod
} elseif ($choice -eq "2") {
    Write-Host "Deploying to Netlify..."
    netlify login
    netlify deploy --prod
} elseif ($choice -eq "3") {
    Write-Host "Deploying to GitHub Pages..."
    npm install gh-pages --save-dev
    Set-Content -Path "package.json" -Value (Get-Content -Path "package.json" -Raw).Replace('"scripts": {', '"scripts": {"predeploy": "npm run build","deploy": "gh-pages -d build",')
    npm run deploy
} elseif ($choice -eq "4") {
    Write-Host "Deploying to Firebase..."
    firebase login
    firebase init
    firebase deploy
} else {
    Write-Host "Invalid choice. Exiting."
    exit
}

# Ask user for deployed URL
$deployedURL = Read-Host "Enter your deployed URL"

# Create a desktop shortcut for the deployed website
$shortcutPath = "$env:USERPROFILE\Desktop\Profile Website.lnk"
$wshell = New-Object -ComObject WScript.Shell
$shortcut = $wshell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $deployedURL
$shortcut.Save()

# Open the deployed website
Start-Process $deployedURL

Write-Host "Deployment complete! Your online resume is now live."
