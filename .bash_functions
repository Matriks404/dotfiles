#Getting operating system name
OS_NAME=$(uname -s)

github_repo=Matriks404/dotfiles
github_base_url=https://github.com/$github_repo
#os_target=$(cat $HOME/.dotfiles_os_target)

backup-file ()
{
    cp $1 $1.bak
}

check-dotfiles-update ()
{
    url="https://raw.githubusercontent.com/$github_repo/refs/heads/master/.dotfiles_version"

    current_version="$(dotver | cut -d ' ' -f 1)"
    latest_version="$(curl -s $url | cut -d ' ' -f 1)"

    if [[ "$current_version" = "$latest_version" || "$current_version" > "$latest_version" ]]; then
        echo "You have the latest version of dotfiles! ($current_version)"

        return 1
    else
        echo "There is a dotfiles update available! ($current_version --> $latest_version)"

        return 0
    fi
}

clone-dotfiles-repository ()
{
    local repos_dir=$HOME/repos
    local dotfiles_repo_dir=$HOME/repos/dotfiles

    # Return prematurely if dotfiles repository already exists.
    if [ -d $dotfiles_repo_dir ]; then
        return 1
    fi

    mkdir -p $repos_dir

    #git clone --branch $os_target $github_base_url.git $dotfiles_repo_dir
    git clone $github_base_url.git $dotfiles_repo_dir
}

copy-dotfiles-to-repos-directory ()
{
    if [ "$OS_NAME" == "Linux" ]; then
        short_name='linux'
    elif [ "$OS_NAME" == "OpenBSD" ]; then
        short_name='openbsd'
    fi

    local repos_dir=$HOME/repos
    local dotfiles_repo_dir=$HOME/repos/dotfiles

    # Clone dotfiles repository if it doesn't exist.
    if [ ! -d $dotfiles_repo_dir ]; then
        echo -e "=== Cloning the dotfiles repository, because it doesn't exist yet... ==="
        clone-dotfiles-repository
    fi

    echo -e "=== Copying dotfiles lists... ==="
    local txtfiles_to_copy="$HOME/.dotfiles_lists/*"
    local txtfiles_repo_dir="$dotfiles_repo_dir/.dotfiles_lists/"

    mkdir -p $txtfiles_repo_dir
    rsync -civ $txtfiles_to_copy $txtfiles_repo_dir

    echo -e "=== Copying dotfiles... ==="
    local dotfiles_to_copy="$(cat $HOME/.dotfiles_lists/common.txt)"

    if [ -f /etc/debian_version ]; then
        dotfiles_to_copy="$dotfiles_to_copy $(cat $HOME/.dotfiles_lists/debian.txt)"
    fi

    if [ "$USER" == "marcin" ]; then
        full_username=$(getent passwd "marcin" | cut -d ':' -f 5)

        if [[ "$full_username" =~ ^Marcin\ Kralka ]]; then
            dotfiles_to_copy="$dotfiles_to_copy $(cat $HOME/.dotfiles_lists/private.txt)"

            if [ -f /etc/debian_version ]; then
                dotfiles_to_copy="$dotfiles_to_copy $(cat $HOME/.dotfiles_lists/private_debian.txt)"
            fi
        fi
    fi

    rsync -ciRv $dotfiles_to_copy $dotfiles_repo_dir

    echo -e "=== Copying OS-specific dotfiles... ==="
    local os_specific_dotfiles_list="$(cat $HOME/.dotfiles_lists/os_specific.txt)"
    local os_specific_repo_dir="$dotfiles_repo_dir/os_specific"

    mkdir -p $os_specific_repo_dir

    for entry in $os_specific_dotfiles_list; do
        filename="${entry}.1"

        if [ -f "$filename" ]; then
            final_name=$entry.$short_name

            rsync -ciRv $filename $os_specific_repo_dir/$final_name
        fi
    done

    echo -e "=== Copying Bash scripts... ==="
    # Files and directories that begin with symbols such as _ won't be copied.
    # As an example you can use "_LOCAL_<rest of the name>" for local-only files and directories.
    local bin_files_to_copy="$HOME/.local/bin/[0-9a-zA-Z]*.sh"
    local bin_files_repo_dir="$dotfiles_repo_dir/.local/bin"

    mkdir -p $bin_files_repo_dir
    rsync -civ $bin_files_to_copy $bin_files_repo_dir
}

edit-repos ()
{
    if [ -f /etc/debian_version ]; then
        if [[ "$1" == "-f" || "$1" == "-fl" || "$1" == "-fs" || "$1" == "--file" ]]; then
            if [ -z "$2" ]; then
                echo -e "Error: You need to provide a filename!"

                return 1
            fi

            if [ "$1" == "-fl" ]; then
                local file="/etc/apt/sources.list.d/$2.list"
            elif [ "$1" == "-fs" ]; then
                local file="/etc/apt/sources.list.d/$2.sources"
            else
                local file="/etc/apt/sources.list.d/$2"
            fi

            if [ -f "$file" ]; then
                sudo $EDITOR "$file"
            else
                echo -e "Error: $file doesn't exist!"
            fi

            return 1
        fi

        local files=()

        if [ -f /etc/apt/sources.list ]; then
            files+=("/etc/apt/sources.list")
        fi

        sources_list_dir="/etc/apt/sources.list.d"

        if [ -d $sources_list_dir ]; then
            for file in $sources_list_dir/*.{list,sources}; do
                if [ -f "$file" ]; then
                    files+=("$file")
                fi
            done
        fi

        local num_files=${#files[@]}

        if [ "$num_files" -eq 0 ]; then
            echo -e "Error: You don't have valid sources.list available!"

            return 1
        elif [ "$num_files" -eq 1 ]; then
            sudo $EDITOR "${files[0]}"

            return 0
        fi

        mapfile -t sorted_files < <(printf "%s\n" "${files[@]}" | sort)

        local i=1

        echo "Files available:"

        for file in "${sorted_files[@]}"; do
            echo "  $i) $file"
            ((i++))
        done

        echo ""

        read -rp "Select file you want to edit (1-$num_files): " selection

        if ! [[ "$selection" =~ ^[0-9]+$ ]] || [[ "$selection" -lt 1 ]] || [[ "$selection" -gt "$num_files" ]]; then
            echo -e "\nError: Invalid selection. Next time enter a number between 1 and $num_files."

            return 1
        fi

        local selected_file="${sorted_files[$((selection - 1))]}"
        sudo $EDITOR "$selected_file"

    elif [ "$OS_NAME" == "OpenBSD" ]; then
        doas $EDITOR /etc/installurl
    else
        echo -e "Error: Unsupported operating system/Linux distribution."
    fi
}

get-manual ()
{
    parent_pid=$(ps -p $$ -o ppid= | xargs)

    current_pid=$parent_pid
    is_unicode_term="true"

    while [ -n "$current_pid" ] && [ "$current_pid" -ne "1" ]; do
        cmd=$(ps -p $current_pid -o command= | xargs)

        term="${cmd%% *}"

        if [ $term = "xterm" ] || [ $term = "/usr/X11R6/bin/xterm" ] || [ $term = "/usr/bin/X11/xterm" ] || [ $term = "/usr/bin/xterm" ]; then
            if [ "$cmd" = "$term -class UXTerm" ] || [ "$cmd" = "$term -class UXTerm -u8" ]; then
                is_unicode_term="true"

                break
            else
                is_unicode_term="false"

                break
            fi
        fi

        current_pid=$(ps -p "$current_pid" -o ppid= | xargs)
    done

    if [ -z "$1" ]; then
        man
    elif [ "$is_unicode_term" = "false" ]; then
        echo -e "Running external UXTerm, since current terminal dosen't support UTF-8..."

        (xterm -class UXTerm -e sh -c "man $* && echo Press RETURN to continue. && read DUMMY" &)
    else
        man "$*"
    fi
}

get-new-dotfiles ()
{
    if [ -d "./.git" ]; then
        echo -e "ERROR: You are in the git repository directory! Quitting..."

        return 1
    fi

    FORCE_UPDATE=false

    if [ "$1" == "-f" -o "$1" == "--force" ]; then
        FORCE_UPDATE=true
    fi

    if $FORCE_UPDATE || check-dotfiles-update; then
        echo -e "\nGetting new dotfiles..."

        repo_name='Matriks404/dotfiles'

        curl --silent "https://raw.githubusercontent.com/$repo_name/refs/heads/master/build/update.sh" | sh
    else
        echo -e "\nThere is no need to update dotfiles."
        echo -e "Use -f or --force option to force update them."
    fi
}

get-repos ()
{
    if [ -f /etc/debian_version ]; then
        local files=()

        sources_list_dir="/etc/apt/sources.list.d"

        if [ -f /etc/apt/sources.list ]; then
            files+=("/etc/apt/sources.list")
        fi

        if [ -d $sources_list_dir ]; then
            for file in $sources_list_dir/*.{list,sources}; do
                if [ -f "$file" ]; then
                    files+=("$file")
                fi
            done
        fi

        local num_files=${#files[@]}

        if [ "$num_files" -eq 0 ]; then
            echo -e "Error: You don't have valid sources.list available!"

            return 1
        fi

        mapfile -t sorted_files < <(printf "%s\n" "${files[@]}" | sort)

        local temp_file=$(mktemp)

        for file in "${sorted_files[@]}"; do
            echo -e "=== File: $file ===" >> $temp_file
            cat "$file" >> $temp_file
            echo "" >> $temp_file
        done

        less $temp_file
        rm $temp_file

    elif [ "$OS_NAME" == "OpenBSD" ]; then
        cat /etc/installurl
    else
        echo -e "Error: Unsupported operating system/Linux distribution."
    fi
}

git-commit ()
{
    local comment=$1

    git add .
    git commit -m "$comment"
}

git-push ()
{
    local comment=$1

    git-commit "$comment"
    git push
}

# Package updates / System upgrades

su-update-all ()
{
    if [ "$OS_NAME" == "Linux" ]; then
        sudo $HOME/.local/bin/update-all.sh
    elif [ "$OS_NAME" == "OpenBSD" ]; then
        doas $HOME/.local/bin/update-all.sh
    fi
}

update-all ()
{
    if [ "$OS_NAME" == "Linux" ]; then
        $HOME/.local/bin/update-all.sh
    elif [ "$OS_NAME" == "OpenBSD" ]; then
        su-update-all
    fi
}

su-upgrade-system ()
{
    if [ "$OS_NAME" == "Linux" ]; then
        sudo $HOME/.local/bin/upgrade-system.sh
    elif [ "$OS_NAME" == "OpenBSD" ]; then
        doas $HOME/.local/bin/upgrade-system.sh
    fi
}

# Linux-specific functions
if [ "$OS_NAME" == "Linux" ]; then
    edit-debian-sources ()
    {
        if [ -f /etc/apt/sources.list ]; then
            edit-repos
        elif [ -f /etc/apt/sources.list.d/debian.sources ]; then
            edit-repos --file debian.sources
        else
            echo -e "Error: No valid Debian GNU/Linux repository sources.list found!"

            return 1
        fi
    }

    wiki ()
    {
        local article=$1

        wikipedia2text "$article" | less
    }
fi
