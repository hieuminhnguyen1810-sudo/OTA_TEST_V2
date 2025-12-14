#!/bin/bash

# OTA Update Helper Script
# Giúp deploy và verify OTA updates dễ dàng hơn

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Change to project root (ota-v2 directory)
cd "$(dirname "$0")/.."

echo -e "${BLUE}🚀 OTA Update Helper${NC}\n"

# Function to show menu
show_menu() {
    echo "Chọn action:"
    echo "1) Deploy update to DEVELOPMENT"
    echo "2) Deploy update to PREVIEW"
    echo "3) Deploy update to PRODUCTION"
    echo "4) List all updates"
    echo "5) List channels"
    echo "6) View latest update on channel"
    echo "7) Rollback update"
    echo "8) Check current configuration"
    echo "9) Exit"
    echo ""
}

# Function to deploy update
deploy_update() {
    local channel=$1
    echo -e "${YELLOW}📝 Nhập message cho update:${NC}"
    read -r message
    
    if [ -z "$message" ]; then
        message="Update to $channel channel"
    fi
    
    echo -e "${BLUE}Deploying to $channel channel...${NC}"
    eas update --branch "$channel" --message "$message"
    
    echo -e "${GREEN}✅ Update deployed successfully!${NC}"
    echo -e "${BLUE}💡 Nhớ force quit và reopen app để nhận update${NC}\n"
}

# Function to list updates
list_updates() {
    local channel=$1
    if [ -z "$channel" ]; then
        echo -e "${YELLOW}Nhập channel name (hoặc Enter để xem tất cả):${NC}"
        read -r channel
    fi
    
    if [ -z "$channel" ]; then
        echo -e "${BLUE}Listing all updates...${NC}"
        eas update:list
    else
        echo -e "${BLUE}Listing updates for channel: $channel${NC}"
        eas update:list --branch "$channel"
    fi
}

# Function to list channels
list_channels() {
    echo -e "${BLUE}Listing all channels...${NC}"
    eas channel:list
}

# Function to view latest update
view_latest_update() {
    echo -e "${YELLOW}Nhập channel name:${NC}"
    read -r channel
    
    if [ -z "$channel" ]; then
        echo -e "${RED}Channel name is required!${NC}"
        return
    fi
    
    echo -e "${BLUE}Fetching latest update for $channel...${NC}"
    eas update:list --branch "$channel" | head -n 20
}

# Function to rollback
rollback_update() {
    echo -e "${YELLOW}⚠️  ROLLBACK UPDATE${NC}\n"
    echo "Nhập channel name:"
    read -r channel
    
    if [ -z "$channel" ]; then
        echo -e "${RED}Channel name is required!${NC}"
        return
    fi
    
    echo -e "${BLUE}Recent updates on $channel:${NC}"
    eas update:list --branch "$channel" | head -n 10
    
    echo -e "\n${YELLOW}Nhập Update Group ID để rollback về:${NC}"
    read -r group_id
    
    if [ -z "$group_id" ]; then
        echo -e "${RED}Update Group ID is required!${NC}"
        return
    fi
    
    echo -e "${YELLOW}Confirm rollback? (yes/no)${NC}"
    read -r confirm
    
    if [ "$confirm" = "yes" ]; then
        eas update:republish --group "$group_id"
        echo -e "${GREEN}✅ Rollback completed!${NC}"
    else
        echo -e "${RED}Rollback cancelled${NC}"
    fi
}

# Function to check configuration
check_config() {
    echo -e "${BLUE}📋 Checking configuration...${NC}\n"
    
    # Check eas.json
    if [ -f "eas.json" ]; then
        echo -e "${GREEN}✅ eas.json found${NC}"
    else
        echo -e "${RED}❌ eas.json not found!${NC}"
    fi
    
    # Check app.json
    if [ -f "app.json" ]; then
        echo -e "${GREEN}✅ app.json found${NC}"
        
        # Extract project ID
        project_id=$(grep -o '"projectId": "[^"]*"' app.json | cut -d'"' -f4)
        if [ -n "$project_id" ]; then
            echo -e "${GREEN}   Project ID: $project_id${NC}"
        else
            echo -e "${YELLOW}   ⚠️  Project ID not found${NC}"
        fi
        
        # Extract runtime version
        runtime=$(grep -A1 '"runtimeVersion"' app.json | grep '"policy"' | cut -d'"' -f4)
        if [ -n "$runtime" ]; then
            echo -e "${GREEN}   Runtime Version Policy: $runtime${NC}"
        fi
    else
        echo -e "${RED}❌ app.json not found!${NC}"
    fi
    
    # Check expo-updates
    if grep -q '"expo-updates"' package.json; then
        echo -e "${GREEN}✅ expo-updates installed${NC}"
        version=$(grep '"expo-updates"' package.json | cut -d'"' -f4)
        echo -e "   Version: $version"
    else
        echo -e "${RED}❌ expo-updates not installed!${NC}"
    fi
    
    # Check EAS CLI
    if command -v eas &> /dev/null; then
        echo -e "${GREEN}✅ EAS CLI installed${NC}"
        eas whoami
    else
        echo -e "${RED}❌ EAS CLI not installed!${NC}"
        echo -e "${YELLOW}   Install: npm install -g eas-cli${NC}"
    fi
    
    echo ""
}

# Main loop
while true; do
    show_menu
    read -r choice
    
    case $choice in
        1)
            deploy_update "development"
            ;;
        2)
            deploy_update "preview"
            ;;
        3)
            echo -e "${YELLOW}⚠️  Deploying to PRODUCTION! Are you sure? (yes/no)${NC}"
            read -r confirm
            if [ "$confirm" = "yes" ]; then
                deploy_update "production"
            else
                echo -e "${RED}Cancelled${NC}\n"
            fi
            ;;
        4)
            list_updates
            echo ""
            ;;
        5)
            list_channels
            echo ""
            ;;
        6)
            view_latest_update
            echo ""
            ;;
        7)
            rollback_update
            echo ""
            ;;
        8)
            check_config
            ;;
        9)
            echo -e "${GREEN}Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice!${NC}\n"
            ;;
    esac
done

