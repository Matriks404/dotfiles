# Shell aliases (should work on any Unix-like OS with Bash)
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cls='clear'
alias h='history'
alias q='exit'

# Aliases for GNU core utilities (could work on other implementations of coreutils as well)
alias l='ls -lh'
alias la='ls -Alh'
alias wf='tail -f'

# Aliases for Debian commands (might not be available if your're running non-Debian-based Linux distribution or they are not installed on your system)
alias a='aptitude'

# Aliases for other commands (might not be available on your system)
# NOTE: Comment-out man command alias if you want to have man pages in your system language.
alias man='LANG=en_US.UTF-8 man'
alias ii='ip addr'
alias pi='ping 8.8.8.8'
alias psx='ps aux'

# Aliases for git commands (you need to have git installed)
alias gitd='git diff'
alias gits='git status'

# More advanced aliases for system management
alias sysupd='sudo apt update && sudo apt upgrade && flatpak update'
