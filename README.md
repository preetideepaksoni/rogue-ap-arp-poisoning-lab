# Rogue AP & ARP Poisoning — Wi-Fi Credentials Capture Lab

## Project Overview

This project demonstrates an end-to-end **wireless network security assessment** combining two attack techniques: a **Rogue Access Point with Malicious Captive Portal** using Airgeddon, and **ARP Poisoning with credential capture** using Ettercap and the Social Engineering Toolkit (SET). The lab simulates how attackers can intercept Wi-Fi credentials and HTTP traffic in unauthorized network access scenarios, highlighting the importance of network segmentation, encrypted communications, and user awareness.

**Educational Purpose Only** — All testing was performed in a controlled lab environment with explicit authorization. This project demonstrates defensive cybersecurity knowledge by understanding offensive techniques.

---

## Objectives

- Deploy a Rogue Access Point (Evil Twin) with malicious captive portal
- Perform Wi-Fi network reconnaissance and target identification
- Capture WPA handshake for password recovery
- Execute ARP poisoning attack on a wireless network
- Capture credentials from unencrypted HTTP traffic
- Document defensive countermeasures for both attack vectors

---

## Tools & Technologies

### Wireless Attack Framework
- **Airgeddon** — Multi-purpose wireless security auditing tool
- **Aircrack-ng Suite** — Wireless network security tools
- **MDK4** — Wireless security testing tool

### Network Attack Tools
- **Ettercap** — Comprehensive man-in-the-middle attack suite
- **Social Engineering Toolkit (SET)** — Penetration testing framework

### Supporting Services
- **hostapd** / **hostapd-wpe** — Access point configuration
- **dnsmasq** — DHCP/DNS services
- **bettercap** — Network attack framework
- **dhcpd** — DHCP daemon
- **lighttpd** — Web server for captive portal

### Operating System
- **Ubuntu Linux** — Lab environment
- **Wireless Adapter** — wlp5s0 (MEDIATEK Corp. MT7921K) supporting monitor mode

---

## Methodology

### Part 1: Rogue AP with Captive Portal (Airgeddon)

#### Phase 1: Tool Initialization & Verification

```bash
sudo ./airgeddon.sh
```

**Result:**
- Airgeddon v11.50 launched successfully
- Root permissions verified
- Bash version 5.2.21 detected
- Compatible distribution detected (Ubuntu Linux)
- Essential tools verification completed (iw, awk, airmon-ng, airodump-ng, aircrack-ng, xterm, ip, lspci, ps)
- Optional tools verified (bettercap, ettercap, dnsmasq, hostapd, dhcpd, hashcat, wpaclean)

---

#### Phase 2: Wireless Interface Selection

**Interface Selected:**
- **Interface:** wlp5s0
- **Chipset:** MEDIATEK Corp. MT7921K
- **Bands:** 2.4GHz, 5GHz
- **Mode:** Managed → Monitor

```
Selected interface: wlp5s0
Mode: Managed → Monitor
Supported bands: 2.4GHz, 5GHz
```

---

#### Phase 3: Network Reconnaissance

Selected option to **scan for nearby Wi-Fi networks** in monitor mode.

**Scan filters applied:**
- WPA/WPA2/WPA3 networks
- All available channels
- Networks with active clients (marked with *)

**Target Network Identified:**
- **BSSID:** C4:AD:64:FB:92:CE:66:31
- **Channel:** 36 (5GHz)
- **Encryption:** WPA2
- **ESSID:** Excitel_5G_166924376
- **Status:** Network with active clients

---

#### Phase 4: Evil Twin Attack with Captive Portal

Selected attack option:
> **"Evil Twin AP attack with captive portal (monitor mode needed)"**

**Configuration:**
```
Interface: wlp5s0mon
Mode: Monitor
Selected BSSID: C4:AD:64:FB:92:CE:66:31
Channel: 36
ESSID: Excitel_5G_166924376
Deauthentication method: Aireplay
MAC spoofing: Enabled
```

**Captive Portal Languages Available:**
English, Spanish, French, Catalan, Portuguese, Russian, Greek, Italian, Polish, German, Turkish, Arabic, Chinese

---

#### Phase 5: WPA Handshake Capture

The attack required a **previously captured WPA/WPA2 handshake file** to validate the captured password.

```bash
# Handshake file path
/root/handshake-64:FB:92:CE:66:31.cap
```

**Verification:**
> "It has been verified that capture file contains Handshake/PMKID of target network. Script can continue..."

**Output File Path:**
```
/root/evil_twin_captive_portal_password-Excitel_5G_166924376.txt
```

---

#### Phase 6: Captive Portal Deployment

The Evil Twin attack:
1. Created a clone of the target network (Excitel_5G_166924376)
2. Deauthenticated victims from the legitimate AP
3. Forced victims to connect to the rogue AP
4. Served a fake Wi-Fi login page on **192.168.1.1**
5. Captured WPA password through the captive portal
6. Validated the captured password against the legitimate handshake

**Captive Portal Page:**
- Title: "Free WiFi Login"
- Fields: Username, Password
- Hosted on: http://192.168.1.1

---

### Part 2: ARP Poisoning & Credential Capture (Ettercap + SET)

#### Phase 7: Network Configuration Verification

```bash
# Check network interfaces and IP addresses
ip a
```

**Verified Configuration:**
- Interface: wlp5s0
- IP: 192.168.1.1/24
- MAC: 64:fb:92:c4:66:31
- Status: BROADCAST, MULTICAST, UP, LOWER_UP

---

#### Phase 8: ARP Poisoning with Ettercap

```bash
# Launch Ettercap in text mode with sniffing
sudo ettercap -T -q -i wlp5s0
```

**Ettercap Output:**
```
ettercap 0.8.3.1 - Ettercap Development Team

Listening on:
wlp5s0 -> 64:FB:92:C4:66:31
        192.168.1.1/255.255.255.0
        fe80::66fb:92ff:fec4:6631/64

34 plugins
42 protocol dissectors
```

**Attack Capabilities Active:**
- Network packet sniffing
- ARP poisoning
- HTTP/HTTPS dissection
- Plain-text credential extraction

---

#### Phase 9: Credential Capture

Victim connected to the rogue AP and entered credentials on the fake captive portal at **http://192.168.1.1**.

**Captured Credentials (Lab Test Data):**
```
HTTP : 192.168.1.1:80 -> USER: 8006461030  PASS: Hello@123
INFO: http://192.168.1.1/
CONTENT: username=8006461030&password=Hello%40123
```

**Important Note:** Credentials were transmitted in **plaintext over HTTP**, demonstrating the criticality of HTTPS in modern web applications.

---

## Vulnerabilities Demonstrated

| Vulnerability | Severity | Description |
|--------------|----------|-------------|
| **Evil Twin Vulnerability** | High | Wi-Fi clients connect to SSID-matching rogue APs without certificate validation |
| **Lack of Mutual Authentication** | High | WPA2-PSK does not authenticate the AP to the client |
| **HTTP Plaintext Credentials** | Critical | Login credentials transmitted unencrypted via HTTP |
| **ARP Spoofing Susceptibility** | High | Network lacks ARP inspection or dynamic ARP protection |
| **Captive Portal Phishing** | High | Users trust fake login pages mimicking legitimate networks |
| **Insufficient User Awareness** | Medium | Users connect to networks based solely on SSID name |
| **Weak DNS Security** | Medium | Rogue DNS servers can hijack name resolution |

---

## Skills Demonstrated

### Wireless Security
- Wi-Fi network reconnaissance and target identification
- Monitor mode operation on wireless interfaces
- WPA/WPA2 handshake capture and verification
- Rogue Access Point deployment
- Evil Twin Attack methodology
- Deauthentication attacks

### Network Security
- ARP poisoning techniques
- Man-in-the-Middle (MitM) attack execution
- Network packet sniffing and analysis
- HTTP traffic interception
- Credential harvesting

### Tool Proficiency
- Airgeddon framework configuration and operation
- Ettercap multi-mode attack execution
- Aircrack-ng suite usage
- Linux network stack manipulation
- Wireless adapter configuration

### Documentation
- Professional security assessment reporting
- Attack methodology documentation
- Mitigation recommendations
- Risk severity assessment

---

## Defensive Recommendations

Based on this assessment, the following mitigations are recommended:

### For Network Administrators

1. **Deploy WPA3-Enterprise**
   - Provides Simultaneous Authentication of Equals (SAE)
   - Prevents offline dictionary attacks
   - Forward secrecy for all sessions

2. **Implement 802.1X Authentication**
   - Certificate-based mutual authentication
   - RADIUS server for user authentication
   - Eliminates pre-shared key vulnerabilities

3. **Enable Wireless Intrusion Prevention (WIPS)**
   - Aruba RFProtect, Cisco wIPS, or Mojo Networks
   - Detect and contain rogue access points
   - Real-time alerting on anomalies

4. **Configure Dynamic ARP Inspection (DAI)**
   - Validates ARP packets on the network
   - Prevents ARP spoofing attacks
   - Pairs with DHCP snooping for binding table

5. **Force HTTPS Everywhere**
   - HSTS (HTTP Strict Transport Security)
   - Redirect all HTTP to HTTPS
   - Use TLS 1.2 or higher
   - Implement certificate pinning

6. **Network Segmentation**
   - Separate guest and corporate networks
   - VLAN isolation
   - Limit lateral movement potential

### For End Users

1. **Verify Network Authenticity**
   - Confirm with IT/staff before connecting to public Wi-Fi
   - Check for duplicate SSIDs
   - Be suspicious of "Free WiFi" networks

2. **Use VPN for All Connections**
   - Encrypt traffic at the network layer
   - Protects against MitM attacks
   - Hides traffic from network observers

3. **Enable HTTPS-Only Mode**
   - Browser settings to enforce HTTPS
   - Prevent fallback to plaintext HTTP
   - Visible warnings for non-secure sites

4. **Avoid Auto-Connect Features**
   - Manually verify networks before connecting
   - Disable "Connect automatically" for public networks
   - Forget unused networks

5. **Use Strong, Unique Passwords**
   - Different password for each service
   - Password manager for secure storage
   - Multi-factor authentication everywhere

### For Organizations

1. **Conduct Regular Wireless Audits**
   - Quarterly scans for rogue APs
   - Assess WPA strength
   - Document and remediate findings

2. **Mandatory User Awareness Training**
   - Wi-Fi security best practices
   - Phishing recognition (including captive portals)
   - Incident reporting procedures

3. **Network Access Control (NAC)**
   - Device compliance verification
   - Posture assessment before granting access
   - Quarantine non-compliant devices

4. **Endpoint Detection & Response (EDR)**
   - Detect connection to suspicious networks
   - Alert on unusual traffic patterns
   - Block known malicious infrastructure

5. **Implement Zero Trust Architecture**
   - Never trust, always verify
   - Continuous authentication
   - Least privilege access

---

## References & Standards

- **NIST SP 800-153** — Guidelines for Securing Wireless Local Area Networks
- **NIST SP 800-97** — Establishing Wireless Robust Security Networks
- **NIST SP 800-115** — Technical Guide to Information Security Testing and Assessment
- **OWASP Wireless Security Testing Guide**
- **PCI DSS Wireless Requirements** (Section 11.1)
- **IEEE 802.11i Security Standard** (WPA2)
- **IEEE 802.11-2020** (WPA3)
- **MITRE ATT&CK Techniques:** T1557 (Adversary-in-the-Middle), T1189 (Drive-by Compromise)

---

## Disclaimer

This project was conducted for **educational and ethical purposes only** in a controlled lab environment with proper authorization. Unauthorized access to wireless networks is illegal under:

- **Spain:** Ley Orgánica 10/1995 (Penal Code), Articles 197-201
- **EU:** GDPR (Regulation 2016/679) and NIS2 Directive
- **International:** Computer Fraud and Abuse Act (CFAA), Convention on Cybercrime (Budapest Convention)

Always obtain **written permission** before conducting security assessments on any network or system.

---

## Author

**Preeti Deepak Soni**  
Cybersecurity Professional | Penetration Testing | Wireless Security  
- Email: preetisoni.d@gmail.com  
- LinkedIn: [linkedin.com/in/preeti-deepak-soni-6990bb272](https://www.linkedin.com/in/preeti-deepak-soni-6990bb272)  
- Location: Málaga, Spain

---

*This project was completed as part of my Ethical Hacking Professional Certificate at MasterD (Sobresaliente, 9.06/10) and demonstrates practical wireless security assessment skills.*
