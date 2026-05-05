#!/bin/bash
###############################################################################
# Script Name: airgeddon-evil-twin-setup.sh
# Description: Helper script to launch Airgeddon for Evil Twin Attack
# Author: Preeti Deepak Soni
# Purpose: Educational - Lab Environment Only
# Usage: sudo ./airgeddon-evil-twin-setup.sh
###############################################################################

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Print banner
echo -e "${BLUE}"
echo "============================================================"
echo "   Airgeddon Evil Twin Attack - Lab Setup Script"
echo "   Educational Purpose Only - Authorized Testing"
echo "============================================================"
echo -e "${NC}"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[!] This script must be run as root${NC}"
    echo "    Usage: sudo ./airgeddon-evil-twin-setup.sh"
    exit 1
fi

# Check for required tools
echo -e "${YELLOW}[*] Checking required tools...${NC}"

REQUIRED_TOOLS=("airmon-ng" "aircrack-ng" "ettercap" "dnsmasq" "hostapd" "iptables" "lighttpd")
MISSING_TOOLS=()

for tool in "${REQUIRED_TOOLS[@]}"; do
    if command -v $tool &> /dev/null; then
        echo -e "${GREEN}[+] $tool .... OK${NC}"
    else
        echo -e "${RED}[-] $tool .... MISSING${NC}"
        MISSING_TOOLS+=("$tool")
    fi
done

if [ ${#MISSING_TOOLS[@]} -ne 0 ]; then
    echo -e "${RED}[!] Missing tools detected. Install with:${NC}"
    echo "    sudo apt update && sudo apt install -y ${MISSING_TOOLS[@]}"
    exit 1
fi

# Check if Airgeddon is installed
if [ ! -f "./airgeddon.sh" ]; then
    echo -e "${YELLOW}[*] Airgeddon not found. Cloning repository...${NC}"
    git clone https://github.com/v1s1t0r1sh3r3/airgeddon.git
    cd airgeddon
else
    echo -e "${GREEN}[+] Airgeddon found${NC}"
fi

# Display wireless interfaces
echo -e "${YELLOW}[*] Available wireless interfaces:${NC}"
iw dev | awk '$1=="Interface"{print $2}'

# Verify monitor mode capability
echo -e "${YELLOW}[*] Checking monitor mode capability...${NC}"
for iface in $(iw dev | awk '$1=="Interface"{print $2}'); do
    if iw phy phy0 info | grep -q "monitor"; then
        echo -e "${GREEN}[+] $iface supports monitor mode${NC}"
    fi
done

# Launch Airgeddon
echo -e "${BLUE}"
echo "============================================================"
echo "   Launching Airgeddon..."
echo "============================================================"
echo "   Recommended workflow:"
echo "   1. Select wireless interface"
echo "   2. Put interface in monitor mode (option 2)"
echo "   3. Navigate to Evil Twin attacks menu (option 7)"
echo "   4. Select 'Evil Twin AP attack with captive portal'"
echo "   5. Configure target network"
echo "   6. Capture handshake (if not already obtained)"
echo "   7. Deploy captive portal and wait for credentials"
echo "============================================================"
echo -e "${NC}"

read -p "Press Enter to launch Airgeddon..."
sudo ./airgeddon.sh
