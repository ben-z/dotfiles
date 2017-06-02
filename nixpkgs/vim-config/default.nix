{ pkgs }:

let
  my_plugins = import ./plugins.nix { inherit (pkgs) vimUtils fetchFromGitHub; }; 
  configurable_nix_path = "${<nixpkgs>}/pkgs/applications/editors/vim/configurable.nix";
  my_vim_configurable = with pkgs; vimUtils.makeCustomizable (callPackage configurable_nix_path {
    inherit (darwin.apple_sdk.frameworks) CoreServices Cocoa Foundation CoreData;
    inherit (darwin) libobjc cf-private;

    features = "huge"; # one of  tiny, small, normal, big or huge
    lua = pkgs.lua5_1;
    gui = config.vim.gui or "auto";
    python = python3;
  });

in with pkgs; my_vim_configurable.customize {
  name = "vim";
  vimrcConfig = {
    customRC = ''
      " Use Vim settings, rather than Vi settings (much better!).
      " This must be first, because it changes other options as a side effect.
      set nocompatible

      syntax on
      filetype on
      set expandtab
      set tabstop=2
      set softtabstop=2
      set shiftwidth=2
      set smarttab
      set autoindent
      set smartindent
      set smartcase
      set ignorecase
      set modeline
      set encoding=utf-8
      set incsearch
      set hlsearch
      set history=700
      set number
      set laststatus=2
      set termguicolors
      colorscheme solarized8_dark

      if v:version >= 704
        set relativenumber
        set number
      endif

      if has('mouse')
        set mouse=a
      endif

      set pastetoggle=<F2>
      " Display a block cursor in normal mode and a line cursor in insert mode
      " Source: https://code.google.com/archive/p/mintty/wikis/Tips.wiki
      let &t_ti.="\e[1 q"
      let &t_SI.="\e[5 q"
      let &t_EI.="\e[1 q"
      let &t_te.="\e[0 q"

      " Prevent delay on <ESC><O> and some other combinations
      " Source: https://vi.stackexchange.com/a/3262
      set timeout timeoutlen=1000 ttimeoutlen=100

      set grepprg=rg\ --vimgrep
      " bind K to grep word under cursor
      nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
      let g:ctrlp_user_command = 'rg --files %s'
      let g:ctrlp_use_caching = 0

      " Convenient command to see the difference between the current buffer and the
      " file it was loaded from, thus the changes you made.
      " Only define it when not defined already.
      if !exists(":DiffOrig")
        command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
            \ | wincmd p | diffthis
      endif

      " For all text files set 'textwidth' to 78 characters.
      autocmd FileType text setlocal textwidth=78

      " When editing a file, always jump to the last known cursor position.
      " Don't do it when the position is invalid or when inside an event handler
      " (happens when dropping a file on gvim).
      " Also don't do it when the mark is in the first line, that is the default
      " position when opening a file.
      autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

      let g:NERDSpaceDelims = 1

      autocmd FileType javascript set formatprg=prettier\ --stdin\ --parser\ flow\ --single-quote\ --trailing-comma\ all

      " Use formatprg when available
      let g:neoformat_try_formatprg = 1

      let g:used_javascript_libs = 'react'

      let g:vimtex_compiler_latexmk = {
      \ 'callback' : 0,
      \ }

      if !exists('g:ycm_semantic_triggers')
        let g:ycm_semantic_triggers = {}
      endif
      let g:ycm_semantic_triggers.tex = [
      \ 're!\\[A-Za-z]*cite[A-Za-z]*(\[[^]]*\]){0,2}{[^}]*',
      \ 're!\\[A-Za-z]*ref({[^}]*|range{([^,{}]*(}{)?))',
      \ 're!\\hyperref\[[^]]*',
      \ 're!\\includegraphics\*?(\[[^]]*\]){0,2}{[^}]*',
      \ 're!\\(include(only)?|input){[^}]*',
      \ 're!\\\a*(gls|Gls|GLS)(pl)?\a*(\s*\[[^]]*\]){0,2}\s*\{[^}]*',
      \ 're!\\includepdf(\s*\[[^]]*\])?\s*\{[^}]*',
      \ 're!\\includestandalone(\s*\[[^]]*\])?\s*\{[^}]*',
      \ 're!\\usepackage(\s*\[[^]]*\])?\s*\{[^}]*',
      \ 're!\\documentclass(\s*\[[^]]*\])?\s*\{[^}]*',
      \ 're!\\[A-Za-z]*',
      \ ]

      autocmd BufWritePre *.js Neoformat
    '';

    vam.knownPlugins = vimPlugins // my_plugins;
    vam.pluginDictionaries = [
      { names = [
        "ctrlp"
        "vim-nix"
        "youcompleteme"
        "gitgutter"
        "vim-airline"
        "molokai"
        "sleuth"
        "ale"
        "vim-solarized8"
        "vim-go"
        "vim-javascript"
        "vim-vue"
        "elm-vim"
        "hexmode"
        "vim-flow"
        "nerdcommenter"
        "neoformat"
        "javascript-libraries-syntax"
        "vimtex"
        "vim-racket"
        "vim-javascript"
        "vim-jsx-pretty"
      ]; }
    ];
  };
}
