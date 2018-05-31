{
  packageOverrides = pkgs_: with pkgs_; {
    my_vim = import ./vim-config { inherit pkgs; };

    all = with pkgs; buildEnv {
      name = "all";

      paths = [
        gitAndTools.hub
        my_vim
        ripgrep
        zsh
        zsh-completions
        zsh-prezto
        nix-zsh-completions
        jq # Commandline json processor
        nodejs-8_x
      ];
    };
  };
}
