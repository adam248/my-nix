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
    ./nvim
  ];

  programs.home-manager.enable = true;
}
