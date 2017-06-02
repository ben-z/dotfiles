{ vimUtils, fetchFromGitHub }:
{
  elm-vim = vimUtils.buildVimPluginFrom2Nix {
    name = "elm.vim-2017-01-13";
    src = fetchFromGitHub {
      owner = "ElmCast";
      repo = "elm-vim";
      rev = "0c1fbfdf12f165681b8134ed2cae2c148105ac40";
      sha256 = "0l871hzg55ysns5h6v7xq63lwf4135m3xggm2s4q2pmzizivk0x2";
    };
    dependencies = [];
  };

  vim-javascript = vimUtils.buildVimPluginFrom2Nix {
    name = "vim-javascript-2016-11-10";
    src = fetchFromGitHub {
      owner = "pangloss";
      repo = "vim-javascript";
      rev = "d736e95330e8aa343613ad8cddf1e7cc82de7ade";
      sha256 = "136q0ask4dp99dp7fbyi1v2qrdfy6mnrh0a3hzsy9aw5g2f2rvbj";
    };
    dependencies = [];
  };

  vim-vue = vimUtils.buildVimPluginFrom2Nix {
    name = "vim-vue-2016-10-22";
    src = fetchFromGitHub {
      owner = "posva";
      repo = "vim-vue";
      rev = "e13f9abf5ff71954226f71f60175f78efd7bfadd";
      sha256 = "07zwhzna5g22scjy2mq4clsgpkfavpgxiqvnfbfydgc52h73l27r";
    };
    dependencies = [];
  };

  hexmode = vimUtils.buildVimPluginFrom2Nix {
    name = "hexmode-2016-11-04";
    src = fetchFromGitHub {
      owner = "fidian";
      repo = "hexmode";
      rev = "27932330b9a36c91a6039267bc32a18060e82d57";
      sha256 = "00xdv6d3rmalv342ajqd7cgbci97frd7pmsrgfnaqcfimycka3la";
    };
    dependencies = [];
  };

  ale = vimUtils.buildVimPluginFrom2Nix {
    name = "ale-2017-04-03";
    src = fetchFromGitHub {
      owner = "w0rp";
      repo = "ale";
      rev = "c7bd5cc0ba799abb7e382751cdbea49c1b98a429";
      sha256 = "1rcj3wghdlbm79j8chvdrs47lsmy1d02if9hrykywrwfrk72hbpm";
    };
    dependencies = [];
  };

  vim-solarized8 = vimUtils.buildVimPluginFrom2Nix {
    name = "vim-solarized8-2017-04-03";
    src = fetchFromGitHub {
      owner = "lifepillar";
      repo = "vim-solarized8";
      rev = "0558a391977d2bee938a2d559f4571a5e8a25a1e";
      sha256 = "1sdfsph9xc7h0hm6mz8j8syl44flvrnzy8cikbwlxc6ihd48gx06";
    };
    dependencies = [];
  };

  vim-flow = vimUtils.buildVimPluginFrom2Nix {
    name = "vim-flow-2017-04-05";
    src = fetchFromGitHub {
      owner = "flowtype";
      repo = "vim-flow";
      rev = "3bd879dd7060f13a78e9238669c2e1731e098607";
      sha256 = "002nl02187b2lxaya0myd0scn586z9r7yjklz6gawrrpx17vi49f";
    };
    dependencies = [];
  };

  vim-jsx = vimUtils.buildVimPluginFrom2Nix {
    name = "vim-jsx-2017-04-06";
    src = fetchFromGitHub {
      owner = "mxw";
      repo = "vim-jsx";
      rev = "eb656ed96435ccf985668ebd7bb6ceb34b736213";
      sha256 = "1ydyifnfk5jfnyi4a1yc7g3b19aqi6ajddn12gjhi8v02z30vm65";
    };
    dependencies = [];
  };

  javascript-libraries-syntax = vimUtils.buildVimPluginFrom2Nix {
    name = "javascript-libraries-syntax-2017-05-14";
    src = fetchFromGitHub {
      owner = "othree";
      repo = "javascript-libraries-syntax.vim";
      rev = "6b16bf54cc89a6f81a6126c0df73a3407df491bf";
      sha256 = "1n6z805bgp59y0wxjxspw6w6ahbfm9i7w3bq4bm674radfff7738";
    };
    dependencies = [];
  };

  vim-racket = vimUtils.buildVimPluginFrom2Nix {
    name = "vim-racket-2017-05-26";
    src = fetchFromGitHub {
      owner = "wlangstroth";
      repo = "vim-racket";
      rev = "f76fde9afbc008b7468c9ea026cbe3840af5f5ef";
      sha256 = "1cs6kyw9565mdpyifvnp6lw9n0i31ahfqn48pg1n5h49bvn9667x";
    };
    dependencies = [];
  };

  vim-jsx-pretty = vimUtils.buildVimPluginFrom2Nix {
    name = "vim-jsx-pretty-2017-06-02";
    src = fetchFromGitHub {
      owner = "MaxMEllon";
      repo = "vim-jsx-pretty";
      rev = "a90b5f9c5d944709431d976e6576092041129bb5";
      sha256 = "181ss7wvpvmxw993hcd7fba0yqs1fdk50vlkxs9s8a11z4ra5086";
    };
    dependencies = [];
  };
}
