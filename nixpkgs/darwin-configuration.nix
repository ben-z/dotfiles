{ config, lib, pkgs, ... }:

{
  imports = [
    ./my_zsh
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.nix-repl
      pkgs.fzf
      pkgs.gnupg
      pkgs.ripgrep
      pkgs.neovim
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

  programs.my_zsh.enable = true;
}
