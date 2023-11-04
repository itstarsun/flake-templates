{
  outputs = { self }: {
    templates = {
      flake-parts = {
        path = ./flake-parts;
        description = "A minimal flake using flake-parts.";
      };
      pre-commit = {
        path = ./pre-commit;
        description = "A minimal flake using flake-parts and pre-commit.";
      };
      rust = {
        path = ./rust;
        description = "A minimal flake using flake-parts for Rust.";
      };
    };
  };
}
