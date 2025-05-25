# Getting operating system name
OS_NAME=$(uname -s)

# Shell aliases (should work on any Unix-like OS with Bash)
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cls='clear'
alias h='history'
alias q='exit'

# Aliases for GNU core utilities (could work on other implementations of coreutils as well)
alias dotver='cat .dotfiles_version'

# diskfree alias
if [ "$OS_NAME" == "Linux" ]; then
    alias diskfree='df -hT -x efivarfs -x tmpfs -x devtmpfs'
elif [ "$OS_NAME" == "openBSD" ]; then
    alias diskfree='df -t ffs'
fi

# ls aliases
# Important note: On Debian GNU/Linux these aliases don't display group names,
# but on OpenBSD these don't show user names instead
# since OpenBSD implementation of `ls` doesn't support that option. 

if [ "$OS_NAME" == "Linux" ]; then
    alias ls_g='ls --group-directories-first'

    alias l='ls -Fho --time-style long-iso'
    alias l_g='l --group-directories-first'

    alias la='LC_COLLATE="C" ls -AFho --time-style long-iso'
    alias la_g='la --group-directories-first'
elif [ "$OS_NAME" == "OpenBSD" ]; then
    alias l='ls -FghT'
    alias la='LC_COLLATE="C" ls -AFghT'
fi

alias wf='tail -f'

# Aliases for Debian commands
if [ -f /etc/debian_version ]; then
    alias a='aptitude'

    alias aptff='apt-file find'
    alias aptfl='apt-file list'

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

# Other aliases
# NOTE: Comment-out man command alias if you want to have man pages in your system language.
alias man='LANG=en_US.UTF-8 man'

if [ "$OS_NAME" == "Linux" ]; then
    alias ii='ip addr'
elif [ "$OS_NAME" == "OpenBSD" ]; then
    alias ii='ifconfig'
fi

alias pi='ping 8.8.8.8'
alias psx='ps aux'

# Aliases for git commands (you need to have git installed)
alias gitd='git diff'
alias gits='git status'
