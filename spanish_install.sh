#!/bin/bash

# ================================
# Instalación de Ledger Live en Linux
# ================================
# Este script automatiza la descarga, instalación y configuración
# de la aplicación Ledger Live en un sistema Linux.
# =====================================

# 1. Descarga la última versión de Ledger Live
# ============================================
echo "Descargando Ledger Live..."
wget -O ledger-live-latest.AppImage https://download.live.ledger.com/latest/linux

# 2. Asignar permisos de ejecución a la AppImage
# ===============================================
echo "Haciendo ejecutable la AppImage..."
chmod +x ledger-live-latest.AppImage

# 3. Configurar reglas de acceso USB para dispositivos Ledger
# ============================================================
echo "Configurando reglas de acceso USB para Ledger..."
sudo tee /etc/udev/rules.d/20-hw1.rules > /dev/null <<EOF
# HW.1, Nano
SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1b7c|2b7c|3b7c|4b7c", TAG+="uaccess", TAG+="udev-acl"

# Blue, NanoS, Aramis, HW.2, Nano X, NanoSP, Stax, Ledger Test
SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", TAG+="uaccess", TAG+="udev-acl"

# Acceso a hidraw para la biblioteca basada en hidraw en lugar de libusb
KERNEL=="hidraw*", ATTRS{idVendor}=="2c97", MODE="0660", GROUP="plugdev"
EOF

# Recargar reglas de udev para aplicar los cambios
sudo udevadm control --reload-rules
sudo udevadm trigger

# 4. Renombrar la AppImage
# =========================
echo "Renombrando la AppImage..."
mv ledger-live-latest.AppImage ledger-live.AppImage

# 5. Descargar el icono de Ledger Live
# ====================================
echo "Descargando el icono de Ledger Live..."
wget -P ~/.local/share/icons/ https://github.com/maxhaase/ledger/icon.png

# 6. Crear un acceso directo en el escritorio
# ===========================================
echo "Creando acceso directo en el escritorio..."
mkdir -p ~/.local/share/applications
cat <<EOF > ~/.local/share/applications/ledger-live.desktop
[Desktop Entry]
Type=Application
Name=Ledger Live
Comment=Ledger Live
Icon=$HOME/.local/share/icons/ledger-live-icon.png
Exec=$HOME/ledger-live.AppImage --no-sandbox
Terminal=false
Categories=crypto;wallet;
EOF

# 7. Finalización
# ===============
echo "Instalación completada. Puedes ejecutar Ledger Live desde el menú de aplicaciones o ejecutando ./ledger-live.AppImage"
