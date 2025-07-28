#!/usr/bin/env bash

# Getting operating system name
OS_NAME=$(uname -s)

if [ "$EUID" -ne 0 ]; then
    echo -e "Error: This script must be run with root privileges!"

    exit 1
fi

if [ -f /etc/debian_version ]; then
    if [ -f /etc/apt/sources.list ]; then
        SOURCES_LIST_LOCATION=/etc/apt/sources.list
    elif [ -f /etc/apt/sources.list.d/debian.sources ]; then
        SOURCES_LIST_LOCATION=/etc/apt/sources.list.d/debian.sources
    else
        echo -e "Error: You don't have valid sources.list available! Quitting..."

        exit 1
    fi

    echo -e "Info: This script won't upgrade your system, unless you have edited appropriate entries in $SOURCES_LIST_LOCATION!"
    echo -e "Do you want to edit them now? If so, enter \"Yes.\" (without quotes):"
    echo -en "? "
    read answer

    if [ "$answer" == "Yes." ]; then
        editor "$SOURCES_LIST_LOCATION"

        echo -e "Info: Editing done.\n"
    fi
fi

echo -e "Do you want to continue? If so, enter \"Yes, continue!\" (without quotes): "
echo -en "? "

read answer

if [ ! "$answer" == "Yes, continue!" ]; then
    echo "Quitting..."

    exit 1
fi



echo -e "\n"

if [ -f /etc/debian_version ]; then
    if [ $(command -v upgrade-system) ]; then
        upgrade-system
    else
        echo -e "=== Updating APT package list... ==="
        apt update

        echo -e "\n=== Uprading your system... ==="
        apt dist-upgrade

        echo -e "\n=== Cleaning up stuff... ==="
        apt autoclean
    fi
elif [ "$OS_NAME" == "OpenBSD" ]; then
    kern_version=$(sysctl -n kern.version 2>/dev/null)

    if echo "$kern_version" | grep -q "OpenBSD [0-9].[0-9]-current"; then
        echo -e "=== Upgrading your system... ==="
        sysupgrade -s
    else
        echo -e "=== Patching operating system... ==="
        syspatch
        echo -e "\n=== Operating system patching process complete! ==="

        echo -e "\n=== Upgrading your system... ==="
        sysupgrade
    fi
fi

echo -e "\n=== System upgrade complete! ==="
