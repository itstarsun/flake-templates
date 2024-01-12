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
      pre-commit = {
        path = ./pre-commit;
        description = "A flake using flake-parts and pre-commit.";
      };
      rust = {
        path = ./rust;
        description = "A flake using flake-parts for Rust.";
      };
    };
  };
}
