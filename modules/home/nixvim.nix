{ lib, pkgs, ... }:
{
  programs = {
    nixvim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavor = "mocha";
        };
      };

      plugins.lualine.enable = true;

      plugins.lsp = {
        enable = true;
        servers = {
          ts_ls.enable = true;
          pyright.enable = true;
          ruff.enable = true;
        };
      };
      plugins.coq-nvim= {
        enable = true;
      };
      plugins.web-devicons.enable = true;
      plugins.nvim-tree = {
        enable = true;
        filters.dotfiles = false;
        view = {
            side = "left";
            width = 30;
            preserveWindowProportions = true;
        };
      };
    };
  };
}
