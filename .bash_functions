copy-dotfiles-to-repos-directory ()
{
    cp .bashrc .bash_aliases .bash_functions repos/dotfiles
}

get-new-dotfiles ()
{
    wget https://github.com/Matriks404/dotfiles/archive/refs/heads/debian.zip
    unzip -j debian.zip dotfiles-debian/.bash*
    rm debian.zip
}

git-commit ()
{
    local comment=$1

    git add .
    git commit "$comment"
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
