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

    # optional features by flags
    flags = [ "python" "X11" ];
  });

in with pkgs; my_vim_configurable.customize {
  name = "vim";
  vimrcConfig = {
    customRC = ''
      syntax on
      filetype on
      set expandtab
      set tabstop=4
      set softtabstop=0
      set shiftwidth=4
      set smarttab
      set autoindent
      set smartindent
      set smartcase
      set ignorecase
      set modeline
      set nocompatible
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

      set grepprg=rg\ --vimgrep
      " bind K to grep word under cursor
      nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
      let g:ctrlp_user_command = 'rg --files %s'
      let g:ctrlp_use_caching = 0

      let g:NERDSpaceDelims = 1
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
        "vim-jsx"
        "nerdcommenter"
      ]; }
    ];
  };
}
