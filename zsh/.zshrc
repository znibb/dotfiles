# Path to your Oh My Zsh installation.
export ZSH="$ZDOTDIR/ohmyzsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

HISTFILE="$ZDOTDIR/.zsh_history"
HIST_STAMPS="yyyy-mm-dd"

# Activate Starship
eval "$(starship init zsh)"

# Source aliases
[ -f $ZDOTDIR/.aliases ] && source $ZDOTDIR/.aliases
