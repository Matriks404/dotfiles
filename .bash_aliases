# Shell aliases (should work on any Unix-like OS with Bash)
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cls='clear'
alias h='history'
alias q='exit'

# Aliases for GNU core utilities (could work on other implementations of coreutils as well)
alias dotver='cat .dotfiles_version'
alias diskfree='df -hT -x efivarfs -x tmpfs -x devtmpfs'

alias ls_g='ls --group-directories-first'

alias l='ls -ho --time-style long-iso'
alias l_g='l --group-directories-first'

alias la='LC_COLLATE="C" ls -Aho --time-style long-iso'
alias la_g='la --group-directories-first'

alias wf='tail -f'

# Aliases for Debian commands (might not be available if your're running non-Debian-based Linux distribution or they are not installed on your system)
alias a='aptitude'

alias aptff='apt-file find'
alias aptfl='apt-file list'

alias apts='apt-cache search'

# Aliases for other commands (might not be available on your system)
alias e='editor'
alias se='sudo editor'

alias ebaliases='editor ~/.bash_aliases'
alias ebfunctions='editor ~/.bash_functions'

alias eblaliases='editor ~/.bash_local_aliases'
alias eblfunctions='editor ~/.bash_local_functions'

# NOTE: Comment-out man command alias if you want to have man pages in your system language.
alias man='LANG=en_US.UTF-8 man'
alias ii='ip addr'
alias pi='ping 8.8.8.8'
alias psx='ps aux'

# Aliases for git commands (you need to have git installed)
alias gitd='git diff'
alias gits='git status'

# More advanced aliases for system management
alias sysupd='sudo upgrade-system && flatpak update'
