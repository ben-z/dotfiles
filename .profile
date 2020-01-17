export N_PREFIX=$HOME/.n
export PATH=$PATH:$HOME/.n/bin
export PATH=$PATH:$HOME/Library/Python/3.7/bin

alias l='ls -hl';
alias lsp='lsof -i -n -P | grep LISTEN'; # List listening ports by current user
alias lspa='sudo lsof -i -n -P | grep LISTEN'; # List listening ports by all users
alias dotfiles='cd $HOME/Projects/dotfiles';
alias treenodoc='tree -I "node_modules|jsdoc|docs"';
alias pro='cd $HOME/Projects';
alias g='git';
alias gs='git status';
alias gsh='git stash';
alias gp='git push';
alias gd='git diff';
alias gc='git commit';
alias gcm='git commit -m';
alias gco='git checkout';
alias vi='nvim';
alias mkvenv='python3 -m venv .$(basename $(pwd))-venv';
alias activate='source .$(basename $(pwd))-venv/bin/activate';

function gi() { curl -sLw n https://www.gitignore.io/api/$@ ;}
