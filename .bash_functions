copy-dotfiles-to-repos-directory ()
{
    cp .bashrc .bash_aliases .bash_functions repos/dotfiles
}

get-new-dotfiles ()
{
    wget https://github.com/Matriks404/dotfiles/archive/refs/heads/opensuse.zip
    unzip -j opensuse.zip dotfiles-opensuse/.bash*
    rm opensuse.zip
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
