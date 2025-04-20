#!/bin/bash

BOLD="\e[1m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NC="\e[0m"

SWARM_DIR="$HOME/rl-swarm"
TEMP_DATA_PATH="$SWARM_DIR/modal-login/temp-data"
HOME_DIR="$HOME"

cd "$HOME"

# Check if rl-swarm directory exists, create it if it doesn't
if [ ! -d "$SWARM_DIR" ]; then
    echo -e "${BOLD}${YELLOW}[✓] Creating rl-swarm directory...${NC}"
    mkdir -p "$SWARM_DIR"
fi

if [ -f "$SWARM_DIR/swarm.pem" ]; then
    echo -e "${BOLD}${YELLOW}You already have an existing ${GREEN}swarm.pem${YELLOW} file.${NC}\n"
    echo -e "${BOLD}${YELLOW}Auto-selecting option 1: Use existing swarm.pem...${NC}"

    mv "$SWARM_DIR/swarm.pem" "$HOME_DIR/"
    mv "$TEMP_DATA_PATH/userData.json" "$HOME_DIR/" 2>/dev/null
    mv "$TEMP_DATA_PATH/userApiKey.json" "$HOME_DIR/" 2>/dev/null

    rm -rf "$SWARM_DIR"

    echo -e "${BOLD}${YELLOW}[✓] Cloning fresh repository...${NC}"
    cd "$HOME" && git clone https://github.com/cloudservices-devops/gensyn-testnet.git > /dev/null 2>&1

    # Ensure the rl-swarm directory exists before moving files
    if [ ! -d "$SWARM_DIR" ]; then
        echo -e "${BOLD}${YELLOW}[✓] Creating rl-swarm directory inside the cloned repository...${NC}"
        mkdir -p "$SWARM_DIR"
    fi

    mv "$HOME_DIR/swarm.pem" "$SWARM_DIR/"
    mv "$HOME_DIR/userData.json" "$SWARM_DIR/modal-login/temp-data/" 2>/dev/null
    mv "$HOME_DIR/userApiKey.json" "$SWARM_DIR/modal-login/temp-data/" 2>/dev/null

else
    echo -e "${BOLD}${YELLOW}[✓] No existing swarm.pem found. Cloning repository...${NC}"
    cd "$HOME" && [ -d rl-swarm ] && rm -rf rl-swarm
    git clone https://github.com/cloudservices-devops/gensyn-testnet.git > /dev/null 2>&1
fi

cd rl-swarm || { echo -e "${BOLD}${RED}[✗] Failed to enter rl-swarm directory. Exiting.${NC}"; exit 1; }

if [ -n "$VIRTUAL_ENV" ]; then
    echo -e "${BOLD}${YELLOW}[✓] Deactivating existing virtual environment...${NC}"
    deactivate
fi

echo -e "${BOLD}${YELLOW}[✓] Setting up Python virtual environment...${NC}"
python3 -m venv .venv
source .venv/bin/activate

echo -e "${BOLD}${YELLOW}[✓] Running rl-swarm...${NC}"
./run_rl_swarm.sh
