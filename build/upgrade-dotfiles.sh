#!/usr/bin/env bash

os_target=$(cat $HOME/.dotfiles_os_target)
dotfiles_dir=..

mv $dotfiles_dir/.* $HOME

local bin_dir=$HOME/bin

if [ ! -d $bin_dir ]; then
    mkdir $bin_dir
fi

mv $dotfiles_dir/bin/* $bin_dir

# Cleanup
rmdir --parents $dotfiles_dir/bin
