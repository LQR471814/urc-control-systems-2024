{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      perSystem =
        { pkgs, ... }:
        {
          devShells.default =
            (pkgs.buildFHSEnv {
              name = "libhal-fhs";
              targetPkgs =
                multiPkgs: with pkgs; [
                  conan
                  python313
                  python313Packages.pyserial
                  zlib # Add this
                  zstd # And this (often needed too)
                  libxml2
                  ncurses
                  stdenv.cc.cc.lib
                  gcc
                  gcc.cc.lib
                  binutils
                  gcc-unwrapped
                  libgcc
                  glibc
                  glibc.dev
                  openssl
                  curl
                  xz
                  bzip2
                ];
              runScript = "bash";
              profile = ''
                mkdir -p "$HOME/.nix-fhs-libs"
                ln -sf /lib/libxml2.so.16 "$HOME/.nix-fhs-libs/libxml2.so.2"
                export LD_LIBRARY_PATH="$HOME/.nix-fhs-libs:/lib:$LD_LIBRARY_PATH"

                conan config install https://github.com/libhal/conan-config2.git
                conan hal setup
              '';
            }).env;
        };
    };
}
