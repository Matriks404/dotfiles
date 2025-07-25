# Getting operating system name
OS_NAME=$(uname -s)


# Shell aliases
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cls='clear'
alias h='history'


# Aliases for core utilities

alias copy='cp'
alias rmbaks='rm -f .*.bak* *.bak*'
alias wf='tail -f'


# diskfree alias

if [ "$OS_NAME" == "Linux" ]; then
    alias diskfree='df -hT -x efivarfs -x tmpfs -x devtmpfs'
elif [ "$OS_NAME" == "OpenBSD" ]; then
    alias diskfree='df -t ffs'
fi

# free alias
if [ "$OS_NAME" == "Linux" ]; then
    alias free='free -mtw'
elif [ "$OS_NAME" == "OpenBSD" ]; then
    alias free='free -m'
fi

# ls aliases

# Important note: On Debian GNU/Linux these aliases don't display group names,
# but on OpenBSD these don't show user names instead
# since OpenBSD implementation of `ls` doesn't support that option. 

if [ $(command -v dircolors) ]; then
    ls_base='LC_COLLATE=C ls -F --color=auto'
else
    ls_base='LC_COLLATE=C ls -F'
fi

if [ "$OS_NAME" == "Linux" ]; then
    alias ls="$ls_base --group-directories-first --time-style=long-iso"
    alias l='ls -ho'
    alias la='ls -Aho'
elif [ "$OS_NAME" == "OpenBSD" ]; then
    alias ls="$ls_base"
    alias l='ls -ghT'
    alias la='ls -AghT'
fi


# Aliases for Debian commands

if [ -f /etc/debian_version ]; then
    alias a='aptitude'

    alias aptff='apt-file find'
    alias aptfl='apt-file list'

    alias aptl='apt list'
    alias apts='apt-cache search'
fi


# Aliases for editor commands

if [ "$OS_NAME" == "Linux" ]; then
    superuser_cmd='sudo'
elif [ "$OS_NAME" == "OpenBSD" ]; then
    superuser_cmd='doas'
fi

alias e="$EDITOR"
alias se="$superuser_cmd $EDITOR"

alias ebaliases="$EDITOR ~/.bash_aliases && backup-file ~/.bash_aliases"
alias ebfunctions="$EDITOR ~/.bash_functions && backup-file ~/.bash_functions"

alias eblaliases="$EDITOR ~/.bash_local_aliases"
alias eblfunctions="$EDITOR ~/.bash_local_functions"


# Aliases for X11 applications

alias uxterm='xterm -class UXTerm'

# Aliases for system commands

if [ "$OS_NAME" == "Linux" ]; then
    alias ii='ip addr'

    alias reb='systemctl reboot'
    alias shut='systemctl poweroff'
elif [ "$OS_NAME" == "OpenBSD" ]; then
    alias ii='ifconfig'

    alias reb='doas shutdown -r now'
    alias shut='doas shutdown -p now'
fi

alias pi='ping 8.8.8.8'
alias psx='ps aux'


# Aliases for git commands

if [ $(command -v git) ]; then
    alias gitd='git diff'
    alias gits='git status'
fi


# Aliases for .bash_functions

alias dotverc='check-dotfiles-update'
alias man='get-manual'
alias sus='su-update-software'
alias susg='su-upgrade-system'

if [ "$OS_NAME" = "Linux" ]; then
    alias us='update-software'
fi
