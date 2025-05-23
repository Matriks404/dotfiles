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

    cp $HOME/.bashrc $HOME/.bash_aliases $HOME/.bash_functions $HOME/.dotfiles* $dotfiles_repo_dir
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
    wget $github_base_url/archive/refs/heads/$os_target.zip
    unzip -j $os_target.zip dotfiles-$os_target/.*
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

wiki ()
{
    local article=$1

    wikipedia2text "$article" | less
}
