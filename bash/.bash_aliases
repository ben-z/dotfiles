shopt -s expand_aliases  

alias lsp='lsof -i -n -P | grep LISTEN' # List listening ports by current user
alias lspa='sudo lsof -i -n -P | grep LISTEN' # List listening ports by all users
alias packants='cd ~/Documents/packants'
alias packantsapi='cd ~/Documents/packants/API'
alias packantslanding='cd ~/Documents/packants/landing-pages'
alias packantsportal='cd ~/Documents/packants/portal'
alias l="ls -la"
alias dotfiles="cd ~/Documents/dotfiles"
alias treenodoc="tree -I 'node_modules|jsdoc|docs'"

mysqlcli() {
  docker run -it --link $1:mysql --rm mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'
}

