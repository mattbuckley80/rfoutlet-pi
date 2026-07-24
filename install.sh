#!/bin/bash
# RF Outlet Project — Install Script
# For Raspberry Pi 4/5 running Raspberry Pi OS Lite 64-bit (Bookworm)
# Based on original work by Tim Leland (https://timleland.com/wireless-power-outlets/)
# Pi 5 compatibility by Matthew Shankleys, assisted by Claude AI (claude.ai)

set -e  # Exit on any error

echo "======================================"
echo " RF Outlet Project Installer"
echo "======================================"
echo ""

# Check we're running as the correct user (not root)
if [ "$EUID" -eq 0 ]; then
    echo "Please run this script as a normal user (not root/sudo)."
    echo "The script will use sudo where needed."
    exit 1
fi

echo "[1/7] Updating system packages..."
sudo apt-get update && sudo apt-get upgrade -y

echo ""
echo "[2/7] Installing Apache and PHP..."
sudo apt-get install -y apache2 php libapache2-mod-php git build-essential
sudo service apache2 restart

echo ""
echo "[3/7] Installing Python RF libraries..."
sudo pip install rpi-rf rpi-lgpio --break-system-packages

echo ""
echo "[4/7] Installing WiringPi (required for RFSniffer)..."
cd ~
if [ ! -d "WiringPi" ]; then
    git clone https://github.com/WiringPi/WiringPi
fi
cd WiringPi
./build
cd ~

echo ""
echo "[5/7] Compiling RFSniffer from 433Utils..."
if [ ! -d "433Utils" ]; then
    git clone --recursive https://github.com/ninjablocks/433Utils
fi
cd 433Utils/RPi_utils
g++ -DRPI -o RFSniffer RFSniffer.cpp ../rc-switch/RCSwitch.cpp -lwiringPi -lwiringPiDev
cd ~

echo ""
echo "[6/7] Setting up web files..."
# Clone the original rfoutlet repo
sudo git clone https://github.com/timleland/rfoutlet.git /var/www/html/rfoutlet

# Copy our custom files over the defaults
sudo cp ~/rfoutlet-pi/web/index.html /var/www/html/rfoutlet/index.html
sudo cp ~/rfoutlet-pi/web/toggle.php /var/www/html/rfoutlet/toggle.php
sudo cp ~/rfoutlet-pi/web/codesend.py /var/www/html/rfoutlet/codesend.py

# Copy RFSniffer binary
sudo cp ~/433Utils/RPi_utils/RFSniffer /var/www/html/rfoutlet/RFSniffer

echo ""
echo "[7/7] Setting permissions..."
sudo chmod +x /var/www/html/rfoutlet/codesend.py
sudo chmod +x /var/www/html/rfoutlet/RFSniffer
sudo chown -R www-data:www-data /var/www/html/rfoutlet
sudo usermod -a -G gpio www-data

echo ""
echo "======================================"
echo " Installation Complete!"
echo "======================================"
echo ""
echo "Next steps:"
echo ""
echo "1. Wire up your RF modules:"
echo "   Transmitter (SYN115): VCC=3.3V, DATA=GPIO17"
echo "   Receiver   (SYN480R): VCC=3.3V, DATA=GPIO27"
echo ""
echo "2. Capture your outlet RF codes:"
echo "   sudo /var/www/html/rfoutlet/RFSniffer"
echo "   (Press buttons on your remote and note the codes)"
echo ""
echo "3. Enter your codes into toggle.php:"
echo "   sudo nano /var/www/html/rfoutlet/toggle.php"
echo ""
echo "4. Name your outlets in index.html:"
echo "   sudo nano /var/www/html/rfoutlet/index.html"
echo "   (Edit the 'outlets' array near the bottom of the file)"
echo ""
echo "5. Find your Pi's IP address:"
echo "   hostname -I"
echo ""
echo "6. Open a browser and go to:"
echo "   http://<your-pi-ip>/rfoutlet"
echo ""
echo "Reboot now to apply all permission changes:"
echo "   sudo reboot"
echo ""
