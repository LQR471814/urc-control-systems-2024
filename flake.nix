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
      ];
      perSystem =
        { pkgs, ... }:
        {
          devShells.default =
            (pkgs.buildFHSEnv {
              name = "libhal-fhs";
              targetPkgs =
                pkgs: with pkgs; [
                  conan
                  cmake
                  python313
                  python313Packages.pyserial

                  zlib
                  zstd
                  picolibc
                ];
              runScript = "bash";
              profile = ''
                export CONAN_HOME="$(pwd)/.libhal-conan2"
              '';
            }).env;
        };
    };
}
