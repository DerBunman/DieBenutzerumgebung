#!/usr/bin/env zsh
alias diu='docker images --format "{{.Repository}}:{{.Tag}}"  | grep -v "<none>" | sort | uniq | xargs -L1 docker pull'
alias d=docker
alias dc=docker-compose
