# Check version of the dotfiles
alias dotver='echo "r3-openbsd2 (built on 2025-05-16 20:09 -- 2025.05.16 20:52)"'

# Shell aliases (should work on any Unix-like OS with Bash)
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cls='clear'
alias h='history'
alias q='exit'

# Aliases for BSD core utilities
alias l='ls -hl'
alias la='LC_COLLATE="C" ls -Ahl

alias wf='tail -f'

# Aliases for other commands (might not be available on your system)
# NOTE: Comment-out man command alias if you want to have man pages in your system language.
alias e='nano'
alias se='su root -c "nano"'

alias man='LANG=en_US.UTF-8 man'
alias ii='ifconfig'
alias pi='ping 8.8.8.8'
alias psx='ps aux'

# Aliases for git commands (you need to have git installed)
alias gitd='git diff'
alias gits='git status'

# More advanced aliases for system management
alias sysupd='su root -c "syspatch" && su root -c "pkg_add -u"'
