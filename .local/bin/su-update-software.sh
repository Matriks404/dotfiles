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
        #NOTE: Do not run upgrade-system if deborphan is installed, because if user proceeds with removing packages flagged to uninstall by deborphan, they can break their system.
        #      Latest version of Linux Mint (and probably Ubuntu as well) specifically ships with deborphan that wants to remove essential system packages when run. We want to avoid that at all cost.
        if [ $(command -v upgrade-system) ] && [ ! $(command -v deborphan)  ]; then
            upgrade-system
        else
            echo -e "    === Updating APT package list... ==="
            apt update

            echo -e "\n    === Upgrading your system... ==="
            apt dist-upgrade

            echo -e "\n    === Cleaning up stuff... ==="
            apt clean
        fi
    elif [ "$OS_NAME" == "OpenBSD" ]; then
        pkg_add -u
    fi

    echo -e "\n=== Full package update complete! ==="

    if [ "$OS_NAME" == "OpenBSD" ]; then
        echo -e "\n=== Patching operating system... ==="

        syspatch

        echo -e "\n=== Operating system patching process complete! ==="
    fi

    echo
fi
