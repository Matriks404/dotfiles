#!/usr/bin/env bash
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
source /usr/local/scripts/backup_job_files/settings.sh
target=$ESSENTIAL_INFO_LOCAL_DIR

if [ -d $target ]; then
    if [ -d $target.old ]; then
        echo -e "* Removing older version of local backup directory: "$target".old ..."
        rm -r $target.old
    fi

    echo -e "* Moving old local backup directory to: "$target".old ..."
    mv $target $target.old
fi

if [ -f "/etc/debian_version" ]; then
    MAJOR_VERSION=$(cut -d. -f1 /etc/debian_version)

    echo -e "\n===== backing up apt data ====="
    echo -e "Backing up apt data to: "$target

    mkdir $target

    echo -e "* Backing up apt package list ..."
    sudo dpkg --get-selections > $target/apt_package.list

    echo -e "* Backing up apt source lists ..."
    mkdir $target/apt_sources/
    sudo cp -rv /etc/apt/sources.list* $target/apt_sources/

    echo -e "* Backing up apt repository keys ..."
    if [ "$MAJOR_VERSION" -le 12 ]; then
        sudo apt-key exportall > $target/apt_repository.keys
    else
        sudo cp -rv /etc/apt/keyrings $target/apt_keyrings
    fi
fi

if [ $(command -v flatpak) ]; then
    echo -e "\n===== backing up flatpak data ====="
    echo -e "Backing up flatpak data to: "$target

    echo -e "* Backing up installed flatpak app list ..."
    flatpak list --columns=application --app > $target/flatpaks.txt
fi

echo -e "\n===== BACKING UP FILES ====="

echo -e "* Reading include text file ..."
INCLUDE_FROM=()

mapfile -t INCLUDE_FROM < /usr/local/scripts/backup_job_files/include.txt

EXCLUDE_FROM=/usr/local/scripts/backup_job_files/exclude.txt

if [ -n "$REMOTE_HOSTNAME" ]; then
    if [ -z "$REMOTE_PORT" ]; then
        echo -e "Warning: '\$REMOTE_PORT' is not set. Using default port 22."

        REMOTE_PORT=22
    fi

    echo -e "* Backing up files to remote host: "$REMOTE_HOSTNAME" in directory: "$BACKUP_LOCATION" ..."
    rsync -aRv -e "ssh -p $REMOTE_PORT" --delete --exclude-from="$EXCLUDE_FROM" "${INCLUDE_FROM[@]}" "$REMOTE_HOSTNAME:$BACKUP_LOCATION"

else
   echo -e "* Backing up files to local directory: "$BACKUP_LOCATION" ..."

   rsync -aRv --delete --exclude-from="$EXCLUDE_FROM" "${INCLUDE_FROM[@]}" "$BACKUP_LOCATION"
fi
