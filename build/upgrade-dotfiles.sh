#!/usr/bin/env bash

current_dir=$(dirname "$0")
root_dir=$current_dir/..

mv $root_dir/.* .

bin_dir=./bin

if [ ! -d $bin_dir ]; then
    mkdir $bin_dir
fi

mv $root_dir/bin/* $bin_dir

# Cleanup
rmdir $root_dir/bin
