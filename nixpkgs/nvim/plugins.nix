{ pkgs, fetchgit }:

with pkgs.vimUtils; {
  "nvim-typescript" = buildVimPlugin {
    name = "nvim-typescript";
    src = fetchgit {
      url = "https://github.com/mhartington/nvim-typescript";
      rev = "eca2bb92d45f09fc500317ededace5bc849063c1";
      sha256 = "10lh0yn7r4dfw8nkhrl676aasidwdiiln7gs9ac27yw77xz8p5zp";
    };
    dependencies = [];
    buildInputs = [ pkgs.nodejs-10_x ];
    preBuild = ''
      HOME=. ./install.sh
    '';
  };

  vim-plist = buildVimPlugin {
    name = "vim-plist";
    src = fetchgit {
      url = "https://github.com/darfink/vim-plist";
      rev = "67280fb32b88ad75e255068dfe69b9f069421618";
      sha256 = "1j3s26bmpfmnbaxhld5x49k9iq1c8xhgmspgqifgxzx8695wgmms";
    };
    dependencies = [];
  };
}
