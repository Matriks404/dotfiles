# IMPORTANT!
# .bashrc is originally taken from Debian GNU/Linux bookworm (12)
# and appropriate license applies.


# NOTE: On Debian GNU/Linux edit the file /etc/bash.bashrc and uncomment
# the code fragment which enables bash completion in interactive shells.


# If not running interactively, don't do anything.
case $- in
    *i*) ;;
      *) return;;
esac


# Set console language to English. See locale(7) for more info.
export LANG=en_US.UTF-8
export LANGUAGE=en_US


# Ignore duplicate lines in history.
HISTCONTROL=ignoredups

# Append to the history file, don't overwrite it.
shopt -s histappend

# Set history sizes.
HISTSIZE=10000
HISTFILESIZE=10000

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Enable "**" patern in a pathname expansion content, which will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Make less more friendly for non-text input files, see lesspipe(1)
[ $(command -v lesspipe) ] && eval "$(lesspipe)"

# Set variable identifying the chroot you work in.
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Enable terminal color output.
if [ $(command -v tput) ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
else
    color_prompt=
fi

# Set prompt.
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Enable color support of ls and also add handy aliases.
if [ $(command -v dircolors) ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'



# CUSTOM BASH ALIASES AND FUNCTIONS

# Dotfiles version alias
alias dotver='cat .dotfiles_version'


# Custom Bash functions

if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

# Custom Bash aliases

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


# Custom LOCAL Bash functions

if [ -f ~/.bash_local_functions ]; then
    . ~/.bash_local_functions
fi

# Custom LOCAL Bash aliases

if [ -f ~/.bash_local_aliases ]; then
    . ~/.bash_local_aliases
fi
