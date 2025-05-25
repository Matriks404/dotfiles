#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
    echo -e "ERROR: This script must be run with root privileges!"

    exit 1
fi

echo -e "=== Doing a system upgrade... ==="
sudo upgrade-system
echo -e "=== System upgrade complete! ==="

if [ -x /usr/bin/flatpak ]; then
    echo -e "\n=== Updating flatpak applicaitons... ==="
    flatpak update
    echo -e "=== Flatpak applications update complete! ==="
fi
