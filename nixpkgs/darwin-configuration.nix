{ config, lib, pkgs, ... }:

let
  zgen-zsh = ./zsh/zgen.zsh;
  zsh-autoload = ./zsh/autoload;
  my-nvim-plugins = pkgs.callPackage ./nvim/plugins.nix {};
  my-neovim = pkgs.neovim.override {
    withNodeJs = true;
    configure = {
      customRC = ''
        " Fzf
        let g:fzf_command_prefix = 'Fzf'
        " This is the default extra key bindings
        let g:fzf_action = {
          \ 'ctrl-t': 'tab split',
          \ 'ctrl-x': 'split',
          \ 'ctrl-v': 'vsplit' }
        nmap <silent> <C-p> :<c-u>FzfFiles<CR>
        nmap <C-j> :tabp<cr>
        nmap <C-k> :tabn<cr>

        " deoplete: enable when entering insert mode to speed up startup
        let g:deoplete#enable_at_startup = 0
        autocmd InsertEnter * call deoplete#enable()

        " <TAB>: completion.
        inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

        " automatic rustfmt on save.
	let g:rustfmt_autosave = 1

        " Maintain undo history between sessions
        set undofile
        set undodir=$HOME/.vim/undodir
      '';
      plug.plugins = with pkgs.vimPlugins // my-nvim-plugins; [
        vim-nix
        vim-javascript
        yats-vim # typescript syntax
        deoplete-nvim # async completion
        denite-nvim # async interfaces
        fzf-vim # ~12ms
        fzfWrapper
        rust-vim
        nvim-typescript
        vim-airline # ~70ms
        vim-lastplace # remember last cursor position, ~5ms
      ];
    };
  };
in
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.fzf
      pkgs.gnupg
      pkgs.ripgrep
      #pkgs.neovim
      pkgs.nodejs-10_x
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
      pkgs.fd
      pkgs.rustup
      my-neovim
    ];

  environment.systemPath = [
    "$HOME/.npm/bin"
  ];

  environment.variables = { EDITOR = "vim"; };

  environment.postBuild = ''
  '';

  environment.shellAliases.l = "ls -hl";
  environment.shellAliases.lsp = "lsof -i -n -P | grep LISTEN"; # List listening ports by current user
  environment.shellAliases.lspa = "sudo lsof -i -n -P | grep LISTEN"; # List listening ports by all users
  environment.shellAliases.dotfiles = "cd $HOME/Projects/dotfiles";
  environment.shellAliases.treenodoc = "tree -I 'node_modules|jsdoc|docs'";
  environment.shellAliases.pro = "cd $HOME/Projects";
  environment.shellAliases.g = "git";
  environment.shellAliases.gs = "git status";
  environment.shellAliases.gsh = "git stash";
  environment.shellAliases.gp = "git push";
  environment.shellAliases.gd = "git diff";
  environment.shellAliases.gc = "git commit";
  environment.shellAliases.gcm = "git commit -m";
  environment.shellAliases.gco = "git checkout";
  environment.shellAliases.vi = "nvim";

  system.activationScripts.postActivation.text = ''
    rm -f "$HOME/.zgen/init.zsh" # reset zgen
    echo "Deleted $HOME/.zgen/init.zsh"
  '';

  system.activationScripts.preActivation.text = ''
    rm -rf "${zsh-autoload}"/*
    # TODO: figure out how to make zsh-autoload a derivation
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
  system.defaults.NSGlobalDomain.AppleMeasurementUnits = "Centimeters";
  system.defaults.NSGlobalDomain.AppleMetricUnits = 1;
  system.defaults.NSGlobalDomain.AppleTemperatureUnit = "Celsius";

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
    promptInit = ""; # use zgen to load the prompt package (it's faster than promptinit)
    interactiveShellInit = ''
      # Turn on when measuring plugin performance
      # zmodload zsh/zprof

      HISTSIZE=10000
      SAVEHIST=10000

      bindkey -v # vi mode

      setopt autocd # auto cd when only path is entered
      setopt nomatch # throw an error on glob matching nothing

      fpath=($fpath "${zsh-autoload}")
      # autoload -Uz init_color_vars

      if [ -f "${zgen-zsh}" ]; then
        source "${zgen-zsh}" # ~25ms
      fi

      if [ -n "$(command -v zgen)" ]; then
        if ! zgen saved; then # TODO: auto invalidate on build
          echo "========== Creating a zgen save =========="

          # plugins
          zgen load zsh-users/zsh-autosuggestions # <10ms
          zgen load zdharma/fast-syntax-highlighting # ~20ms
          zgen load zsh-users/zsh-history-substring-search # ~5ms
          zgen oh-my-zsh plugins/shrink-path # ~2ms
          zgen load junegunn/fzf shell # ~2ms
          zgen load mafredri/zsh-async
          zgen load sindresorhus/pure

          #zgen oh-my-zsh plugins/tmux
          # save all to init script
          zgen save
        fi
      fi

      # vim undo dir
      mkdir -p $HOME/.vim/undodir
    '';
  };
  programs.nix-index.enable = true;

  programs.tmux = {
    enable = true;
    enableSensible = true;
    enableMouse = true;
    enableFzf = true;
    enableVim = true;
    tmuxConfig = ''
      set-option -g prefix2 M-Escape
      bind-key M-Escape send-prefix -2

      setw -g aggressive-resize off

      bind 0 set status
      bind S choose-session
      bind-key -r "<" swap-window -t -1
      bind-key -r ">" swap-window -t +1
      bind-key -n M-r run "tmux send-keys -t .+ C-l Up Enter"
      bind-key -n M-R run "tmux send-keys -t $(hostname -s | awk -F'-' '{print tolower($NF)}') C-l Up Enter"
      set -g status-bg black
      set -g status-fg white
      set -g status-right '#[fg=white]#(id -un)@#(hostname)   #(cat /run/current-system/darwin-version)'
    '';
  };
}
