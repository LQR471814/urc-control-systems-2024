{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs =
    { self, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      perSystem =
        { pkgs, ... }:
        {
          devShells.default =
            (pkgs.buildFHSEnv {
              name = "libhal-fhs";
              targetPkgs =
                pkgs: with pkgs; [
                  # basic tools
                  zlib # Add this
                  zstd # And this (often needed too)
                  libxml2
                  ncurses
                  openssl

                  gcc-unwrapped
                  stdenv.cc.cc.lib
                  gcc
                  gcc.cc.lib
                  libgcc
                  glibc
                  glibc.dev

                  conan
                  cmake
                  gnumake

                  python313
                  python313Packages.pyserial
                  binutils
                  curl
                  xz
                  bzip2
                  git
                ];
              runScript = "bash";
              profile = ''
                mkdir -p "$HOME/.nix-fhs-libs"
                ln -sf /lib/libxml2.so.16 "$HOME/.nix-fhs-libs/libxml2.so.2"
                export LD_LIBRARY_PATH="$HOME/.nix-fhs-libs:/lib:$LD_LIBRARY_PATH"

                export CONAN_HOME="$(git rev-parse --show-toplevel)/.conan2"
              '';
            }).env;
        };
    };
}
