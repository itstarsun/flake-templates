{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      flake = false;
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem = { config, pkgs, system, ... }:
        let
          rust-bin = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
        in
        {
          imports = [
            "${inputs.nixpkgs}/nixos/modules/misc/nixpkgs.nix"
          ];

          nixpkgs = {
            hostPlatform = system;
            overlays = [
              (import inputs.rust-overlay)
            ];
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixpkgs-fmt.enable = true;
            programs.rustfmt = {
              enable = true;
              package = rust-bin;
            };
          };

          devShells.default = pkgs.mkShell {
            inputsFrom = [
              config.treefmt.build.devShell
            ];

            packages = [
              rust-bin
            ];
          };
        };
    };
}
