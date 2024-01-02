#!/bin/bash

GREEN='\033[1;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

update_script() {
    echo -e "${YELLOW}Aktualisiere das Skript...${NC}"
    repo="SirRezi/Rezi_FiveM_Install"
    script="ReziInstall.sh"
    curl -sLO "https://raw.githubusercontent.com/$repo/main/$script"
    chmod +x $script
    echo -e "${YELLOW}Update erfolgreich durchgeführt.${NC}"
}

check_for_update() {
    clear || printf "\033c"
    echo -e "${BLUE}=====================================================${NC}"
    echo -e "${BLUE}============= FiveM mit TxAdmin Installer ===========${NC}"
    echo -e "${BLUE}=====================================================${NC}"
    echo -e "${GREEN}Dieses Skript wurde von SirRezi erstellt.${NC}"
    echo

    echo -e "${YELLOW}Überprüfe auf Updates...${NC}"
    repo="SirRezi/Rezi_FiveM_Install"
    script="ReziInstall.sh"
    local_version=$(<"$script" grep -m 1 'Version: ' | awk '{print $2}')
    latest_version=$(curl -s "https://api.github.com/repos/$repo/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    if [ "$local_version" != "$latest_version" ]; then
        echo -e "${YELLOW}Eine neue Version ist verfügbar.${NC}"
        read -p "Möchtest du das Update herunterladen? (ja/nein): " update_choice
        if [[ "$update_choice" == "ja" ]]; then
            update_script
        else
            echo -e "${YELLOW}Update abgebrochen.${NC}"
        fi
    else
        echo -e "${YELLOW}Das Skript ist auf dem neuesten Stand.${NC}"
        countdown 5
        clear || printf "\033c"
    fi
}

countdown() {
    secs=$1
    while [ $secs -gt 0 ]; do
        echo -ne "${YELLOW}Die Konsole wird in $secs Sekunden gelöscht.${NC}\033[0K\r"
        sleep 1
        : $((secs--))
    done
    echo -e "${YELLOW}Die Konsole wird gelöscht.${NC}"
}

run_installer() {
    clear || printf "\033c"
    echo -e "${BLUE}=====================================================${NC}"
    echo -e "${BLUE}============= FiveM mit TxAdmin Installer ===========${NC}"
    echo -e "${BLUE}=====================================================${NC}"
    echo -e "${GREEN}Dieses Skript wurde von SirRezi erstellt.${NC}"
    echo

    read -p "Möchtest du die Installation von FiveM mit TxAdmin starten? (ja/nein): " choice

    if [[ "$choice" != "ja" ]]; then
        echo -e "${GREEN}Installation abgebrochen.${NC}"
        exit 0
    fi

    echo -e "${YELLOW}Aktualisiere Paketliste und installiere benötigte Pakete...${NC}"
    apt update
    apt upgrade -y
    apt-get install -y xz-utils git screen

    echo -e "${YELLOW}Erstelle FiveM-Server-Verzeichnis und lade FiveM-Server herunter...${NC}"
    mkdir -p /home/FiveM/server
    cd /home/FiveM/server
    wget https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/7257-030778a167242f79e0f59cd8d9c04b970e3b75c2/fx.tar.xz
    tar xf fx.tar.xz
    rm fx.tar.xz

    echo -e "${YELLOW}Erstelle FiveM-Server-Daten-Verzeichnis und konfiguriere...${NC}"
    mkdir -p /home/FiveM/server-data
    cd /home/FiveM/server-data
    git clone https://github.com/citizenfx/cfx-server-data.git /home/FiveM/server-data

    echo -e "${BLUE}=====================================================${NC}"
    echo -e "${GREEN}============ Installation ist fertig ================${NC}"
    echo -e "${BLUE}=====================================================${NC}"
    echo
    countdown 5
    clear || printf "\033c"
}

# Löscht die Konsole sofort beim Starten des Skripts
clear || printf "\033c"

# Hier wird nur nach einem Update gesucht, wenn eine neue Version verfügbar ist
local_version=$(<"$script" grep -m 1 'Version: ' | awk '{print $2}')
latest_version=$(curl -s "https://api.github.com/repos/$repo/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
if [ "$local_version" != "$latest_version" ]; then
    check_for_update
else
    echo -e "${YELLOW}Das Skript ist auf dem neuesten Stand.${NC}"
    countdown 5
    clear || printf "\033c"
fi

run_installer
