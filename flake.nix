{

  # using this video as a guide: https://www.youtube.com/watch?v=mJbQ--iBc1U

  description = "Adam's NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11"; # change 22.11 to upgrade to a newer version of NixOS
    ## TODO: research how to use home-manager
    ## https://nix-community.github.io/home-manager/index.html#sec-flakes-nixos-module
    #home-manager.url = "github:nix-community/home-manager/release-22.11";
    #home-manager.inputs.nixpkgs.follows = "nixpkgs"; # link home-manager to our nixpkgs (see nixpkgs.url ...)
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
      lib = nixpkgs.lib;
    in
    {
      # # how to setup home-manager
      # homeManagerConfigurations = {
      #   adam = home-manager.lib.homeManagerConfiguration {
      #     inherit system pkgs;
      #     username = "adam";
      #     homeDirectory = "/home/adam/";
      #     configuration = {
      #       imports = [
      #         ./users/wil/home.nix
      #       ];
      #     };
      #   };
      # };

      nixosConfigurations = { 
        # each config named here has to be the same as the hostname

        #   # TODO: my VM machine
        # vm-srvr = lib.nixosSystem {
        #   inherit system;
        # };

        #   # TODO: my VM machine
        # vm-dsktp = lib.nixosSystem {
        #   inherit system;
        # };
        desktop = lib.nixosSystem {
          # TODO: my main desktop
          inherit system;

          modules = [
            ./hosts/desktop/configuration.nix
          ];
        };
      };

      # TODO: my quick-use devShells
        # TODO: python & poetry
        # TODO: python, poetry and django
        # TODO: rust & cargo
    };
}

# to test run
# `nixos-rebuild build --flake .#nxbx-dsktp
# or if you are running this on your NixOS with hostname `nxbx-dsktp` then just run...
# `nixos-rebuild build --flake .#` 
# ^ automatically looks for `nxbx-dsktp`

# to build and switch on a system
# `sudo nixos-rebuild switch --flake .#`

# to update to the latest versions where possible
# `nix flake update --recreate-lock-file`

