{
  # simple cargo2nix flake.nix

  # either use
  # `nix develop github:cargo2nix/cargo2nix#bootstrap
  # this give you access to cargo, etc... in a devshell
  # `cargo2nix`

  # or skip the shell
  # `nix run github:cargo2nix/cargo2nix`
  
  # `git add Cargo.nix`

  description = "cargo2nix-project-handler-flake";

  inputs = {
    cargo2nix.url = "github:cargo2nix/cargo2nix/release-0.11.0";
    flake-utils.follows = "cargo2nix/flake-utils";
    nixpkgs.follows = "cargo2nix/nixpkgs";
  };

  outputs = inputs: with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [cargo2nix.overlays.default];
        };

        rustPkgs = pkgs.rustBuilder.makePackageSet {
          rustVersion = "1.61.0";
          packageFun = import ./Cargo.nix;
        };

      in rec {
        packages = {
          # replace hello-world with your package name
          http-reqwests = (rustPkgs.workspace.http-reqwests {}).bin;
          default = packages.http-reqwests;
        };
      }
    );
}