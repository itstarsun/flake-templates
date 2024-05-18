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
      flake = false; # avoid unnecessary dependencies
    };

    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
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

      perSystem = { lib, config, pkgs, system, ... }:
        let
          rustToolchain =
            pkgs.rust-bin.selectLatestNightlyWith
              (toolchain: toolchain.default.override {
                extensions = [
                  "rust-src"
                ];
              });

          craneLib = (inputs.crane.mkLib pkgs).overrideToolchain rustToolchain;
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
              package = rustToolchain;
            };
          };

          packages.default =
            craneLib.buildPackage {
              src = lib.fileset.toSource {
                root = ./.;
                fileset = lib.fileset.unions [
                  ./src
                  ./Cargo.lock
                  ./Cargo.toml
                ];
              };

              strictDeps = true;
            };

          devShells.default = pkgs.mkShell {
            inputsFrom = [
              config.treefmt.build.devShell
            ];

            packages = [
              rustToolchain
            ];
          };
        };
    };
}
