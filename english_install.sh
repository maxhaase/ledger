#!/bin/bash

# ================================
# Installation of Ledger Live on Linux
# ================================
# This script automates the download, installation, and configuration
# of the Ledger Live application on a Linux system.
# =====================================

# 1. Download the latest version of Ledger Live
# ============================================
echo "Downloading Ledger Live..."
wget -O ledger-live-latest.AppImage https://download.live.ledger.com/latest/linux

# 2. Make the AppImage executable
# ===============================================
echo "Making the AppImage executable..."
chmod +x ledger-live-latest.AppImage

# 3. Configure USB access rules for Ledger devices
# ============================================================
echo "Configuring USB access rules for Ledger..."
sudo tee /etc/udev/rules.d/20-hw1.rules > /dev/null <<EOF
# HW.1, Nano
SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1b7c|2b7c|3b7c|4b7c", TAG+="uaccess", TAG+="udev-acl"

# Blue, NanoS, Aramis, HW.2, Nano X, NanoSP, Stax, Ledger Test
SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", TAG+="uaccess", TAG+="udev-acl"

# Access to hidraw for the hidraw-based library instead of libusb
KERNEL=="hidraw*", ATTRS{idVendor}=="2c97", MODE="0660", GROUP="plugdev"
EOF

# Reload udev rules to apply changes
sudo udevadm control --reload-rules
sudo udevadm trigger

# 4. Rename the AppImage
# =========================
echo "Renaming the AppImage..."
mv ledger-live-latest.AppImage ledger-live.AppImage

# 5. Download the Ledger Live icon
# ====================================
echo "Downloading the Ledger Live icon..."
wget -P ~/.local/share/icons/ https://raw.githubusercontent.com/maxhaase/ledger/refs/heads/main/ledger.png

# 6. Create a desktop shortcut
# ===========================================
echo "Creating a desktop shortcut..."
mkdir -p ~/.local/share/applications
cat <<EOF > ~/.local/share/applications/ledger-live.desktop
[Desktop Entry]
Type=Application
Name=Ledger Live
Comment=Ledger Live
Icon=$HOME/.local/share/icons/ledger.png
Exec=$HOME/ledger-live.AppImage --no-sandbox
Terminal=false
Categories=crypto;wallet;
EOF

# 7. Completion
# ===============
echo "Installation complete. You can run Ledger Live from the application menu or by executing ./ledger-live.AppImage"
