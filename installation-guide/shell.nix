{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  name = "NixOS Installer Utility Shell";
  buildInputs = with pkgs; [
    disko
    neofetch
    neovim
    stress # for CPU testing
    tldr
  ];
}
