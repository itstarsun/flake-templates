{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      eachSystem = f:
        nixpkgs.lib.genAttrs systems
          (system: f {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          });
    in
    {
      devShells = eachSystem ({ pkgs, ... }: {
        default = pkgs.mkShell { };
      });
    };
}
