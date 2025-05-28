#!/bin/sh

github_base_url='https://github.com/Matriks404/dotfiles'

# Download and unzip archive containing dotfiles and scripts.
dotfiles_dir='dotfiles-master'

echo "=== Getting dotfiles zip file... ==="
wget "$github_base_url/archive/refs/heads/master.zip"

echo "=== Unzipping dotfiles... ==="
unzip master.zip -x "$dotfiles_dir/README.md" "$dotfiles_dir/.gitignore" "$dotfiles_dir/tools/hooks/*" "$dotfiles_dir/tools/*"

# Boostrap the script that upgrades dotfiles.
echo "=== Bootstrapping 'build/update-dotfiles.sh Bash script... ==="
$dotfiles_dir/build/upgrade-dotfiles.sh

# Cleanup.
echo "=== Doing some final cleanup... ===
rm "$dotfiles_dir/build/upgrade-dotfiles.sh"
rmdir -p "$dotfiles_dir/build"

rm "master.zip"
