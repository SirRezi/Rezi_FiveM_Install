#!/bin/bash

# Farbdefinitionen
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Funktion zum Überprüfen und Aktualisieren des Skripts von GitHub
check_and_update_script() {
    echo -e "${YELLOW}Überprüfe auf Updates...${NC}"
    git fetch --all
    LATEST_COMMIT=$(git rev-parse origin/master)
    CURRENT_COMMIT=$(git rev-parse HEAD)

    if [[ "$LATEST_COMMIT" != "$CURRENT_COMMIT" ]]; then
        echo -e "${YELLOW}Eine neue Version des Skripts ist verfügbar.${NC}"
        read -p "Möchtest du das Skript jetzt aktualisieren? (ja/nein): " update_choice

        if [[ "$update_choice" == "ja" ]]; then
            echo -e "${YELLOW}Aktualisiere das Skript...${NC}"
            git reset --hard origin/master
            echo -e "${GREEN}Das Skript wurde erfolgreich aktualisiert. Starte das aktualisierte Skript neu.${NC}"
            exec bash "$0"
        fi
    fi
}

# Begrüßungsnachricht
echo -e "${YELLOW}=====================================================${NC}"
echo -e "${YELLOW}============ FiveM mit TxAdmin Installer ============${NC}"
echo -e "${YELLOW}=====================================================${NC}"
echo -e "${YELLOW}Dieses Skript wurde von SirRezi erstellt.${NC}"
echo

# Überprüfe und aktualisiere das Skript
if [[ -d .git ]]; then
    cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
    git remote set-url origin https://github.com/SirRezi/Rezi_FiveM_Install.git
    check_and_update_script
    cd - >/dev/null || exit 1
else
    echo -e "${YELLOW}Das Skript ist nicht als Git-Repository initialisiert. Kann keine Updates überprüfen.${NC}"
fi

# Meldung über das System von SirRezi und Abfrage zur Installation
read -p "Möchtest du die Installation von FiveM mit TxAdmin starten? (ja/nein): " choice

if [[ "$choice" != "ja" ]]; then
    echo -e "${GREEN}Installation abgebrochen.${NC}"
    exit 0
fi

# Pakete aktualisieren
echo -e "${YELLOW}Aktualisiere Paketliste...${NC}"
apt update
echo -e "${YELLOW}Führe Systemaktualisierung durch...${NC}"
apt upgrade -y

# Benötigte Pakete installieren
echo -e "${YELLOW}Installiere erforderliche Pakete...${NC}"
apt-get install -y xz-utils git screen

# FiveM-Server-Verzeichnis erstellen
echo -e "${YELLOW}Erstelle FiveM-Server-Verzeichnis...${NC}"
mkdir -p /home/FiveM/server
cd /home/FiveM/server

# FiveM-Server herunterladen und entpacken
echo -e "${YELLOW}Lade FiveM-Server herunter...${NC}"
wget https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/6537-f2c6ed5f64cc5a71ca0d9505f9b72bb015d370d6/fx.tar.xz
tar xf fx.tar.xz
ls
rm fx.tar.xz

# FiveM-Server-Daten-Verzeichnis erstellen und konfigurieren
echo -e "${YELLOW}Erstelle FiveM-Server-Daten-Verzeichnis und konfiguriere...${NC}"
mkdir -p /home/FiveM/server-data
cd /home/FiveM/server-data
git clone https://github.com/citizenfx/cfx-server-data.git /home/FiveM/server-data

# Erfolgsmeldung anzeigen
echo -e "${YELLOW}=====================================================${NC}"
echo -e "${YELLOW}============ Installation ist fertig ================${NC}"
echo -e "${YELLOW}=====================================================${NC}"
echo

exit 0
