{ lib, pkgs, ... }:
{
  programs = {
    nixvim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      globalOpts = {
        tabstop = 4;
        shiftwidth = 4;
        softtabstop = 0;
        expandtab = true;
        smarttab = true;
        number = true;
      };

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
      plugins.coq-nvim = {
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
      plugins.telescope = {
        enable = true;
        keymaps = {
          "<C-p>" = {
            action = "git_files";
            options = {
              desc = "Telescope Git Files";
            };
          };
          "<leader>fg" = "live_grep";
        };
        settings = {
          defaults = {
            layoutConfig = {
              horizontal = {
                previewWidth = 0.6;
              };
            };
          };

        };
      };

      keymaps = [
        # NvimTree
        {
          action = ":NvimTreeToggle<CR>";
          key = "<leader>t";
        }
      ];

    };
  };
}
