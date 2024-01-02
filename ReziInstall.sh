#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

update_script() {
    echo -e "${YELLOW}Aktualisiere das Skript...${NC}"
    repo="SirRezi/Rezi_FiveM_Install"
    script="ReziInstall.sh"
    curl -sLO "https://raw.githubusercontent.com/$repo/main/$script"
    chmod +x $script
    ./$script
    exit 0
}

check_for_update() {
    echo -e "${YELLOW}Überprüfe auf Updates...${NC}"
    repo="SirRezi/Rezi_FiveM_Install"
    script="ReziInstall.sh"
    local_version=$(<$script grep -m 1 'Version: ' | awk '{print $2}')
    latest_version=$(curl -s "https://api.github.com/repos/$repo/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    if [ "$local_version" != "$latest_version" ]; then
        read -p "Es ist eine neue Version verfügbar. Möchtest du das Update durchführen? (ja/nein): " update_choice
        if [[ "$update_choice" == "ja" ]]; then
            echo -e "${YELLOW}Eine neue Version wird installiert.${NC}"
            sleep 3
            update_script
        else
            echo -e "${YELLOW}Du hast das Update abgelehnt. Das Skript ist auf dem neuesten Stand.${NC}"
        fi
    else
        echo -e "${YELLOW}Das Skript ist auf dem neuesten Stand.${NC}"
    fi
}

check_for_update
