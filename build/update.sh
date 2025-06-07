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

txtfiles_dir="./.dotfiles_lists"
txtfiles_to_move="$dotfiles_dir/.dotfiles_lists/*"

mkdir -p $txtfiles_dir
rsync -civ $txtfiles_to_move $txtfiles_dir

echo ""
echo "=== Updating dotfiles... ==="

dotfiles_to_move_list="$(cat $dotfiles_dir/.dotfiles_lists/common.txt)"

if [ -f /etc/debian_version ]; then
    dotfiles_to_move_list="$dotfiles_to_move_list $(cat $dotfiles_dir/.dotfiles_lists/debian.txt)"
fi

if [ "$USER" = "marcin" ]; then
    full_username=$(getent passwd marcin | cut -d ':' -f 5)

    if echo "$full_username" | grep -q "^Marcin Kralka"; then
        dotfiles_to_move_list="$dotfiles_to_move_list $(cat $dotfiles_dir/.dotfiles_lists/private.txt)"

        if [ -f /etc/debian_version ]; then
            dotfiles_to_move_list="$dotfiles_to_move_list $(cat $dotfiles_dir/.dotfiles_lists/private_debian.txt)"
        fi
    fi
fi

dotfiles_to_move=""

for filename in $dotfiles_to_move_list; do
    dotfiles_to_move="$dotfiles_to_move $dotfiles_dir/$filename"
done

rsync -ciRv $dotfiles_to_move .


echo ""
echo "=== Updating OS-specific dotfiles... ==="
os_specific_dotfiles_list="$dotfiles_dir/.dotfiles_lists/os_specific.txt"
os_specific_repo_dir="$dotfiles_dir/os_specific"

while IFS= read -r entry; do
    filename="${entry}.$short_name"

    if [ -f "$os_specific_repo_dir/$filename" ]; then
        final_name="${entry}.1"

        # Rename the file so we can rsync it.
        #mv ./$final_name ./$filename

        rsync -itv $os_specific_repo_dir/$filename ./$final_name

        # Rename the file again, to the final name.
        #mv ./$filename ./$final_name
    fi
done < "$os_specific_dotfiles_list"


echo ""
echo "=== Updating Bash scripts... ==="

bin_dir="./.local/bin"
mkdir -p $bin_dir
rsync -civ $dotfiles_dir/.local/bin/* $bin_dir


echo ""
echo "=== Merging .Xresources... ==="
xrdb $HOME/.Xresources


echo "=== Cleaning up... ==="

rm -r $dotfiles_dir
rm master.zip

echo "\nEverything is done! Make sure to restart your Bash instance to get all new features and improvements!"
