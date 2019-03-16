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
}
