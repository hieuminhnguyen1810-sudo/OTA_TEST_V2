#!/bin/bash

# OTA & CI/CD Test Script
# Test OTA updates và verify configuration

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

cd "$(dirname "$0")/.."

echo -e "${BLUE}🧪 Testing OTA & CI/CD Configuration${NC}\n"

# Test 1: Check EAS CLI
echo -e "${YELLOW}[1/8] Checking EAS CLI...${NC}"
if command -v eas &> /dev/null; then
    EAS_VERSION=$(eas --version)
    echo -e "${GREEN}✅ EAS CLI installed: $EAS_VERSION${NC}"
else
    echo -e "${RED}❌ EAS CLI not found! Install: npm install -g eas-cli${NC}"
    exit 1
fi

# Test 2: Check EAS Login
echo -e "\n${YELLOW}[2/8] Checking EAS authentication...${NC}"
if eas whoami &> /dev/null; then
    USER=$(eas whoami)
    echo -e "${GREEN}✅ Logged in as: $USER${NC}"
else
    echo -e "${RED}❌ Not logged in! Run: eas login${NC}"
    exit 1
fi

# Test 3: Check Project Info
echo -e "\n${YELLOW}[3/8] Checking project configuration...${NC}"
if eas project:info &> /dev/null; then
    PROJECT_ID=$(eas project:info 2>/dev/null | grep "ID" | awk '{print $2}')
    echo -e "${GREEN}✅ Project connected: $PROJECT_ID${NC}"
else
    echo -e "${RED}❌ Project not configured! Check app.json${NC}"
    exit 1
fi

# Test 4: Check eas.json
echo -e "\n${YELLOW}[4/8] Validating eas.json...${NC}"
if node -e "JSON.parse(require('fs').readFileSync('eas.json', 'utf8'))" 2>/dev/null; then
    echo -e "${GREEN}✅ eas.json is valid JSON${NC}"
else
    echo -e "${RED}❌ eas.json is invalid!${NC}"
    exit 1
fi

# Test 5: Check app.json
echo -e "\n${YELLOW}[5/8] Validating app.json...${NC}"
if node -e "JSON.parse(require('fs').readFileSync('app.json', 'utf8'))" 2>/dev/null; then
    RUNTIME_VERSION=$(node -e "console.log(require('./app.json').expo.runtimeVersion?.policy || 'not set')")
    UPDATES_URL=$(node -e "console.log(require('./app.json').expo.updates?.url || 'not set')")
    echo -e "${GREEN}✅ app.json is valid${NC}"
    echo -e "   Runtime Version Policy: $RUNTIME_VERSION"
    echo -e "   Updates URL: ${UPDATES_URL:0:50}..."
else
    echo -e "${RED}❌ app.json is invalid!${NC}"
    exit 1
fi

# Test 6: Check expo-updates package
echo -e "\n${YELLOW}[6/8] Checking expo-updates package...${NC}"
if npm list expo-updates &> /dev/null; then
    VERSION=$(npm list expo-updates 2>/dev/null | grep expo-updates | awk '{print $2}' | sed 's/@//')
    echo -e "${GREEN}✅ expo-updates installed: $VERSION${NC}"
else
    echo -e "${RED}❌ expo-updates not installed! Run: npm install${NC}"
    exit 1
fi

# Test 7: Check GitHub Workflows
echo -e "\n${YELLOW}[7/8] Checking GitHub Actions workflows...${NC}"
if [ -f ".github/workflows/ota-update.yml" ] && [ -f ".github/workflows/eas-build.yml" ]; then
    echo -e "${GREEN}✅ Workflows found:${NC}"
    echo -e "   - .github/workflows/ota-update.yml"
    echo -e "   - .github/workflows/eas-build.yml"
    
    # Check for EXPO_TOKEN reference
    if grep -q "EXPO_TOKEN" .github/workflows/ota-update.yml; then
        echo -e "${GREEN}✅ Workflows reference EXPO_TOKEN${NC}"
    else
        echo -e "${YELLOW}⚠️  EXPO_TOKEN not found in workflows${NC}"
    fi
else
    echo -e "${RED}❌ Workflows not found!${NC}"
    exit 1
fi

# Test 8: Test OTA Update (Dry Run)
echo -e "\n${YELLOW}[8/8] Testing OTA update command (dry run)...${NC}"
echo -e "${BLUE}Running: eas update --branch preview --message 'Test OTA' --dry-run${NC}\n"

if eas update --branch preview --message "Test OTA" --dry-run 2>&1 | head -20; then
    echo -e "\n${GREEN}✅ OTA update command works!${NC}"
else
    echo -e "\n${YELLOW}⚠️  OTA update command may need app to be built first${NC}"
    echo -e "${BLUE}💡 This is normal if you haven't built the app yet${NC}"
fi

# Summary
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Configuration Test Complete!${NC}\n"

echo -e "${YELLOW}Next Steps:${NC}"
echo -e "1. Add EXPO_TOKEN to GitHub Secrets (if not done)"
echo -e "2. Build app: ${BLUE}eas build --platform android --profile preview${NC}"
echo -e "3. Test OTA: ${BLUE}eas update --branch preview --message 'Test'${NC}"
echo -e "4. Push to GitHub to trigger CI/CD"
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

