#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting deployment automation...${NC}"

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}📦 Initializing git repository...${NC}"
    git init
fi

# Create .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    echo -e "${YELLOW}📝 Creating .gitignore...${NC}"
    cat > .gitignore << EOF
site/
.cache/
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
env/
venv/
.venv/
.vscode/
.idea/
*.swp
*.swo
.DS_Store
EOF
fi

# Ask for repository name
read -p "Enter GitHub repository name: " REPO_NAME

# Ask for GitHub username
read -p "Enter your GitHub username: " USERNAME

# Create repo on GitHub via API (requires gh CLI)
if command -v gh &> /dev/null; then
    echo -e "${GREEN}🔧 Creating repository on GitHub...${NC}"
    gh repo create "$REPO_NAME" --public --source=. --remote=origin --push
else
    echo -e "${YELLOW}⚠️  GitHub CLI not installed. Please create repo manually.${NC}"
    echo -e "${YELLOW}   Then run: git remote add origin https://github.com/$USERNAME/$REPO_NAME.git${NC}"
    exit 1
fi

# Add all files
echo -e "${GREEN}📤 Adding files...${NC}"
git add .

# Commit
echo -e "${GREEN}💾 Committing...${NC}"
git commit -m "Initial commit: MkDocs site"

# Push
echo -e "${GREEN}🚀 Pushing to GitHub...${NC}"
git branch -M main
git push -u origin main

# Deploy to GitHub Pages
echo -e "${GREEN}🌐 Deploying to GitHub Pages...${NC}"
mkdocs gh-deploy --force

echo -e "${GREEN}✅ Done! Your site is live at:${NC}"
echo -e "${GREEN}   https://$USERNAME.github.io/$REPO_NAME/${NC}"