#Getting operating system name
OS_NAME=$(uname -s)

github_repo=Matriks404/dotfiles
github_base_url=https://github.com/$github_repo
#os_target=$(cat $HOME/.dotfiles_os_target)

check-dotfiles-update ()
{
    url="https://raw.githubusercontent.com/$github_repo/refs/heads/master/.dotfiles_version"

    current_version="$(dotver | cut -d ' ' -f 1)"
    latest_version="$(curl -s $url | cut -d ' ' -f 1)"

    if [ "$current_version" = "$latest_version" ]; then
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
    local repos_dir=$HOME/repos
    local dotfiles_repo_dir=$HOME/repos/dotfiles

    # Clone dotfiles repository if it doesn't exist.
    if [ ! -d $dotfiles_repo_dir ]; then
        echo -e "=== Cloning the dotfiles repository, because it doesn't exist yet... ==="
        clone-dotfiles-repository
    fi

    echo -e "=== Copying dotfiles... ==="
    local dotfiles_to_copy="$HOME/.bashrc $HOME/.bash_aliases $HOME/.bash_functions $HOME/.bash_logout $HOME/.dotfiles*"

    if [ "$USER" == "marcin" ]; then
        full_username=$(getent passwd "marcin" | cut -d ':' -f 5)

        if [[ "$full_username" =~ ^Marcin\ Kralka ]]; then
            dotfiles_to_copy="$dotfiles_to_copy $HOME/.gitconfig"

            if [ -f /etc/debian_version ]; then
                dotfiles_to_copy="$dotfiles_to_copy $HOME/.reportbugrc"
            fi
        fi
    fi

    cp $dotfiles_to_copy $dotfiles_repo_dir

    echo -e "=== Copying Bash scripts... ==="
    # Files and directories that begin with symbols such as _ won't be copied.
    # As an example you can use "_LOCAL_<rest of the name>" for local-only files and directories.
    local bin_files_to_copy="$HOME/.local/bin/[0-9a-zA-Z]*.sh"
    local bin_files_repo_dir=$dotfiles_repo_dir/.local/bin

    mkdir -p $bin_files_repo_dir
    cp $bin_files_to_copy $bin_files_repo_dir
}

edit-repos ()
{
    if [ -f /etc/debian_version ]; then
        if [ -f /etc/apt/sources.list ]; then
            sudo $EDITOR /etc/apt/sources.list
        else
            sudo $EDITOR /etc/apt/sources.list.d/debian.sources
        fi
    elif [ "$OS_NAME" == "OpenBSD" ]; then
        doas $EDITOR /etc/installurl
    fi
}

get-new-dotfiles ()
{
    FORCE_UPDATE=false

    if [ "$1" == "-f" -o "$1" == "--force" ]; then
        FORCE_UPDATE=true
    fi

    if $FORCE_UPDATE || check-dotfiles-update; then
        echo -e "\nGetting new dotfiles..."

        repo_name='Matriks404/dotfiles'

        curl -s "https://raw.githubusercontent.com/$repo_name/refs/heads/master/build/update.sh" | sh
    else
        echo -e "\nThere is no need to update dotfiles."
    fi
}

get-repos ()
{
    if [ -f /etc/debian_version ]; then
        if [ -f /etc/apt/sources.list ]; then
            cat /etc/apt/sources.list
        else
            cat /etc/apt/sources.list.d/debian.sources
        fi
    elif [ "$OS_NAME" == "OpenBSD" ]; then
        cat /etc/installurl
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

if [ "$OS_NAME" == "Linux" -o "$OS_NAME" == "OpenBSD" ]; then
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
fi

# Linux-specific functions
if [ "$OS_NAME" == "Linux" ]; then
    wiki ()
    {
        local article=$1

        wikipedia2text "$article" | less
    }
fi
