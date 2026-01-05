#!/bin/sh

echo() {
    case "$1" in
        -e) shift; printf "%b\n" "$*" ;;
        *) printf "%s\n" "$*" ;;
    esac
}

#printf -v date "%(%Y-%m-%d)T" -1

#if sudo -v; then
    echo -e "Welcome to Matriks404's backup program."
    echo -e "Originally written for Debian 12+.\n"
    echo -e "Version $(cat /usr/local/scripts/backup_job.sh.version) -- USE ON YOUR OWN RISK."
    echo -e "Backup files version $(cat /usr/local/scripts/backup_job_files/version)\n\n"
#else
#    echo -e "Authentication failed. Please enter the correct sudo passowrd."
#    exit 1
#fi

echo -e "* Processing settings shell script ..."
. /usr/local/scripts/backup_job_files/settings.sh
TARGET="$ESSENTIAL_INFO_LOCAL_DIR"
TARGET_OLD="${TARGET}.old"

if [ -d "$TARGET" ]; then
    if [ -d "$TARGET_OLD" ]; then
        echo -e "* Removing older version of local backup directory: ${TARGET_OLD} ..."
        rm -r "$TARGET_OLD"
    fi

    echo -e "* Moving old local backup directory to: ${TARGET_OLD} ..."
    mv "$TARGET" "$TARGET_OLD"
fi

if [ -f "/etc/debian_version" ]; then
    VERSION_STRING=$(cat /etc/debian_version)

    case "$VERSION_STRING" in
        [0-9]*)
            MAJOR_VERSION=$(echo "$VERSION_STRING" | cut -d. -f1)
            ;;
        *)
            MAJOR_VERSION=9999
            ;;
    esac

    echo -e "\n===== backing up apt data ====="
    echo -e "Backing up apt data to: ${TARGET}"

    mkdir "$TARGET"

    echo -e "* Backing up apt package list ..."
    sudo dpkg --get-selections > "${TARGET}/apt_package.list"

    echo -e "* Backing up apt source lists ..."
    mkdir "${TARGET}/apt_sources/"
    sudo cp -rv "/etc/apt/sources.list"* "${TARGET}/apt_sources/"

    echo -e "* Backing up apt repository keys ..."
    if [ "$MAJOR_VERSION" -le 12 ]; then
        sudo apt-key exportall > "${TARGET}/apt_repository.keys"
    else
        if [ -d /etc/apt/keyrings ]; then
            sudo cp -rv "/etc/apt/keyrings" "${TARGET}/apt_keyrings"
        else
            echo -e "No '/etc/apt/keyrings' directory. Skipping."
        fi
    fi
fi

if [ $(command -v flatpak) ]; then
    echo -e "\n===== backing up flatpak data ====="
    echo -e "Backing up flatpak data to: ${TARGET}"

    echo -e "* Backing up installed flatpak app list ..."
    flatpak list --columns=application --app > "${TARGET}/flatpaks.txt"
fi

echo -e "\n===== BACKING UP FILES ====="

echo -e "* Reading include text file ..."

# Save the old IFS
old_ifs="$IFS"

# Set IFS to only a newline character
IFS='
'

set -f # Disable globbing
set -- $(cat /usr/local/scripts/backup_job_files/include.txt)
set +f # Re-enable globbing

# Restore original IFS
IFS="$old_ifs"

EXCLUDE_FROM=/usr/local/scripts/backup_job_files/exclude.txt

if [ -n "$REMOTE_HOSTNAME" ]; then
    if [ -z "$REMOTE_PORT" ]; then
        echo -e "Warning: '\$REMOTE_PORT' is not set. Using default port 22."

        REMOTE_PORT=22
    fi

    echo -e "* Backing up files to remote host: "$REMOTE_HOSTNAME" in directory: "$BACKUP_LOCATION" ..."
    rsync -aRv -e "ssh -p $REMOTE_PORT" --delete --exclude-from="$EXCLUDE_FROM" "${@}" "$TARGET" "$TARGET_OLD" "$REMOTE_HOSTNAME:$BACKUP_LOCATION"

else
   echo -e "* Backing up files to local directory: "$BACKUP_LOCATION" ..."

   rsync -aRv --delete --exclude-from="$EXCLUDE_FROM" "${@}" "$TARGET" "$TARGET_OLD" "$BACKUP_LOCATION"
fi
