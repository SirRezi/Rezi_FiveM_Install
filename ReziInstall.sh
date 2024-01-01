#!/bin/bash

# Farbdefinitionen
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # Keine Farbe

# Begrüßungsnachricht
echo -e "${YELLOW}=====================================================${NC}"
echo -e "${YELLOW}============ FiveM mit TxAdmin Installer ============${NC}"
echo -e "${YELLOW}=====================================================${NC}"
echo -e "${YELLOW}Dieses Skript wurde von SirRezi erstellt.${NC}"
echo

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
wget https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/7257-030778a167242f79e0f59cd8d9c04b970e3b75c2/fx.tar.xz
tar xf fx.tar.xz
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
