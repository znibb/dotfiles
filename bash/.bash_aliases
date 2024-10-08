# Alert wrapper
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# File system traversal/usage
alias ..='cd ..'
alias ls='ls -hN --color=auto --group-directories-first'
alias la='ls -ah --color=auto --group-directories-first'
alias ll='ls -lah --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias psa='ps aux'
alias psg='psa | grep -v grep | grep '

# Config shortcuts
alias cfa='vim ~/.bash_aliases'
alias cfr='vim ~/.bashrc'
alias cft='vim ~/.tmux.conf'
alias cfv='vim ~/.vimrc'

# Docker
alias dc='docker compose'
alias dcr='docker compose up -d --force-recreate'
alias dcl='docker compose logs -f'

# Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gp='git pull'
alias gP='git push'
alias lg='lazygit'

# Tmux
alias tml='tmux ls'
alias tma='tmux attach -t '
alias tmn='tmux new -s '
alias tmr='tmux rename-session -t '
alias tmk='tmux kill-session -t '

# Other
alias pdf='zathura --fork '
alias sshhosts="sed -rn 's/^\s*Host\s+(.*)\s*/\1/ip' ~/.ssh/config"

# Helper functions
mcd () {
	mkdir -v "$1"
	cd "$1"
}
