#!/bin/bash

# Detect if running on Termux or Debian
if [ -d "/data/data/com.termux" ]; then
    OS="termux"
    PKG_MANAGER="pkg"
else
    OS="debian"
    PKG_MANAGER="apt"
fi

# Function to install packages
install_packages() {
    if [ "$OS" = "termux" ]; then
        # Termux-specific package installation
        $PKG_MANAGER update
        $PKG_MANAGER install -y root-repo
        $PKG_MANAGER install -y git tsu python wpa-supplicant pixiewps iw
    else
        # Debian-specific package installation
        $PKG_MANAGER update
        $PKG_MANAGER install -y git sudo python3 wpasupplicant pixiewps iw
    fi
}

# Function to determine Python command
get_python_cmd() {
    if [ "$OS" = "termux" ]; then
        echo "python"
    else
        echo "python3"
    fi
}

# Install required packages
install_packages

# Clone the OneShot repository
git clone --depth 1 https://github.com/Burhanverse/OneShot OneShot

# Set executable permissions
chmod +x OneShot/oneshot.py

# Get the appropriate Python command
PYTHON_CMD=$(get_python_cmd)

# Print usage instructions
printf "###############################################\n"
printf "#  All done! Now you can run OneShot with:\n"
if [ "$OS" = "termux" ]; then
    printf "#   tsu -c \"$PYTHON_CMD OneShot/oneshot.py -i wlan0 -K\"\n"
else
    printf "#   sudo $PYTHON_CMD OneShot/oneshot.py -i wlan0 -K\n"
fi
printf "#\n"
printf "#  To update, run:\n"
printf "#   (cd OneShot && git pull)\n"
printf "###############################################\n"
