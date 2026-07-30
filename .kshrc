# If not running interactively, don't do anything.
#NOTE: I am not sure if this is needed, because there's already a check for that in .shrc, but it won't hurt, I guess.
case $- in
    *i*) ;;
      *) return;;
esac

# Load common shell stuff.
if [ -f "$HOME/.shrc" ]; then
    . "$HOME/.shrc"
fi

# Enable emacs mode
set -o emacs
