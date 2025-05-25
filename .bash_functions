github_base_url=https://github.com/Matriks404/dotfiles
os_target=$(cat $HOME/.dotfiles_os_target)

clone-dotfiles-repository ()
{
    local repos_dir=$HOME/repos
    local dotfiles_repo_dir=$HOME/repos/dotfiles

    # Return prematurely if dotfiles repository already exists.
    if [ -d $repos_dir ]; then
        return 1
    fi

    # Check if neccesary repostitories directory exists.
    if [ ! -d $repos_dir ]; then
        mkdir $repos_dir
    fi

    git clone --branch $os_target $github_base_url.git $dotfiles_repo_dir
}

copy-dotfiles-to-repos-directory ()
{
    local repos_dir=$HOME/repos
    local dotfiles_repo_dir=$HOME/repos/dotfiles

    # Check if neccessary directories exist.
    if [ ! -d $dotfiles_repo_dir ]; then
        if [ ! -d $repos_dir ]; then
            mkdir $repos_dir
        fi

        mkdir $dotfiles_repo_dir
    fi

    local dotfiles_to_copy="$HOME/.bashrc $HOME/.bash_aliases $HOME/.bash_functions $HOME/.dotfiles*"
    cp $dotfiles_to_copy $dotfiles_repo_dir

    local bin_files_to_copy=$HOME/bin/upgrade-all.sh
    local bin_files_dir=$dotfiles_repo_dir/bin

    if [ ! -d $bin_files_dir ]; then
        mkdir $bin_files_dir
    fi

    cp $bin_files_to_copy $bin_files_dir
}

edit-repos ()
{
    if [ -f /etc/apt/sources.list ]; then
        sudo editor /etc/apt/sources.list
    else
        sudo editor /etc/apt/sources.list.d/debian.sources
    fi
}

get-new-dotfiles ()
{
    # Download and unzip archive containing dotfiles and scripts.
    local dotfiles_dir=dotfiles-$os_target
    wget $github_base_url/archive/refs/heads/$os_target.zip
    unzip $os_target.zip -x $dotfiles_dir/README.md

    # Boostrap the script that upgrades dotfiles.
    $dotfiles_dir/build/upgrade-dotfiles.sh

    # Cleanup.
    rm $dotfiles_dir/build/upgrade-dotfiles.sh
    rmdir --parents $dotfiles_dir/build
    rm $os_target.zip
}

get-repos ()
{
    if [ -f /etc/apt/sources.list ]; then
        cat /etc/apt/sources.list
    else
        cat /etc/apt/sources.list.d/debian.sources
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
    sudo $HOME/bin/upgrade-all.sh
}

wiki ()
{
    local article=$1

    wikipedia2text "$article" | less
}
