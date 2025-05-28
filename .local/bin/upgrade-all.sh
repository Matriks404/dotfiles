#!/usr/bin/env bash

# Getting operating system name
OS_NAME=$(uname -s)

if [ "$EUID" -ne 0 ]; then
    echo -e "ERROR: This script must be run with root privileges!"

    exit 1
fi

echo -e "=== Doing a system upgrade... ==="

if [ -f /etc/debian_version ]; then
    upgrade-system
elif [ "$OS_NAME" == "OpenBSD" ]; then
    pkg_add -u
fi

echo -e "=== System upgrade complete! ==="

if [ $(command -v flatpak)  ]; then
    echo -e "\n=== Updating flatpak applicaitons... ==="
    flatpak update
    echo -e "=== Flatpak applications update complete! ==="
fi
