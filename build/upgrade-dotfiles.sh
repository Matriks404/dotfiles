#!/usr/bin/env bash

root_dir=$PWD/..
os_target=$(cat $root_dir/.dotfiles_os_target)

mv $root_dir/.* $HOME

local bin_dir=$HOME/bin

if [ ! -d $bin_dir ]; then
    mkdir $bin_dir
fi

mv $root_dir/bin/* $bin_dir

# Cleanup
rmdir $root_dir/bin

#TODO: REST
