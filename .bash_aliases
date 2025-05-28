# Getting operating system name
OS_NAME=$(uname -s)


# Shell aliases
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cls='clear'
alias h='history'
alias q='exit'


# Aliases for core utilities

alias copy='cp'
alias dotver='cat .dotfiles_version'
alias wf='tail -f'


# diskfree alias

if [ "$OS_NAME" == "Linux" ]; then
    alias diskfree='df -hT -x efivarfs -x tmpfs -x devtmpfs'
elif [ "$OS_NAME" == "OpenBSD" ]; then
    alias diskfree='df -t ffs'
fi


# ls aliases

# Important note: On Debian GNU/Linux these aliases don't display group names,
# but on OpenBSD these don't show user names instead
# since OpenBSD implementation of `ls` doesn't support that option. 

if [ $(command -v dircolors) ]; then
    alias ls='LC_COLLATE=C ls -F --color=auto'
else
    alias ls='LC_COLLATE=C ls -F'
fi

if [ "$OS_NAME" == "Linux" ]; then
    alias ls_g='ls --group-directories-first'

    alias l='ls -ho --time-style long-iso'
    alias l_g='l --group-directories-first'

    alias la='ls -Aho --time-style long-iso'
    alias la_g='la --group-directories-first'
elif [ "$OS_NAME" == "OpenBSD" ]; then
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
    editor='editor'
elif [ "$OS_NAME" == "OpenBSD" ]; then
    superuser_cmd='doas'
    editor='nano'
fi

alias e="$editor"
alias se="$superuser_cmd $editor"

alias ebaliases="$editor ~/.bash_aliases"
alias ebfunctions="$editor ~/.bash_functions"

alias eblaliases="$editor ~/.bash_local_aliases"
alias eblfunctions="$editor ~/.bash_local_functions"


# Aliases for system commands

if [ "$OS_NAME" == "Linux" ]; then
    alias ii='ip addr'
elif [ "$OS_NAME" == "OpenBSD" ]; then
    alias ii='ifconfig'
fi

alias pi='ping 8.8.8.8'
alias psx='ps aux'


# Aliases for git commands

if [ $(command -v git) ]; then
    alias gitd='git diff'
    alias gits='git status'
fi
