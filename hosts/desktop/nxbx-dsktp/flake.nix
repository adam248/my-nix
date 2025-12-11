{
  description = "NXBX-DSKTP Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;

      config = {
        allowUnfree = true;
      };
    };

  in
  {
    nixosConfigurations = {
      nixbox = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; };

        modules = {
          ./configuration.nix
        };
      };
    };


  };
}
