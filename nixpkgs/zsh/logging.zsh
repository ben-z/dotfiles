_set_up_colors() {
  if [ -z "$__COLOR_VARS_INITIALIZED" ]; then init_color_vars; fi
}
#
# Headers and  Logging
#

e_header() {
  _set_up_colors \
  && printf "\n${bold}${purple}==========  %s  ==========${reset}\n" "$@" 
}
e_arrow() {
  _set_up_colors \
  && printf "➜ $@\n"
}
e_success() {
  _set_up_colors \
  && printf "${green}✔ %s${reset}\n" "$@"
}
e_error() {
  _set_up_colors \
  && printf "${red}✖ %s${reset}\n" "$@"
}
e_warning() {
  _set_up_colors \
  && printf "${tan}➜ %s${reset}\n" "$@"
}
e_underline() {
  _set_up_colors \
  && printf "${underline}${bold}%s${reset}\n" "$@"
}
e_bold() {
  _set_up_colors \
  && printf "$\bold}%s${reset}\n" "$@"
}
e_note() {
  _set_up_colors \
  && printf "${underline}${bold}${blue}Note:${reset}  ${blue}%s${reset}\n" "$@"
}

