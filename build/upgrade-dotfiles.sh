#!/usr/bin/env bash

current_dir=$(dirname "$0")
root_dir=$current_dir/..

dotfiles_to_copy="$root_dir/.bash* $root_dir/.dotfiles*"

echo -e "=== Moving dotfiles... ==="
if [ "$USER" == "marcin" ]; then
    full_username=$(getent passwd "marcin" | cut -d ':' -f 5)

    if [[ "$full_username" =~ ^Marcin\ Kralka ]]; then
        dotfiles_to_copy="$dotfiles_to_copy $root_dir/.gitconfig $root_dir/.reportbugrc"
    fi
fi

mv $dotfiles_to_copy .

bin_dir=./bin

if [ ! -d $bin_dir ]; then
    mkdir $bin_dir
fi

echo -e "=== Moving Bash scripts... ==="
mv $root_dir/bin/* $bin_dir

# Cleanup

if [ -f $root_dir/.gitconfig ]; then
    rm $root_dir/.gitconfig
fi

if [ -f $root_dir/.reportbugrc ]; then
    rm $root_dir/.reportbugrc
fi

rmdir $root_dir/bin
