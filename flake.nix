{
  description = "Flake for building ROMs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        fhs = pkgs.buildFHSEnv {
          name = "FHS env for ROM building";
          extraOutputsToInstall = ["dev" "lib"];
          targetPkgs = pkgs:
            (with pkgs; [
              bc
              bison
              ccache
              curl
              flex
              fontconfig
              freetype
              git
              git-lfs
              git-repo
              glibc
              gnupg
              gperf
              imagemagick
              jdk11
              libgcc
              libxcrypt-legacy
              libxslt
              lzop
              maven
              openssl
              pngcrush
              python3
              rsync
              schedtool
              SDL
              squashfsTools
              xml2
              zip
              zsh
            ])
            ++ (with pkgs; [
              # Extre tools that EvoltuionX wants you tu install
              ncftp
              screen
              tmux
              w3m
            ]);
          multiPkgs = pkgs: (with pkgs; [
            freetype
            ncurses5
            readline
            zlib
          ]);
          runScript = "bash";
        };
      in {
        formatter = pkgs.alejandra;
        devShells = {
          default = fhs.env;
        };
      }
    );
}
