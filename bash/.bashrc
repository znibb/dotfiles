stty -ixon # Enablels Ctrl+s/Ctrl+Q to be interpreted as flow control

# Exclude lines starting with a space from history
HISTCONTROL=ignorespace

# Set history size (lines)
HISTSIZE=1000

# Append to history file, don't overwrite it
shopt -s histappend

# Update LINES and COLUMNS after each command
shopt -s checkwinsize

# Allow usage of "**" in pathname to match all files and (sub)directories
shopt -s globstar

# Improve less usage for non-text input files with lesspipe
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Setting Bash prompt. Capitalizes username and host if root user (my root user uses this same config file).
if [ "$EUID" -ne 0 ]
	then export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"
	else export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]ROOT\[$(tput setaf 2)\]@\[$(tput setaf 4)\]$(hostname | awk '{print toupper($0)}') \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"
fi

# Source aliases
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases

# Pretty prompt via synth-shell-prompt.sh
if [[ -f ~/.config/synth-shell/synth-shell-prompt.sh ]] && [[ -n "$( echo $- | grep i )" ]]; then
	source ~/.config/synth-shell/synth-shell-prompt.sh
fi
