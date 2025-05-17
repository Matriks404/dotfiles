copy-dotfiles-to-repos-directory ()
{
    cp .bashrc .bash_aliases .bash_functions .dotfiles_version repos/dotfiles
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
