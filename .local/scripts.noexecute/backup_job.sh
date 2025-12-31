#!/bin/env bash
#printf -v date '%(%Y-%m-%d)T' -1

#if sudo -v; then
    echo -e 'Welcome to Debian 12+ backup program.\n'
#else
#    echo -e 'Authentication failed. Please enter the correct sudo passowrd.'
#    exit 1
#fi

echo -e '* Processing settings shell script ...'
source /usr/local/scripts/backup_job_files/settings.sh
target=$ESSENTIAL_INFO_LOCAL_DIR

if [ -d $target ]; then
    if [ -d $target.old ]; then
        echo -e 'Removing older version of local backup directory: '$target'.old ...'
        rm -r $target.old
    fi

    echo -e 'Moving old local backup directory to: '$target'.old ...'
    mv $target $target.old
fi

echo -e '===== backing up apt data ====='
echo -e 'Backing up apt data to: '$target

mkdir $target

echo -e '* Backing up apt package list ...'
sudo dpkg --get-selections > $target/apt_package.list

echo -e '* Backing up apt source lists ...'
mkdir $target/apt_sources/
sudo cp -R /etc/apt/sources.list* $target/apt_sources/

echo -e '* Backing up apt repository keys ...'
sudo apt-key exportall > $target/apt_repository.keys

echo -e '===== backing up flatpak data ====='
echo -e 'Backing up flatpak data to: '$target

echo -e '* Backing up installed flatpak app list ...'
flatpak list --columns=application --app > $target/flatpaks.txt

echo -e '===== BACKING UP FILES ====='

echo -e '* Reading include text file ...'
INCLUDE_FROM=()

mapfile -t INCLUDE_FROM < /usr/local/scripts/backup_job_files/include.txt

EXCLUDE_FROM=/usr/local/scripts/backup_job_files/exclude.txt

echo -e '* Backing up files to remote host: '$REMOTE_HOSTNAME' in directory: '$REMOTE_LOCATION' ...'
rsync -aRv -e "ssh -p $REMOTE_PORT" --delete --exclude-from="$EXCLUDE_FROM" \
"${INCLUDE_FROM[@]}" "$REMOTE_HOSTNAME:$REMOTE_LOCATION"
