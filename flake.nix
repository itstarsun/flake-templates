{
  outputs = { self }: {
    templates = {
      flake-parts = {
        path = ./flake-parts;
        description = "A flake using flake-parts.";
      };
      minimal = {
        path = ./minimal;
        description = "A minimal flake.";
      };
      rust = {
        path = ./rust;
        description = "A flake using flake-parts for Rust.";
      };
    };
  };
}
