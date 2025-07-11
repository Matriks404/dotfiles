#!/usr/bin/env bash

# Getting operating system name
OS_NAME=$(uname -s)

if [ "$EUID" -ne 0 ]; then
    echo -e "ERROR: This script must be run with root privileges!"

    exit 1
fi


if [ "$EUID" -eq 0 ]; then
    echo -e "=== Updating packages... ==="

    if [ -f /etc/debian_version ]; then
        if [ $(command -v upgrade-system) ]; then
            upgrade-system
        else
            echo -e "    === Updating APT package list... ==="
            apt update

            echo -e "    === Upgrading your system... ==="
            apt dist-upgrade

            echo -e "    === Cleaning up stuff... ==="
            apt clean
        fi
    elif [ "$OS_NAME" == "OpenBSD" ]; then
        pkg_add -u
    fi

    echo -e "=== Full package update complete! ==="

    if [ "$OS_NAME" == "OpenBSD" ]; then
        echo -e "\n=== Patching operating system... ==="

        syspatch

        echo -e "=== Operating system patching process complete! ==="
    fi

    echo -e ""
fi
