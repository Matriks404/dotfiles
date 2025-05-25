#!/usr/bin/env bash

current_dir=$(dirname "$0")
root_dir=$current_dir/..

os_target=$(cat $root_dir/.dotfiles_os_target)

mv $root_dir/.* .

bin_dir=./bin

if [ ! -d $bin_dir ]; then
    mkdir $bin_dir
fi

mv $root_dir/bin/* $bin_dir

# Remove itself.
rm "$0"

# Cleanup
rmdir $root_dir/build
rmdir $root_dir/bin
