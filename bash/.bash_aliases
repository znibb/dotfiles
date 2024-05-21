alias ..="cd .."
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias ls="ls -hN --color=auto --group-directories-first"
alias la="ls -a"
alias ll="ls -la"
alias grep="grep --color=auto"
alias psa="ps aux"
alias psg="psa | grep "
alias pdf="zathura --fork "
alias sshhosts="sed -rn 's/^\s*Host\s+(.*)\s*/\1/ip' ~/.ssh/config"
alias cfa='vim ~/.bash_aliases'
alias cfr='vim ~/.bashrc'
alias cft='vim ~/.tmux.conf'
alias tml='tmux ls'
alias tma='tmux attach -t '
alias tmn='tmux new -s '
alias tmr='tmux rename-session -t '
alias tmk='tmux kill-session -t '
