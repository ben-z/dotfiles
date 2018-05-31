{ writeText, zsh-prezto, neovim, less }:

let
  fzfCompletion = ./fzf-completion.zsh;
  fzfGit = ./fzf-git.zsh;
  fzfHistory = ./fzf-history.zsh;

  zpreztorc = writeText "zpreztorc"
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
        #'fasd' \
        'ssh' \
        'screen' \
      # Set the key mapping style to 'emacs' or 'vi'.
      zstyle ':prezto:module:editor' key-bindings 'vi'
      # Ignore submodules when they are 'dirty', 'untracked', 'all', or 'none'.
      #zstyle ':prezto:module:git:status:ignore' submodules 'all'
      # Set the prompt theme to load.
      # Setting it to 'random' loads a random theme.
      # Auto set to 'off' on dumb terminals.
      zstyle ':prezto:module:prompt' theme 'sorin'
      # Set the SSH identities to load into the agent.
      zstyle ':prezto:module:ssh:load' identities 'id_rsa'
      # Auto set the tab and window titles.
      zstyle ':prezto:module:terminal' auto-title 'yes'
      # Set the window title format.
      zstyle ':prezto:module:terminal:window-title' format '%n@%m: %s'
      # Auto convert .... to ../..
      zstyle ':prezto:module:editor' dot-expansion 'yes'
      # -------------------------------------------------
      export EDITOR='${neovim}/bin/nvim'
      export VISUAL='${neovim}/bin/nvim'
      export PAGER='${less}/bin/less -R'
      export KEYTIMEOUT=1
    '';
  zprofile_local = writeText "zprofile.local"
    ''
      # DO NOT EDIT -- this file has been generated automatically.

      # Only execute this file once per shell.
      if [ -n "$__ETC_ZPROFILE_LOCAL_SOURCED" ]; then return; fi
      __ETC_ZPROFILE_LOCAL_SOURCED=1

      source ${zsh-prezto}/runcoms/zprofile
      echo "Completed loading zprofile!"

    '';
  zshenv_local = writeText "zshenv.local"
    ''
      # DO NOT EDIT -- this file has been generated automatically.

      # Only execute this file once per shell.
      if [ -n "$__ETC_ZSHENV_LOCAL_SOURCED" ]; then return; fi
      __ETC_ZSHENV_LOCAL_SOURCED=1

      source ${zsh-prezto}/runcoms/zshenv
      echo "Completed loading zshenv!"

    '';
  zshrc_local = writeText "zshrc.local"
    ''
      # DO NOT EDIT -- this file has been generated automatically.

      # Only execute this file once per shell.
      if [ -n "$__ETC_ZSHRC_LOCAL_SOURCED" ]; then return; fi
      __ETC_ZSHRC_LOCAL_SOURCED=1

      source ${zsh-prezto}/runcoms/zshrc

      source ${fzfCompletion}
      source ${fzfGit}
      source ${fzfHistory}

      echo "Completed loading zshrc!"
    '';
in {
  environment_etc =
    [ { source = "${zsh-prezto}/runcoms/zlogin";
        target = "zlogin";
      }
      { source = "${zsh-prezto}/runcoms/zlogout";
        target = "zlogout";
      }
      { source = zpreztorc;
        target = "zpreztorc";
      }
      { source = zprofile_local;
        target = "zprofile.local";
      }
      { source = zshenv_local;
        target = "zshenv.local";
      }
      { source = zshrc_local;
        target = "zshrc.local";
      }
    ];
}
