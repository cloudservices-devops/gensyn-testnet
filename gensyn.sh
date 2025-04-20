#!/bin/bash

BOLD="\e[1m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NC="\e[0m"

SWARM_DIR="$HOME/rl-swarm"
TEMP_DATA_PATH="$SWARM_DIR/modal-login/temp-data"
HOME_DIR="$HOME"

cd $HOME

if [ -f "$SWARM_DIR/swarm.pem" ]; then
    if [ "$SWARM_CHOICE" == "1" ]; then
        echo -e "${BOLD}${YELLOW}[✓] Using existing swarm.pem...${NC}"
        mv "$SWARM_DIR/swarm.pem" "$HOME_DIR/"
        mv "$TEMP_DATA_PATH/userData.json" "$HOME_DIR/" 2>/dev/null
        mv "$TEMP_DATA_PATH/userApiKey.json" "$HOME_DIR/" 2>/dev/null

        rm -rf "$SWARM_DIR"

        echo -e "${BOLD}${YELLOW}[✓] Cloning fresh repository...${NC}"
        cd $HOME && git clone https://github.com/zunxbt/rl-swarm.git > /dev/null 2>&1

        mv "$HOME_DIR/swarm.pem" rl-swarm/
        mv "$HOME_DIR/userData.json" rl-swarm/modal-login/temp-data/ 2>/dev/null
        mv "$HOME_DIR/userApiKey.json" rl-swarm/modal-login/temp-data/ 2>/dev/null
    elif [ "$SWARM_CHOICE" == "2" ]; then
        echo -e "${BOLD}${YELLOW}[✓] Removing existing folder and starting fresh...${NC}"
        rm -rf "$SWARM_DIR"
        cd $HOME && git clone https://github.com/zunxbt/rl-swarm.git > /dev/null 2>&1
    else
        echo -e "${BOLD}${RED}[✗] Invalid SWARM_CHOICE: $SWARM_CHOICE. Exiting.${NC}"
        exit 1
    fi
else
    echo -e "${BOLD}${YELLOW}[✓] No existing swarm.pem found. Cloning repository...${NC}"
    cd $HOME && [ -d rl-swarm ] && rm -rf rl-swarm; git clone https://github.com/zunxbt/rl-swarm.git > /dev/null 2>&1
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
