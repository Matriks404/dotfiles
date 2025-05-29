#!/usr/bin/env bash

current_dir=$(dirname "$0")
root_dir=$current_dir/..

dotfiles_to_copy="$root_dir/.bash* $root_dir/.dotfiles*"

echo -e "    === Moving dotfiles... ==="
if [ "$USER" == "marcin" ]; then
    full_username=$(getent passwd "marcin" | cut -d ':' -f 5)

    if [[ "$full_username" =~ ^Marcin\ Kralka ]]; then
        dotfiles_to_copy="$dotfiles_to_copy $root_dir/.gitconfig"

        if [ -f /etc/debian_version ]; then
            dotfiles_to_copy="$dotfiles_to_copy $root_dir/.reportbugrc"
        fi
    fi
fi

mv $dotfiles_to_copy .

bin_dir=./.local/bin

mkdir -p $bin_dir

echo -e "    === Moving Bash scripts... ==="
mv $root_dir/.local/bin/* $bin_dir

# Cleanup

echo -e "    === Doing some cleanup... ==="
if [ -f $root_dir/.gitconfig ]; then
    rm $root_dir/.gitconfig
fi

if [ -f $root_dir/.reportbugrc ]; then
    rm $root_dir/.reportbugrc
fi

rmdir $root_dir/.local/bin
rmdir $root_dir/.local
