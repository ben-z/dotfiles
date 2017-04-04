{
  packageOverrides = pkgs_: with pkgs_; {
    my_vim = import ./vim-config { inherit pkgs; };

    all = with pkgs; buildEnv {
      name = "all";

      paths = [
        gitAndTools.hub
        silver-searcher
        my_vim
        zsh
        zsh-completions
        zsh-prezto
        ripgrep
      ];
    };
  };
}
