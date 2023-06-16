{ config, pkgs, lib, ... }:
with lib;

{
  programs.neovim = {
    enable = true;
    extraConfig = ''
      :luafile ~/.config/nvim/lua/adam/init.lua
    '';
    plugins = with pkgs.vimPlugins;
      [
        vim-nix
        gruvbox-community
        nvim-web-devicons
        nvim-tree-lua
        bufferline-nvim
        vim-bbye
        lualine-nvim
        nvim-lspconfig
      ];
    extraPackages = with pkgs; [
      rust-analyser
      nodejs
      nodePackages.typescript
      nodePackages.typescript-language-server
    ];
  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
