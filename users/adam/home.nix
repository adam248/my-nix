{ config, pkgs, ... }:

{
  home = {
    stateVersion = "22.05";

    username = "adam";
    homeDirectory = "/home/adam";
    sessionVariables = {
      EDITOR = "nvim";
    };

    packages = with pkgs; [
      bat
      unzip
    ];
  };

  imports = [
    ./neovim
  ];

  programs.home-manager.enable = true;
}
