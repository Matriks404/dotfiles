#!/usr/bin/env bash

if [ $(command -v flatpak) ]; then
    echo -e "=== Updating flatpak applicaitons... ==="
    flatpak update
    echo -e "=== Flatpak applications update complete! ==="
fi
