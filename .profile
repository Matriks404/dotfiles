# 1. Start with the existing PATH to avoid losing system defaults (/sbin, etc.)
PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"

mkdir -p "$HOME/bin"
mkdir -p "$HOME/.local/bin"

#HACK: Ideally this should be an export, but it's not working properly on Debian 11.
OS_NAME="$(uname -s)"

# 2. OpenBSD Specifics
if [ "$OS_NAME" = "OpenBSD" ]; then
    PATH="/usr/X11R6/bin:/sbin:/usr/sbin:/usr/local/sbin:$PATH"
fi

# 3. Source .bashrc
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

# 4. Source Cargo (Usually prepends ~/.cargo/bin)
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# 5. Final flatpak override
if [ "$OS_NAME" = "Linux" ] && [ -x "$(command -v flatpak)" ]; then
    PATH="$HOME/.local/bin/flatpak-executables:$PATH"
fi

# 6. Load more things into the PATH
PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# 7. Depending on the shell export the appropriate ENV variable
case "$SHELL" in
    *ksh*)
        if [ -f "$HOME/.kshrc" ]; then
            export ENV="$HOME/.kshrc"
        else
            export ENV="$HOME/.shrc"
        fi
        ;;
    *)
        export ENV="$HOME/.shrc"
        ;;
esac

# 8. Export the rest of stuff
export PATH HOME TERM
