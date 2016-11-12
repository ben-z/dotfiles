[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

if [ -f $HOME/.bashrc ]
then
  . $HOME/.bashrc
fi  

if [ "$(command -v brew)" ] && [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

. ~/.nix-profile/etc/profile.d/nix.sh
