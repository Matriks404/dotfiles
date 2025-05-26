#!/usr/bin/env bash

# Download and unzip archive containing dotfiles and scripts.
local dotfiles_dir=dotfiles-master
wget $github_base_url/archive/refs/heads/master.zip
unzip master.zip -x $dotfiles_dir/README.md

# Boostrap the script that upgrades dotfiles.
$dotfiles_dir/build/upgrade-dotfiles.sh

# Cleanup.
rm $dotfiles_dir/build/upgrade-dotfiles.sh
rmdir -p $dotfiles_dir/build
rm master.zip
