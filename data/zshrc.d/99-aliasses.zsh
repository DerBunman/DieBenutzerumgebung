test -f "$(which colordiff)"
[ $? -eq 0 ] && alias diff="colordiff"

alias ls='LC_COLLATE=C ls -A --color -h --group-directories-first'
alias t="todo-txt -c -t"
alias ip='ip -c'
alias pcp="rsync --progress -a "
alias tmux="tmux attach || tmux"

alias screenshot="import png:- | xclip -selection c -t image/png"

alias vim-companion="tmux attach -t vim-companion || tmux new-session -s vim-companion"
