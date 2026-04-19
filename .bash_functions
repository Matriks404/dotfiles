#HACK: Ideally this should be an export in '.profile', but it's not working properly on Debian 11.
OS_NAME="$(uname -s)"

GITHUB_REPO="Matriks404/dotfiles"
GITHUB_BASE_URL="https://github.com/${GITHUB_REPO}"

check-dotfiles-update() {
    local url="https://raw.githubusercontent.com/${GITHUB_REPO}/refs/heads/master/.dotfiles_version"
    local current_version
    local latest_version

    current_version="$(dotver | cut -d ' ' -f 1)"
    latest_version="$(curl -s "${url}" | cut -d ' ' -f 1)"

    if [[ "$current_version" == "$latest_version" ]] || [[ "$current_version" > "$latest_version" ]]; then
        echo -e "You have the latest version of dotfiles! (${current_version})"
        return 1
    else
        echo -e "There is a dotfiles update available! (${current_version} --> ${latest_version})"
        return 0
    fi
}

edit-repos() {
    if [[ -f "/etc/debian_version" ]]; then
        if [[ "$1" == "-f" || "$1" == "-fl" || "$1" == "-fs" || "$1" == "--file" ]]; then
            if [[ -z "$2" ]]; then
                echo -e "Error: You need to provide a filename!"

                return 1
            fi

            local file

            if [[ "$1" == "-fl" ]]; then
                file="/etc/apt/sources.list.d/${2}.list"
            elif [[ "$1" == "-fs" ]]; then
                file="/etc/apt/sources.list.d/${2}.sources"
            else
                file="/etc/apt/sources.list.d/${2}"
            fi

            if [[ ! -f "$file" ]]; then
                echo -e "Error: File '${file}' doesn't exist!"

                return 1
            fi

            "$SU_CMD" "$EDITOR" "$file"
            return $?
        fi

        # Logic for interactive file selection
        local files=()

        [[ -f "/etc/apt/sources.list" ]] && files+=("/etc/apt/sources.list")

        local sources_list_dir="/etc/apt/sources.list.d"
        local file

        if [[ -d "$sources_list_dir" ]]; then
            # Using a loop to avoid issues if no files match glob
            for file in "${sources_list_dir}/"*.{list,sources}; do
                [[ -f "$file" ]] && files+=("$file")
            done
        fi

        local num_files="${#files[@]}"

        if [[ "$num_files" -eq 0 ]]; then
            echo -e "Error: You don't have valid sources.list available!"

            return 1
        elif [[ "$num_files" -eq 1 ]]; then
            "$SU_CMD" "$EDITOR" "${files[0]}"

            return 0
        fi

        local sorted_files
        mapfile -t sorted_files < <(printf "%s\n" "${files[@]}" | sort)

        local i=1

        echo -e "Files available:"
        for file in "${sorted_files[@]}"; do
            echo -e "  $i) $file"
            ((i++))
        done

        local selection
        read -rp "Select file you want to edit (1-${num_files}): " selection

        if ! [[ "$selection" =~ ^[0-9]+$ ]] || (( selection < 1 || selection > num_files )); then
            echo -e "\nError: Invalid selection!"

            return 1
        fi

        local selected_file="${sorted_files[selection - 1]}"
        "$SU_CMD" "$EDITOR" "$selected_file"

    elif [[ "$OS_NAME" == "OpenBSD" ]]; then
        "$SU_CMD" "$EDITOR" "/etc/installurl"
        return $?
    else
        echo -e "Error: Unsupported operating system!"

        return 1
    fi
}

get-manual() {
    local parent_pid
    parent_pid="$(ps -p $$ -o ppid= | xargs)"

    local current_pid="$parent_pid"
    local is_unicode_term="true"
    local cmd
    local term

    while [[ -n "$current_pid" && "$current_pid" -ne "1" ]]; do
        cmd="$(ps -p "$current_pid" -o command= | xargs)"
        term="${cmd%% *}"

        case "$term" in
            "xterm"|"/usr/X11R6/bin/xterm"|"/usr/bin/X11/xterm"|"/usr/bin/xterm")
                if [[ "$cmd" == "$term -class UXTerm"* ]]; then
                    is_unicode_term="true"
                else
                    is_unicode_term="false"
                fi
                break
                ;;
        esac
        current_pid="$(ps -p "$current_pid" -o ppid= | xargs)"
    done

    if [[ -z "$1" ]]; then
        man
    elif [[ "$is_unicode_term" == "false" ]]; then
        echo -e "Running external UXTerm (non-UTF8 terminal detected)..."
        (xterm -class "UXTerm" -e "sh -c \"man $* && echo Press RETURN to continue. && read -r _\"" &)
    else
        man "$@"
    fi
}

get-new-dotfiles() {
    if [[ -d "./.git" ]]; then
        echo -e "ERROR: You are in a git repository directory! Quitting..."

        return 1
    fi

    local force_update="false"

    [[ "$1" == "-f" || "$1" == "--force" ]] && force_update="true"

    if [[ "$force_update" == "true" ]] || check-dotfiles-update; then
        echo -e "\nGetting new dotfiles..."
        local repo_name="Matriks404/dotfiles"

        curl --silent "https://raw.githubusercontent.com/${repo_name}/refs/heads/master/build/update.sh" | sh
    else
        echo -e "\nNo update needed. Use -f to force."
    fi
}

get-repos() {
    if [[ -f "/etc/debian_version" ]]; then
        local files=()
        local sources_list_dir="/etc/apt/sources.list.d"
        local file

        [[ -f /etc/apt/sources.list ]] && files+=("/etc/apt/sources.list")

        if [[ -d "$sources_list_dir" ]]; then
            for file in "${sources_list_dir}"/*.{list,sources}; do
                [[ -f "$file" ]] && files+=("$file")
            done
        fi

        if [[ "${#files[@]}" -eq 0 ]]; then
            echo -e "Error: No sources found."

            return 1
        fi

        local sorted_files
        mapfile -t sorted_files < <(printf "%s\n" "${files[@]}" | sort)

        local temp_file
        temp_file=$(mktemp)

        for file in "${sorted_files[@]}"; do
            {
                echo -e "=== File: $file ==="
                cat "$file"
                echo -e ""
            } >> "$temp_file"
        done

        less "$temp_file"
        rm "$temp_file"

    elif [[ "$OS_NAME" == "OpenBSD" ]]; then
        cat /etc/installurl
    fi
}

show-binaries() {
    if [[ -z "$1" ]]; then
        echo -e "Error: Provide a package name!"

        return 1
    fi

    local cmdline_local=""

    if [[ -f /etc/debian_version ]]; then
        cmdline_local="dpkg -L"
    elif [[ "$OS_NAME" == "OpenBSD" ]]; then
        cmdline_local="pkg_info -L"
    else
        echo -e "Error: Unsupported OS."

        return 1
    fi

    local package_exists="false"
    local output=""

    if $cmdline_local "$1" &>/dev/null; then
        echo -e "Info: Found local package '$1'."
        package_exists="true"
        output="$($cmdline_local "$1" | grep -E '/(s?bin|games|libexec)/' | sort)"
    elif [[ -f /etc/debian_version ]] && apt-cache show "$1" &>/dev/null; then
        echo -e "Info: Found remote package '$1'."
        package_exists="true"

        if ! command -v apt-file &>/dev/null; then
            echo -e "Error: 'apt-file' not found."

            return 1
        fi
        output="$(apt-file list "$1" | grep -E '/(s?bin|games|libexec)/' | sort)"
    fi

    if [[ "$package_exists" == "false" ]]; then
        echo -e "Error: Package '$1' not found!"

        return 1
    fi

    if [[ -n "$output" ]]; then
        echo -e "\nBinary files:\n$output"
    else
        echo -e "Info: No binary files found for package '$1'."
    fi
}

toggle-disabled() {
    local file_path="$1"

    [[ -z "$file_path" ]] && { echo -e "Error: No path."; return 1; }
    [[ ! -e "$file_path" ]] && { echo -e "Error: Not found."; return 1; }

    local new_file_path

    if [[ "$file_path" == *".disabled" ]]; then
        new_file_path="${file_path%.disabled}"
    else
        new_file_path="${file_path}.disabled"
    fi

    if mv "$file_path" "$new_file_path"; then
        echo -e "Successfully renamed to '$new_file_path'."
    else
        echo -e "Error: Rename failed."

        return 1
    fi
}

if command -v git &>/dev/null; then
    clone-dotfiles-repository() {
        local repos_dir="$HOME/repos"
        local dotfiles_repo_dir="$repos_dir/dotfiles"

        [[ -d "$dotfiles_repo_dir" ]] && return 1

        mkdir -p "$repos_dir"
        git clone "${GITHUB_BASE_URL}.git" "$dotfiles_repo_dir"

        # Using subshell to avoid directory bleed
        (
            cd "$dotfiles_repo_dir" || exit 1
            tools/initial_repository_setup.sh
        )
    }

copy-dotfiles-to-repos-directory ()
    {
        local short_name

        if [[ "$OS_NAME" == "Linux" ]]; then
            short_name='linux'
        elif [[ "$OS_NAME" == "OpenBSD" ]]; then
            short_name='openbsd'
        fi

        local repos_dir="$HOME/repos"
        local dotfiles_repo_dir="$HOME/repos/dotfiles"

        # Clone dotfiles repository if it doesn't exist.
        if [[ ! -d "$dotfiles_repo_dir" ]]; then
            echo -e "=== Cloning the dotfiles repository, because it doesn't exist yet... ==="
            clone-dotfiles-repository
        fi

        echo -e "\n=== Updating dotfiles repository to the latest commit... ==="
        echo -e "Info: This script won't copy dotfiles, unless dotfiles git repository is updated."
        echo -e "Are you OK with pulling the latest git commit? If so, enter \"Yes.\" (without quotes):"
        echo -en "? "
        local answer
        read -r answer
        echo

        if [[ ! "$answer" == "Yes." ]]; then
            echo -e "Quitting..."

            return 1
        fi

        if ! update-dotfiles-repository; then

            return 1
        fi

        echo -e "\n=== Copying dotfiles lists... ==="
        local txtfiles_to_copy="$HOME/.dotfiles_lists/*"
        local txtfiles_repo_dir="$dotfiles_repo_dir/.dotfiles_lists/"

        rsync -civ $txtfiles_to_copy "$txtfiles_repo_dir"

        echo -e "\n=== Copying dotfiles... ==="
        local dotfiles_to_copy
        dotfiles_to_copy="$(cat "$HOME/.dotfiles_lists/common.txt")"

        if [[ -f "$HOME/.dotfiles_lists/${short_name}.txt" ]]; then
            dotfiles_to_copy="$dotfiles_to_copy $(cat "$HOME/.dotfiles_lists/${short_name}.txt")"
        fi

        if [[ -f /etc/debian_version ]]; then
            dotfiles_to_copy="$dotfiles_to_copy $(cat "$HOME/.dotfiles_lists/debian.txt")"
        fi

        if [[ "$USER" == "marcin" ]]; then
            local full_username
            full_username=$(getent passwd "marcin" | cut -d ':' -f 5)

            if [[ "$full_username" =~ ^Marcin\ Kralka ]]; then
                dotfiles_to_copy="$dotfiles_to_copy $(cat "$HOME/.dotfiles_lists/private.txt")"

                if [[ -f /etc/debian_version ]]; then
                    dotfiles_to_copy="$dotfiles_to_copy $(cat "$HOME/.dotfiles_lists/private_debian.txt")"
                fi
            fi
        fi

        # Logic check: $dotfiles_to_copy must remain unquoted here to allow rsync to see multiple files
        rsync -ciRv $dotfiles_to_copy "$dotfiles_repo_dir"

        echo -e "\n=== Copying OS-specific dotfiles... ==="
        local os_specific_dotfiles_list
        os_specific_dotfiles_list="$(cat "$HOME/.dotfiles_lists/os_specific.txt")"
        local os_specific_repo_dir="$dotfiles_repo_dir/os_specific"

        mkdir -p "$os_specific_repo_dir"

        local entry
        local filename
        local final_name

        for entry in $os_specific_dotfiles_list; do
            filename="${entry}.1"

            if [[ -f "$filename" ]]; then
                final_name="${entry}.${short_name}"

                rsync -ciRv "$filename" "${os_specific_repo_dir}/${final_name}"
            fi
        done
    }

    update-dotfiles-repository () {
        local dotfiles_repo_dir="$HOME/repos/dotfiles"
        local exit_status

        # Clone repository if it doesn't exist.
        if [[ ! -d "$dotfiles_repo_dir" ]]; then
            clone-dotfiles-repository
        fi

        cd "$dotfiles_repo_dir"

        git pull
        exit_status=$?

        cd "$OLDPWD"

        if [[ $exit_status -ne 0 ]]; then
            echo -e "Error: Couldn't pull the latest commit in the dotfiles git repository!"
        fi

        return $exit_status
    }
fi


# Debian-specific shorthand
if [[ "$OS_NAME" == "Linux" && -f /etc/debian_version ]]; then
    edit-debian-sources() {
        if [[ -f /etc/apt/sources.list ]]; then
            edit-repos
        elif [[ -f /etc/apt/sources.list.d/debian.sources ]]; then
            edit-repos --file debian.sources
        else
            echo -e "Error: No sources found!"

            return 1
        fi
    }
fi
