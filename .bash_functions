#Getting operating system name
OS_NAME=$(uname -s)

github_base_url=https://github.com/Matriks404/dotfiles
#os_target=$(cat $HOME/.dotfiles_os_target)

clone-dotfiles-repository ()
{
    local repos_dir=$HOME/repos
    local dotfiles_repo_dir=$HOME/repos/dotfiles

    # Return prematurely if dotfiles repository already exists.
    if [ -d $dotfiles_repo_dir ]; then
        return 1
    fi

    # Check if neccesary repostitories directory exists.
    if [ ! -d $repos_dir ]; then
        mkdir $repos_dir
    fi

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
            dotfiles_to_copy="$dotfiles_to_copy $HOME/.gitconfig $HOME/.reportbugrc"
        fi
    fi

    cp $dotfiles_to_copy $dotfiles_repo_dir

    echo -e "=== Copying Bash scripts... ==="
    local bin_files_to_copy="$HOME/bin/upgrade-all.sh $HOME/bin/upgrade-dotfiles-bootstrap.sh"
    local bin_files_dir=$dotfiles_repo_dir/bin

    if [ ! -d $bin_files_dir ]; then
        mkdir $bin_files_dir
    fi

    cp $bin_files_to_copy $bin_files_dir
}

edit-repos ()
{
    if [ -f /etc/debian_version ]; then
        if [ -f /etc/apt/sources.list ]; then
            sudo editor /etc/apt/sources.list
        else
            sudo editor /etc/apt/sources.list.d/debian.sources
        fi
    elif [ "$OS_NAME" == "OpenBSD" ]; then
        doas nano /etc/installurl
    fi
}

get-new-dotfiles ()
{
    $HOME/bin/upgrade-dotfiles-bootstrap.sh
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

upgrade-all ()
{
    if [ "$OS_NAME" == "Linux" ]; then
        sudo $HOME/bin/upgrade-all.sh
    elif [ "$OS_NAME" == "OpenBSD" ]; then
        doas $HOME/bin/upgrade-all.sh
    fi
}

# Linux-specific functions
if [ "$OS_NAME" == "Linux" ]; then
    wiki ()
    {
        local article=$1

        wikipedia2text "$article" | less
    }
fi
