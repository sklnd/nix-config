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
      # Diagnostic configuration
      extraConfigLua = ''
        vim.diagnostic.config({
          virtual_text = {
            prefix = "●",
            spacing = 2,
          },
          signs = true,
          underline = true,
          update_in_insert = false,
          severity_sort = true,
        })
      '';

      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavor = "mocha";
        };
      };

      plugins.lualine.enable = true;

      plugins.lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          ts_ls.enable = true;
          basedpyright.enable = true;
          ruff.enable = true;
        };
      };
      plugins.cmp = {
        enable = true;
        settings = {
          mapping = {
            __raw = ''
              cmp.mapping.preset.insert({
                ['<c-b>'] = cmp.mapping.scroll_docs(-4),
                ['<c-f>'] = cmp.mapping.scroll_docs(4),
                ['<c-space>'] = cmp.mapping.complete(),
                ['<c-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
              })
            '';
          };
          autoEnableSources = true;
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
      };
      #plugins.copilot-vim.enable = true;
      plugins.trouble = {
        enable = true;
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
      plugins.toggleterm.enable = true;

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
