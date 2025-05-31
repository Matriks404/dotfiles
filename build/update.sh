#!/bin/sh

# Getting operating system name
OS_NAME=$(uname -s)

if [ "$OS_NAME" == "Linux" ]; then
    short_name = 'linux'
elif [ "$OS_NAME" == "OpenBSD" ]; then
    short_name = 'openbsd'
fi



github_base_url='https://github.com/Matriks404/dotfiles'

# Download and unzip archive containing dotfiles and scripts.
dotfiles_dir='dotfiles-master'

echo "=== Getting dotfiles zip file... ==="
wget --quiet "$github_base_url/archive/refs/heads/master.zip"

echo "=== Unzipping dotfiles... ==="
files_to_exclude="$dotfiles_dir/README.md $dotfiles_dir/FILE_LIST.md $dotfiles_dir/.gitignore $dotfiles_dir/build/* $dotfiles_dir/tools/hooks/* $dotfiles_dir/tools/*"

unzip -qq master.zip -x $files_to_exclude

echo "=== Modifying X files... ==="
sed -i "1i#include \".Xdefaults.$short_name\"" "$dotfiles_dir/.Xdefaults"
sed -i "1i#include \".Xresources.$short_name\"" "dotfiles_dir/.Xresources"

echo "=== Moving dotfiles... ==="

dotfiles_to_move_list="$(cat $dotfiles_dir/.dotfiles_lists/common.txt) $(cat $dotfiles_dir/.dotfiles_lists/$short_name.txt)"

if [ "$USER" = "marcin" ]; then
    full_username=$(getent passwd marcin | cut -d ':' -f 5)

    if echo "$full_username" | grep -q "^Marcin Kralka"; then
        dotfiles_to_move_list="$dotfiles_to_move_list $(cat $dotfiles_dir/.dotfiles_lists/private.txt)"

        if [ -f /etc/debian_version ]; then
            dotfiles_to_move_list="$dotfiles_to_move_list $(cat $dotfiles_dir/.dotfiles_lists/private_debian.txt)"
        fi
    fi
fi

dotfiles_to_move=""

for filename in $dotfiles_to_move_list; do
    dotfiles_to_move="$dotfiles_to_move $dotfiles_dir/$filename"
done



mv -v $dotfiles_to_move .

echo "=== Moving Bash scripts... ==="

bin_dir="./.local/bin"
mkdir -p $bin_dir
mv -v $dotfiles_dir/.local/bin/* $bin_dir

echo "=== Moving dotfiles lists... ==="

txtfiles_dir="./.dotfiles_lists"
txtfiles_to_move="$dotfiles_dir/.dotfiles_lists/*"

mkdir -p $txtfiles_dir
mv -v $txtfiles_to_move $txtfiles_dir

# Cleanup

echo "=== Cleaning up... ==="

rm -rv $dotfiles_dir
rm -v master.zip

echo "\nEverything is done! Make sure to restart your Bash instance to get all new features and improvements!"
