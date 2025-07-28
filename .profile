PATH=/bin:/usr/bin:/usr/local/bin:/usr/games:/usr/local/games

mkdir -p "$HOME/bin"
mkdir -p "$HOME/.local/bin"

OS_NAME="$(uname -s)"

if [ "$OS_NAME" == "OpenBSD" ]; then
    PATH="/usr/X11R6/bin:$PATH"
fi

if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

PATH="$HOME/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"

export HOME PATH TERM
