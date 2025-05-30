#!/bin/sh

github_base_url='https://github.com/Matriks404/dotfiles'

# Download and unzip archive containing dotfiles and scripts.
dotfiles_dir='dotfiles-master'

echo "=== Getting dotfiles zip file... ==="
wget "$github_base_url/archive/refs/heads/master.zip"

echo "=== Unzipping dotfiles... ==="
unzip master.zip -x "$dotfiles_dir/README.md" "$dotfiles_dir/.gitignore" "$dotfiles_dir/build/*" "$dotfiles_dir/tools/hooks/*" "$dotfiles_dir/tools/*"

echo "=== Moving dotfiles lists... ==="
txtfiles_to_move="$dotfiles_dir/.dotfiles_lists/*"

mv -v $txtfiles_to_move .

dotfiles_to_move="$(cat $dotfiles_dir/.dotfiles_lists/common.txt)"

echo "=== Moving dotfiles... ==="
if [ "$USER" = "marcin" ]; then
    full_username=$(getent passwd marcin | cut -d ':' -f 5)

    if echo "$full_username" | grep -q "^Marcin Kralka"; then
        #dotfiles_to_copy="$dotfiles_to_copy $dotfiles_dir/.gitconfig"
        dotfiles_to_move="$dotfiles_to_move $(cat $dotfiles_dir/.dotfiles_lists/private.txt)"

        if [ -f /etc/debian_version ]; then
            #dotfiles_to_copy="$dotfiles_to_copy $dotfiles_dir/.reportbugrc"
            dotfiles_to_move="$dotfiles_to_move $(cat $dotfiles_dir/.dotfiles_lists/private_debian.txt)"
        fi
    fi
fi

mv -v $dotfiles_to_copy .

echo "=== Moving Bash scripts... ==="

bin_dir="./.local/bin"
mkdir -p $bin_dir
mv -v $dotfiles_dir/.local/bin/* $bin_dir

# Cleanup

echo "=== Cleaning up... ==="

if [ -f $dotfiles_dir/.gitconfig ]; then
    rm $dotfiles_dir/.gitconfig
fi

if [ -f $dotfiles_dir/.reportbugrc ]; then
    rm $dotfiles_dir/.reportbugrc
fi

rmdir $dotfiles_dir/.local/bin
rmdir $dotfiles_dir/.local
rmdir $dotfiles_dir

rm master.zip

echo "\nEverything is done! Make sure to restart your Bash instance to get all new features and improvements!"
