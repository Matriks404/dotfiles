PATH=/bin:/usr/bin:/usr/local/bin:/usr/games:/usr/local/games

mkdir -p "$HOME/bin"
mkdir -p "$HOME/.local/bin"

#HACK: Ideally this should be an export, but it's not working properly on Debian 11.
OS_NAME="$(uname -s)"

if [ "$OS_NAME" == "OpenBSD" ]; then
    PATH="/usr/X11R6/bin:/sbin:/usr/sbin:/usr/local/sbin:$PATH"
fi

if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

PATH="$PATH:$HOME/bin:$HOME/.local/bin"

if [ "$OS_NAME" == "Linux" -a $(command -v flatpak) ]; then
    PATH="$PATH:$HOME/.local/bin/flatpak-executables"
fi

export ENV="$HOME/.shrc"
export HOME PATH TERM
