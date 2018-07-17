#!/bin/bash

# Release the Unicorn!

# 1. Install nix
# 2. Install nix-darwin
# 3. Clone dotfiles
# 4. Link dotfiles
# 5. Install applications
#   5.1 Little Snitch
#   5.2 Bartender
#   5.3 Paste
#   5.4 Amethyst
#   5.5 iTerm - apply solarized theme from this repo
#   5.6 1Password
#   5.7 Hammerspoon - configuration in this repo
#   5.7 Chrome
#   5.8 Spark
#   5.9 Things
# 6. change Screenshot folder location `defaults write com.apple.screencapture [location]`


if ! [ -x "$(command -v nix-env)" ]; then
  echo 'Nix has not been installed! Install it with `curl https://nixos.org/nix/install | sh`' >&2
  exit 1
fi

# TODO
