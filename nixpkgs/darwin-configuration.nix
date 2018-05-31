{ config, lib, pkgs, ... }:

{
  imports = [
    ./my_prezto
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.nix-repl
      pkgs.fzf
      pkgs.gnupg
      pkgs.ripgrep
      pkgs.neovim
      pkgs.nodejs-9_x
      pkgs.go
    ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 3;

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 4;
  nix.buildCores = 4;

  system.defaults.dock.orientation = "right";

  # Shell
  programs.bash.enable = false;
  programs.my_prezto = {
    enable = true;
    enableFzfCompletion = true;
    enableFzfGit = true;
    enableFzfHistory = true;
    enableSyntaxHighlighting = true;
    shellInit =
      ''
        # fasd
        alias a='fasd -a'        # any
        alias s='fasd -si'       # show / search / select
        alias d='fasd -d'        # directory
        alias f='fasd -f'        # file
        alias sd='fasd -sid'     # interactive directory selection
        alias sf='fasd -sif'     # interactive file selection
        alias z='fasd_cd -d'     # cd, same functionality as j in autojump
        alias zz='fasd_cd -d -i' # cd with interactive selection
        alias v='f -e vim' # quick opening files with vim

        # hub
        alias git=hub
      '';

    # environment variables
    variables = {
      PATH = "$HOME/Projects/my_bin_files:$PATH";
    };
  };
}
