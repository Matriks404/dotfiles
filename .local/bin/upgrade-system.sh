#!/usr/bin/env bash

# Getting operating system name
OS_NAME=$(uname -s)

if [ "$EUID" -ne 0 ]; then
    echo -e "ERROR: This script must be run with root privileges!"

    exit 1
fi

if [ -f /etc/debian_version ]; then
    if [ -f /etc/apt/sources.list ]; then
        SOURCES_LIST_LOCATION=/etc/apt/sources.list
    elif [ -f /etc/apt/sources.list.d/debian.sources ]; then
        SOURCES_LIST_LOCATION=/etc/apt/sources.list.d/debian.sources
    else
        echo -e "You don't have valid sources.list available! Quitting..."

        exit 1
    fi

    echo -e "INFO: This script won't upgrade your system, unless you have edited appropriate entries in $SOURCES_LIST_LOCATION!"
    echo -en "Do you want to edit them now? If so, enter \"Yes.\" (without quotes): "
    read answer

    if [ "$answer" == "Yes." ]; then
        editor "$SOURCES_LIST_LOCATION"

        echo -e "INFO: Editing done.\n"
    fi
fi

echo -en "Do you want to continue? If so, enter \"Yes, continue!\" (without quotes): "

read answer

if [ ! "$answer" == "Yes, continue!" ]; then
    echo "Qutting..."

    exit 1
fi



echo -e "\n\n\n"

if [ -f /etc/debian_version ]; then
    if [ $(command -v upgrade-system) ]; then
        upgrade-system
    else
        echo -e "=== Updating APT package list... ==="
        apt update

        echo -e "=== Uprading your system... ==="
        apt dist-upgrade

        echo -e "=== Cleaning up stuff... ==="
        apt autoclean
    fi
elif [ "$OS_NAME" == "OpenBSD" ]; then
    sysupgrade
fi
