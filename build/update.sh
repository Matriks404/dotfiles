#!/bin/sh

# Getting operating system name
OS_NAME=$(uname -s)

if [ "$OS_NAME" = "Linux" ]; then
    short_name='linux'
elif [ "$OS_NAME" = "OpenBSD" ]; then
    short_name='openbsd'
fi

github_base_url='https://github.com/Matriks404/dotfiles'

# Download and unzip archive containing dotfiles and scripts.
dotfiles_dir='dotfiles-master'
dotfiles_target=$PWD


echo "=== Getting dotfiles zip file... ==="
wget --quiet "$github_base_url/archive/refs/heads/master.zip"

echo "=== Unzipping dotfiles... ==="
if [ "$OS_NAME" = "Linux" ]; then
    exclude_files="$dotfiles_dir/os_specific/*.openbsd"
elif [ "$OS_NAME" = "OpenBSD" ]; then
    exclude_files="$dotfiles_dir/os_specific/*.linux"
fi

files_to_exclude="$dotfiles_dir/README.md $dotfiles_dir/FILE_LIST.md $dotfiles_dir/.gitignore $dotfiles_dir/build/* $dotfiles_dir/tools/hooks/* $dotfiles_dir/tools/* $exclude_files"

unzip -qq master.zip -x $files_to_exclude


echo "=== Updating dotfiles lists... ==="

txtfiles_dir="$dotfiles_target/.dotfiles_lists"
txtfiles_to_move="$dotfiles_dir/.dotfiles_lists/*"

mkdir -p $txtfiles_dir
rsync -civ $txtfiles_to_move $txtfiles_dir

echo ""
echo "=== Updating dotfiles... ==="

dotfiles_to_move="$(cat $dotfiles_dir/.dotfiles_lists/common.txt)"

if [ -f /etc/debian_version ]; then
    dotfiles_to_move="$dotfiles_to_move $(cat $dotfiles_dir/.dotfiles_lists/debian.txt)"
fi

if [ "$USER" = "marcin" ]; then
    full_username=$(getent passwd marcin | cut -d ':' -f 5)

    if echo "$full_username" | grep -q "^Marcin Kralka"; then
        dotfiles_to_move="$dotfiles_to_move $(cat $dotfiles_dir/.dotfiles_lists/private.txt)"

        if [ -f /etc/debian_version ]; then
            dotfiles_to_move="$dotfiles_to_move $(cat $dotfiles_dir/.dotfiles_lists/private_debian.txt)"
        fi
    fi
fi

cd $dotfiles_dir
rsync -ciRv $dotfiles_to_move $dotfiles_target
cd $dotfiles_target


echo ""
echo "=== Updating OS-specific dotfiles... ==="
os_specific_dotfiles_list="$dotfiles_dir/.dotfiles_lists/os_specific.txt"
os_specific_repo_dir="$dotfiles_dir/os_specific"

while IFS= read -r entry; do
    filename="${entry}.$short_name"

    if [ -f "$os_specific_repo_dir/$filename" ]; then
        final_name="${entry}.1"

        rsync -civ $os_specific_repo_dir/$filename $dotfiles_target/$final_name
    fi
done < "$os_specific_dotfiles_list"


echo ""
echo "=== Updating Bash scripts... ==="

bin_dir="$dotfiles_target/.local/bin"
mkdir -p $bin_dir
rsync -civ $dotfiles_dir/.local/bin/* $bin_dir

echo ""


if [ $(command -v xrdb) ]; then
    echo "=== Merging .Xresources... ==="
    xrdb $HOME/.Xresources
fi


echo "=== Cleaning up... ==="

rm -r $dotfiles_dir
rm master.zip


echo "\nEverything is done! Make sure to restart your Bash instance to get all new features and improvements!"
