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

if [ -f "master.zip" ]; then
    echo "=== Removing previous dotfiles zip file... ==="
    echo "Info: Dotfiles zip file is already present in the current directory possibly because of some problem with previous dotfiles installation or update operation."
    echo "Info: Do you want to remove it to proceed with this operation? If so, enter \"Yes.\" (without quotes):"
    echo -en "? "
    read answer

    if [ "$answer" == "Yes." ]; then
        rm -fv "master.zip"

        echo ""
    else
        echo "Quitting..."

        exit 1
    fi
fi

echo "=== Getting dotfiles zip file... ==="
wget --quiet "$github_base_url/archive/refs/heads/master.zip"

echo "=== Unzipping dotfiles... ==="
if [ "$OS_NAME" = "Linux" ]; then
    exclude_files="$dotfiles_dir/os_specific/*.openbsd"
elif [ "$OS_NAME" = "OpenBSD" ]; then
    exclude_files="$dotfiles_dir/os_specific/*.linux"
fi

files_to_exclude="$dotfiles_dir/README.md $dotfiles_dir/.gitignore $dotfiles_dir/Documentation/* $dotfiles_dir/build/* $dotfiles_dir/tools/hooks/* $dotfiles_dir/tools/* $exclude_files"

unzip -qq master.zip -x $files_to_exclude


echo "=== Updating dotfiles lists... ==="

txtfiles_dir="$dotfiles_target/.dotfiles_lists"
txtfiles_to_move="$dotfiles_dir/.dotfiles_lists/*"

mkdir -p $txtfiles_dir
rsync -civ $txtfiles_to_move $txtfiles_dir

echo ""
echo "=== Updating dotfiles... ==="

dotfiles_to_move="$(cat $dotfiles_dir/.dotfiles_lists/common.txt) $(cat $dotfiles_dir/.dotfiles_lists/common_buildonly.txt)"

if [ -f "$dotfiles_dir/.dotfiles_lists/$short_name.txt" ]; then
    dotfiles_to_move="$dotfiles_to_move $(cat $dotfiles_dir/.dotfiles_lists/$short_name.txt)"
fi

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


if [ $(command -v xrdb) ]; then
    echo "=== Generating .Xresources.local... ==="

    DPI="$(xdpyinfo 2>/dev/null | grep resolution | awk '{print $2}' | cut -dx -f1)"

    if [ -z "$DPI" ]; then
        DPI=96
    fi

    TARGET_PIXELS=13

    FACESIZE="$(echo "scale=1; $TARGET_PIXELS * 72 / $DPI" | bc)"

    echo "UXTerm*faceSize: $FACESIZE" > "$HOME/.Xresources.local"


    echo ""
    echo "=== Merging .Xresources... ==="
    xrdb $HOME/.Xresources
fi


echo ""
echo "=== Cleaning up... ==="

rm -r $dotfiles_dir
rm master.zip


echo "\nEverything is done! Make sure to restart your shell to get all new features and improvements!"
