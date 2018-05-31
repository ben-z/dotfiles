{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.my_prezto;

  zshVariables =
    mapAttrsToList (n: v: ''${n}="${v}"'') cfg.variables;

  fzfCompletion = ./fzf-completion.zsh;
  fzfGit = ./fzf-git.zsh;
  fzfHistory = ./fzf-history.zsh;

  zpreztorc = pkgs.writeText "zpreztorc"
    ''
      # Color output (auto set to 'no' on dumb terminals).
      zstyle ':prezto:*:*' color 'yes'
      # Set the Prezto modules to load (browse modules).
      # The order matters.
      zstyle ':prezto:load' pmodule \
        'environment' \
        'terminal' \
        'editor' \
        'history' \
        'directory' \
        'spectrum' \
        'utility' \
        'git' \
        'completion' \
        'prompt' \
        'fasd' \
        'ssh' \
        #'screen' \
      # Set the key mapping style to 'emacs' or 'vi'.
      zstyle ':prezto:module:editor' key-bindings 'vi'
      # Ignore submodules when they are 'dirty', 'untracked', 'all', or 'none'.
      #zstyle ':prezto:module:git:status:ignore' submodules 'all'
      # Set the prompt theme to load.
      # Setting it to 'random' loads a random theme.
      # Auto set to 'off' on dumb terminals.
      zstyle ':prezto:module:prompt' theme 'pure'
      # Set the SSH identities to load into the agent.
      zstyle ':prezto:module:ssh:load' identities 'id_rsa' 'id_rsa'
      # Auto set the tab and window titles.
      zstyle ':prezto:module:terminal' auto-title 'yes'
      # Set the window title format.
      zstyle ':prezto:module:terminal:window-title' format '%n@%m: %s'
      # Auto convert .... to ../..
      zstyle ':prezto:module:editor' dot-expansion 'yes'
      # -------------------------------------------------
      export EDITOR='${pkgs.neovim}/bin/nvim'
      export VISUAL='${pkgs.neovim}/bin/nvim'
      export PAGER='${pkgs.less}/bin/less -R'
      export KEYTIMEOUT=1
    '';
  zshenv = pkgs.writeText "zshenv-local"
    ''
      # DO NOT EDIT -- this file has been generated automatically.
      # This file is read for all shells.

      # Only execute this file once per shell.
      if [ -n "$__ETC_ZSHENV_LOCAL_SOURCED" ]; then return; fi
      __ETC_ZSHENV_LOCAL_SOURCED=1

      source ${pkgs.zsh-prezto}/runcoms/zshenv

      ${cfg.shellInit}
    '';
  zprofile = pkgs.writeText "zprofile-local"
    ''
      # DO NOT EDIT -- this file has been generated automatically.
      # This file is read for login shells.

      # Only execute this file once per shell.
      if [ -n "$__ETC_ZPROFILE_LOCAL_SOURCED" ]; then return; fi
      __ETC_ZPROFILE_LOCAL_SOURCED=1

      source ${pkgs.zsh-prezto}/runcoms/zprofile

      ${cfg.loginShellInit}
    '';
  zshrc = pkgs.writeText "zshrc-local"
    ''
      # DO NOT EDIT -- this file has been generated automatically.
      # This file is read for interactive shells.

      # Only execute this file once per shell.
      if [ -n "$__ETC_ZSHRC_LOCAL_SOURCED" ]; then return; fi
      __ETC_ZSHRC_LOCAL_SOURCED=1

      ${cfg.promptInit}

      source ${pkgs.zsh-prezto}/runcoms/zshrc

      ${optionalString cfg.enableCompletion "autoload -U compinit && compinit"}
      ${optionalString cfg.enableBashCompletion "autoload -U bashcompinit && bashcompinit"}

      ${optionalString cfg.enableSyntaxHighlighting
        "source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
      }

      ${optionalString cfg.enableFzfCompletion "source ${fzfCompletion}"}
      ${optionalString cfg.enableFzfGit "source ${fzfGit}"}
      ${optionalString cfg.enableFzfHistory "source ${fzfHistory}"}
    '';
in {
  options = {
    programs.my_prezto.enable = mkOption {
     type = types.bool;
     default = false;
     description = "Whether to configure zsh as an interactive shell.";
    };

    programs.my_prezto.variables = mkOption {
      type = types.attrsOf (types.either types.str (types.listOf types.str));
      default = {};
      description = ''
        A set of environment variables used in the global environment.
        These variables will be set on shell initialisation.
        The value of each variable can be either a string or a list of
        strings.  The latter is concatenated, interspersed with colon
        characters.
      '';
      apply = mapAttrs (n: v: if isList v then concatStringsSep ":" v else v);
    };

    programs.my_prezto.shellInit = mkOption {
      type = types.lines;
      default = "";
      description = "Shell script code called during zsh shell initialisation.";
    };

    programs.my_prezto.loginShellInit = mkOption {
      type = types.lines;
      default = "";
      description = "Shell script code called during zsh login shell initialisation.";
    };

    programs.my_prezto.interactiveShellInit = mkOption {
      type = types.lines;
      default = "";
      description = "Shell script code called during interactive zsh shell initialisation.";
    };

    programs.my_prezto.promptInit = mkOption {
      type = types.lines;
      default = "autoload -U promptinit && promptinit && prompt walters";
      description = "Shell script code used to initialise the zsh prompt.";
    };

    programs.my_prezto.enableCompletion = mkOption {
      type = types.bool;
      default = true;
      description = "Enable zsh completion for all interactive zsh shells.";
    };

    programs.my_prezto.enableBashCompletion = mkOption {
      type = types.bool;
      default = true;
      description = "Enable bash completion for all interactive zsh shells.";
    };

    programs.my_prezto.enableFzfCompletion = mkOption {
      type = types.bool;
      default = false;
      description = "Enable fzf completion.";
    };

    programs.my_prezto.enableFzfGit = mkOption {
      type = types.bool;
      default = false;
      description = "Enable fzf keybindings for C-g git browsing.";
    };

    programs.my_prezto.enableFzfHistory = mkOption {
      type = types.bool;
      default = false;
      description = "Enable fzf keybinding for Ctrl-r history search.";
    };

    programs.my_prezto.enableSyntaxHighlighting = mkOption {
      type = types.bool;
      default = false;
      description = "Enable zsh-syntax-highlighting.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      [
        pkgs.zsh-prezto
      ];

    # Pass on 2 variables to zsh
    programs.zsh = {
      enable = cfg.enable;
      variables = cfg.variables;
    };

    environment.etc =
      [ { source = "${pkgs.zsh-prezto}/runcoms/zlogin";
          target = "zlogin";
        }
        { source = "${pkgs.zsh-prezto}/runcoms/zlogout";
          target = "zlogout";
        }
        { source = zpreztorc;
          target = "zpreztorc";
        }
        { source = zprofile;
          target = "zprofile.local";
        }
        { source = zshenv;
          target = "zshenv.local";
        }
        { source = zshrc;
          target = "zshrc.local";
        }
    ];
  };
}
