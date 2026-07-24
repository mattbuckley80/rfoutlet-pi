# RF Outlet Controller for Raspberry Pi 4/5

A web-based RF wireless outlet controller with a dark-mode touch-friendly UI, designed for wall-mounted Raspberry Pi touchscreen installations.

Based on the original work by **Tim Leland** (https://timleland.com/wireless-power-outlets/) and **ninjablocks/433Utils** (https://github.com/ninjablocks/433Utils).

Pi 4/5 compatibility troubleshooting assisted by **Claude AI** (https://claude.ai).

---

## Features
- Dark mode touch-friendly UI optimized for 5" portrait displays (720×1280)
- Controls up to 5 individual RF outlets plus an "All On/All Off" button
- Works with standard 433MHz RF outlets
- Compatible with Raspberry Pi 4 and Pi 5
- Runs as a local web server — no internet connection required

---

## Hardware Requirements
- Raspberry Pi 4 or Pi 5 (1GB RAM minimum)
- 8GB+ SD card
- SYN115 433MHz RF transmitter module
- SYN480R 433MHz RF receiver module (for capturing codes)
- 433MHz RF wireless outlets (e.g. Etekcity, BN-LINK)
- Optional: Raspberry Pi 5" touch display for wall-mounted installation

---

## Wiring
See [docs/wiring.md](docs/wiring.md) for full wiring diagram and GPIO reference.

**Quick reference:**
| Module | VCC | DATA |
|--------|-----|------|
| Transmitter (SYN115) | **3.3V** | GPIO17 |
| Receiver (SYN480R) | **3.3V** | GPIO27 |

> ⚠️ Both modules must be powered from **3.3V**, not 5V.

---

## Installation

### 1. Flash SD Card
Flash **Raspberry Pi OS Lite 64-bit (Bookworm)** using Raspberry Pi Imager.
In Imager settings, configure:
- Hostname (e.g. `rfoutlet`)
- Enable SSH
- WiFi credentials
- Username and password

### 2. Clone This Repository
SSH into your Pi and clone this repo:
```bash
git clone https://github.com/mattbuckley80/rfoutlet-pi.git ~/rfoutlet-pi
```

### 3. Run the Installer
```bash
cd ~/rfoutlet-pi
chmod +x install.sh
./install.sh
```

The installer will:
- Update the system
- Install Apache and PHP
- Install Python RF libraries (rpi-rf, rpi-lgpio)
- Install WiringPi
- Compile RFSniffer
- Set up web files and permissions

### 4. Capture Your Outlet RF Codes
Wire up your receiver (see wiring.md), then run:
```bash
sudo /var/www/html/rfoutlet/RFSniffer
```
Press the On and Off buttons on your remote for each outlet and note the codes and pulse length.

### 5. Enter Your Codes
```bash
sudo nano /var/www/html/rfoutlet/toggle.php
```
Update the `$codes` array with your captured codes, and set `$codeSendPulseLength` to match your remote's pulse length.

### 6. Name Your Outlets
```bash
sudo nano /var/www/html/rfoutlet/index.html
```
Find the `outlets` array near the bottom of the file and update the `name` field for each outlet:
```javascript
const outlets = [
  { id: '1', name: 'Living Room Lamp' },
  { id: '2', name: 'Kitchen Counter' },
  ...
];
```

### 7. Reboot and Test
```bash
sudo reboot
```
Then open a browser and go to:
```
http://<your-pi-ip>/rfoutlet
```

---

## Kiosk Mode (Wall-Mounted Touch Display)
To run the UI fullscreen on boot, create a desktop shortcut:
```bash
nano ~/Desktop/RFOutlets.desktop
```
Add:
```ini
[Desktop Entry]
Version=1.0
Type=Application
Name=RF Outlets
Exec=chromium --kiosk --app=http://localhost/rfoutlet
Icon=chromium
Terminal=false
Categories=Utility;
```
Make it executable:
```bash
chmod +x ~/Desktop/RFOutlets.desktop
```

---

## Pi 5 Compatibility Notes
The original `codesend` binary from 433Utils uses WiringPi for GPIO timing, which has issues on the Pi 5 (and some Pi 4 configurations). This project replaces `codesend` with a Python script (`codesend.py`) using the `rpi-rf` and `rpi-lgpio` libraries, which are fully compatible with Pi 4 and Pi 5.

---

## Credits
- Original rfoutlet project: **Tim Leland** — https://timleland.com/wireless-power-outlets/
- 433Utils / RFSniffer: **ninjablocks** — https://github.com/ninjablocks/433Utils
- rc-switch library: **sui77** — https://github.com/sui77/rc-switch
- rpi-rf Python library: https://github.com/milaq/rpi-rf
- WiringPi (maintained fork): https://github.com/WiringPi/WiringPi

---

## License
This project builds on MIT licensed code. Please retain credits to original authors.
