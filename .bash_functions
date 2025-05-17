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

    cp $HOME/.bashrc $HOME/.bash_aliases $HOME/.bash_functions $HOME/.dotfiles_version $dotfiles_repo_dir
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
    wget https://github.com/Matriks404/dotfiles/archive/refs/heads/debian.zip
    unzip -j debian.zip dotfiles-debian/.*
    rm debian.zip
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
