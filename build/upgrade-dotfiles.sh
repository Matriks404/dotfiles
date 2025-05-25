#!/usr/bin/env bash

current_dir=$(basename "$0")
root_dir=$current_dir/..

os_target=$(cat $root_dir/.dotfiles_os_target)

mv $root_dir/.* .

local bin_dir=./bin

if [ ! -d $bin_dir ]; then
    mkdir $bin_dir
fi

mv $root_dir/bin/* $bin_dir

# Cleanup
rmdir $root_dir/bin

#TODO: REST
