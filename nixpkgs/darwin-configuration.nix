{ config, lib, pkgs, ... }:

let
  zgen-zsh = ./zsh/zgen.zsh;
  zsh-logging = ./zsh/logging.zsh;
  zsh-autoload = ./zsh/autoload;
  zsh-spaceship-prompt = ./zsh/spaceship-prompt;
in
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.fzf
      pkgs.gnupg
      #pkgs.ripgrep
      pkgs.neovim
      #pkgs.nodejs-10_x
      #pkgs.qemu
      #pkgs.aws
      #pkgs.gdb
      pkgs.git
      #pkgs.fswatch
      #pkgs.pkgconfig
      #pkgs.gettext
      #pkgs.gitAndTools.bfg-repo-cleaner
      #pkgs.wget
      #pkgs.docker
      #pkgs.docker-machine
      #pkgs.docker-machine-xhyve
      #pkgs.cdecl # Explains c declarations (cdecl explain "const struct S** s")
      #pkgs.texlive.combined.scheme-full
      #pkgs.emacs
      #myHunspell
      #pkgs.dos2unix
      #pkgs.tmux
      #pkgs.reattach-to-user-namespace
      #pkgs.nodePackages.relaxedjs
      #pkgs.tmux #TODO Use zsh
      pkgs.coreutils-prefixed
      pkgs.fira-code
      pkgs.tree
      pkgs.jq
    ];

  environment.systemPath = [
  ];

  environment.variables = { EDITOR = "vim"; };

  environment.postBuild = ''
  '';

  environment.shellAliases.lsp = "lsof -i -n -P | grep LISTEN"; # List listening ports by current user
  environment.shellAliases.lspa = "sudo lsof -i -n -P | grep LISTEN"; # List listening ports by all users
  environment.shellAliases.dotfiles = "cd ~/Projects/dotfiles";
  environment.shellAliases.treenodoc = "tree -I 'node_modules|jsdoc|docs'";
  environment.shellAliases.pro = "cd ~/Projects";
  environment.shellAliases.g = "git";
  environment.shellAliases.gs = "git stash";
  environment.shellAliases.gp = "git push";
  environment.shellAliases.gd = "git diff";

  system.activationScripts.postActivation.text = ''
    rm -f "$HOME/.zgen/init.zsh" # reset zgen
    echo "Deleted $HOME/.zgen/init.zsh"
  '';

  system.activationScripts.preActivation.text = ''
    ln -sf "${zsh-spaceship-prompt}"/spaceship.zsh "${zsh-autoload}"/prompt_spaceship_setup # allow zsh to use the spaceship theme
    echo 'Created symlink: "${zsh-spaceship-prompt}"/spaceship.zsh -> "${zsh-autoload}"/prompt_spaceship_setup'
  '';

  nix.nixPath =
  [ # Use local nixpkgs checkout instead of channels.
    "darwin-config=$HOME/.nixpkgs/darwin-configuration.nix"
    "darwin=$HOME/Projects/nix-darwin"
    "nixpkgs=$HOME/Projects/nixpkgs"
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = false;
  nix.package = pkgs.nix;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 3;

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 4;
  nix.buildCores = 4;

  system.defaults.dock.orientation = "right";

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.trackpad.ActuationStrength = 0; # silent clicking
  system.defaults.trackpad.FirstClickThreshold = 0; # light clicking
  system.defaults.trackpad.SecondClickThreshold = 0; # light force touch
  system.defaults.NSGlobalDomain."com.apple.trackpad.scaling" = "2"; # faster tracking

  # Fonts
  fonts = {
    enableFontDir = true;
    fonts = [ pkgs.fira-code ];
  };

  # Shell
  programs.bash.enable = false;
  programs.zsh = {
    enable = true;
    enableCompletion = false; # too slow, we'll manully manage this
    promptInit = "autoload -U promptinit && promptinit && prompt spaceship";
    interactiveShellInit = ''
      # Turn on when measuring plugin performance
      # zmodload zsh/zprof

      HISTSIZE=10000
      SAVEHIST=10000

      bindkey -v # vi mode

      setopt autocd # auto cd when only path is entered
      setopt nomatch # throw an error on glob matching nothing

      fpath=($fpath "${zsh-autoload}")
      autoload -Uz init_color_vars

      if [ -f "${zgen-zsh}" ]; then
        source "${zgen-zsh}" # ~25ms
      fi

      if [ -f "${zsh-logging}" ]; then
        source "${zsh-logging}"
      fi

      if [ -n "$(command -v zgen)" ]; then
        if ! zgen saved; then # TODO: auto invalidate on build
          e_header "Creating a zgen save"

          # plugins
          zgen load zsh-users/zsh-autosuggestions # <10ms
          zgen load zdharma/fast-syntax-highlighting # ~20ms
          zgen load zsh-users/zsh-history-substring-search # ~5ms
          zgen oh-my-zsh plugins/shrink-path # ~2ms
          zgen load junegunn/fzf shell # ~2ms
          #zgen oh-my-zsh plugins/tmux
          # save all to init script
          zgen save
        fi
      fi
    '';
  };
  programs.nix-index.enable = true;
}
