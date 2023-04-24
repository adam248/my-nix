{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
  };

  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      
      # change to whatever you set in [tool.poetry.scripts] the the pyproject.toml
      script_command = "start"; 
    in
    {
        # default package (`nix build`)
        packages.${system}.default = pkgs.poetry2nix.mkPoetryApplication {
          projectDir = self;
        };

        # default devshell (`nix develop`)
        devShells.${system}.default = pkgs.mkShellNoCC {
          shellHook = "echo Welcome to your Nix-powered development environment!";
          IS_NIX_AWESOME = "YES!";
          packages = with pkgs; [
            (poetry2nix.mkPoetryEnv { projectDir = self; })
          ];
        };

        # default app (`nix run`)
        apps.${system}.default = {
           program = "${self.packages.${system}.default}/bin/${script_command}";
           type = "app";
        };
    };
}
