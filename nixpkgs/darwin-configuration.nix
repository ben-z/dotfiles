{ config, lib, pkgs, ... }:

let
  myHunspell = pkgs.hunspellWithDicts [pkgs.hunspellDicts.en-ca pkgs.hunspellDicts.en-us];
in
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
      pkgs.qemu
      pkgs.aws
      pkgs.gdb
      pkgs.git
      pkgs.fswatch
      pkgs.pkgconfig
      pkgs.gettext
      pkgs.gitAndTools.bfg-repo-cleaner
      pkgs.wget
      myHunspell
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
        alias vi='vim'           # alias vi to vim
      '';

    # environment variables
    variables = {
      PATH = "$HOME/Projects/my_bin_files:$HOME/.npm/bin:$PATH";
    };
  };

  programs.vim = {
    enable = true;
    enableSensible = true;
    extraKnownPlugins = {
      autoclose = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "vim-autoclose-2018-06-16";
        src = pkgs.fetchgit {
          url = "git://github.com/ben-z/vim-autoclose";
          rev = "22ba641a337000346a77c8bb99bfc2248657cd80";
          sha256 = "009yr0gaz3hwgc4904c4bjarg7gag7kx4b3pis2syd8xdjrqap85";
        };
        dependencies = [];
      };
      seoul256-theme = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "vim-seoul256-theme-2018-06-19";
        src = pkgs.fetchgit {
          url = "git://github.com/junegunn/seoul256.vim";
          rev = "1475b7610663c68aa90b6e565997c8792ce0d222";
          sha256 = "03gqw14f5cirivcg1p06g500ns066yv5rd0z3zikvn4ql7n278dk";
        };
        dependencies = [];
      };
      yajs-vim = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "yajs-vim-2018-07-09";
        src = pkgs.fetchgit {
          url = "git://github.com/othree/yajs.vim";
          rev = "9c724db6689062fe803931add5d1c0c6d6c79411";
          sha256 = "0ymyzkg1a9pfrcgazq3b0w4rry88lkwg5nar02daafgi2jh274an";
        };
        dependencies = [];
      };
    };
    plugins = [{
      names = [
        # These are pretty useful
        "commentary" "undotree" "nerdtree" "nerdtree-git-plugin" "ctrlp" "youcompleteme" "autoclose" "airline" "easymotion" "vim-airline-themes" "ack-vim" "Rename" "yajs-vim"
        # Still experimenting with these
        "limelight-vim" "seoul256-theme" "goyo-vim"
      ];
    }];
    vimConfig =
      ''
      " Turn off ycm load conf confirmation
      let g:ycm_confirm_extra_conf = 0
      let g:airline_theme='solarized'
      let g:airline_solarized_bg='dark'

      " Many options below are taken from https://github.com/spf13/spf13-vim/blob/3.0/.vimrc

      " General {
        filetype plugin indent on   " Automatically detect file types.
        syntax on                   " Syntax highlighting
        set mouse=a                 " Automatically enable mouse usage
        set mousehide               " Hide the mouse cursor while typing
      " }

      " Use system clipboard {
        if has('clipboard')
          if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
          else                   " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
          endif
        endif
      " }

      " Allow for cursor beyond last character {
        set virtualedit=onemore
      " }

      " Restore cursor position {
        function! ResCur()
          if line("'\"") <= line("$")
            normal! g`"
            return 1
          endif
        endfunction

        augroup resCur
          autocmd!
          autocmd BufWinEnter * call ResCur()
        augroup END
      " }

      " Backup and persistent undo {
        set backup
        if has('persistent_undo')
            set undofile
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif
      " }

      " Strip whitespace {
        function! StripTrailingWhitespace()
          " Preparation: save last search, and cursor position.
          let _s=@/
          let l = line(".")
          let c = col(".")
          " do the business:
          %s/\s\+$//e
          " clean up: restore previous search history, and cursor position
          let @/=_s
          call cursor(l, c)
        endfunction

        " Automatically strip trailing whitespace for the following file types
        autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql,nix autocmd BufWritePre <buffer> call StripTrailingWhitespace()
      " }

      " Wrapped lines goes down/up to next row, rather than next line in file {
        noremap j gj
        noremap k gk
      " }

      " Map commonly mistyped keys {
        if has("user_commands")
          command! -bang -nargs=* -complete=file E e<bang> <args>
          command! -bang -nargs=* -complete=file W w<bang> <args>
          command! -bang -nargs=* -complete=file Wq wq<bang> <args>
          command! -bang -nargs=* -complete=file WQ wq<bang> <args>
          command! -bang Wa wa<bang>
          command! -bang WA wa<bang>
          command! -bang Q q<bang>
          command! -bang QA qa<bang>
          command! -bang Qa qa<bang>
        endif
      " }

      " Some useful shortcuts {
        " For when you forget to sudo.. Really Write the file.
        cmap w!! w !sudo tee % >/dev/null

        " Change Working Directory to that of the current file
        cmap cwd lcd %:p:h
        cmap cd. lcd %:p:h

        " Find merge conflict markers
        map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>
      " }

      " Fugitive {
        nnoremap <silent> <leader>gs :Gstatus<CR>
        nnoremap <silent> <leader>gd :Gdiff<CR>
        nnoremap <silent> <leader>gc :Gcommit<CR>
        nnoremap <silent> <leader>gb :Gblame<CR>
        nnoremap <silent> <leader>gl :Glog<CR>
        nnoremap <silent> <leader>gp :Git push<CR>
        nnoremap <silent> <leader>gr :Gread<CR>
        nnoremap <silent> <leader>gw :Gwrite<CR>
        nnoremap <silent> <leader>ge :Gedit<CR>
        " Mnemonic _i_nteractive
        nnoremap <silent> <leader>gi :Git add -p %<CR>
        nnoremap <silent> <leader>gg :SignifyToggle<CR>
      " }

      " UndoTree {
        nnoremap <Leader>u :UndotreeToggle<CR>
        " If undotree is opened, it is likely one wants to interact with it.
        let g:undotree_SetFocusWhenToggle=1
      " }

      " AutoCloseTag {
        " Make it so AutoCloseTag works for xml and xhtml files as well
        au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
        nmap <Leader>ac <Plug>ToggleAutoCloseMappings
      " }

      " Ack {
        if executable('rg')
          let g:ackprg = 'rg --vimgrep'
        endif
      " }

      " NerdTree {
        map <leader>e :NERDTreeFind<CR>
        nmap <leader>nt :NERDTreeFind<CR>

        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
        let NERDTreeChDirMode=0
        let NERDTreeQuitOnOpen=1
        let NERDTreeMouseMode=2
        let NERDTreeShowHidden=1
        let NERDTreeKeepTreeInNewTab=1
        let g:nerdtree_tabs_open_on_gui_startup=0
    " }

    " ctrlp {
      let g:ctrlp_working_path_mode = 'ra'
      nnoremap <silent> <D-t> :CtrlP<CR>
      nnoremap <silent> <D-r> :CtrlPMRU<CR>

      " enable cross-session caching
      let g:ctrlp_clear_cache_on_exit = 0

      let g:ctrlp_show_hidden = 0

      let g:ctrlp_custom_ignore = {
        \ 'dir':  '\.git$\|\.hg$\|\.svn$',
        \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }
    "}

    " limelight {
      " From https://github.com/junegunn/limelight.vim/issues/27#issuecomment-160692583
      let g:limelight_conceal_ctermfg = 245  " Solarized Base1
      let g:limelight_conceal_guifg = '#8a8a8a'  " Solarized Base1
    "}
      '';
  };

  # programs.tmux = {
  #   enable = true;
  #   enableSensible = true;
  #   enableMouse = true;
  #   enableFzf = true;
  #   enableVim = true;
  #   iTerm2 = true;
  # };
}
