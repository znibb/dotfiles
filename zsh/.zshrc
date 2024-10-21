# Activate Starship
eval "$(starship init zsh)"

# Enable fzf keybindings
source /usr/share/doc/fzf/examples/key-bindings.zsh

# Enable fzf auto-completion
source /usr/share/doc/fzf/examples/completion.zsh

# Source aliases
[ -f $ZDOTDIR/.aliases ] && source $ZDOTDIR/.aliases
