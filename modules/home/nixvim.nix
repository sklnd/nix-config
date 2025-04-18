{ lib, pkgs, ... }:
{

  programs = {
    nixvim = {
      enable = true;
      nixpkgs = {
        config = {
          allowUnfree = true;
        };
      };
      viAlias = true;
      vimAlias = true;

      opts = {
        tabstop = 4;
        shiftwidth = 4;
        softtabstop = 0;
        expandtab = true;
        smarttab = true;
        number = true;
      };

      autoCmd = [
        {
          command = "checktime";
          event = [
            "FocusGained"
          ];
          pattern = [
            "*"
          ];
        }
      ];

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

      plugins.project-nvim = {
        enable = true;
        settings = {
          detection_methods = [ "pattern" ];
          patterns = [
            ".git"
            "Makefile"
            "package.json"
            "pyproject.toml"
          ];
        };
      };

      plugins.copilot-vim = {
        enable = true;
        settings.node_command = lib.getExe pkgs.nodejs_20;
      };

      plugins.indent-blankline = {
        enable = true;
        autoLoad = true;
      };

      plugins.rainbow-delimiters = {
        enable = true;
      };

      plugins.treesitter = {
        enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          json
          lua
          make
          markdown
          nix
          toml
          yaml
          python
          typescript
          javascript
        ];
      };

      plugins.telescope = {
        enable = true;
        extensions = {
          project = {
            enable = true;
            settings = {
              base_dirs = [
                {
                  path = "~/git";
                  max_depth = 2;
                }
              ];
              on_project_selected = {
                __raw = ''
                  function(prompt_bufnr)
                    require("telescope._extensions.project.actions").change_working_directory(prompt_bufnr, false)
                  end
                '';
              };
              hidden_files = false;
              sync_with_nvim_tree = true;
              theme = "dropdown";
            };
          };
        };
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

      plugins.gitgutter = {
        enable = true;
        autoLoad = true;
      };

      keymaps = [
        {
          action = ":NvimTreeToggle<CR>";
          key = "<leader>t";
        }
        {
          mode = "n";
          key = "<C-`>";
          action = ":ToggleTerm<CR>";
          options = {
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "t";
          key = "<C-`>";
          action = "<C-\\><C-n>:ToggleTerm<CR>";
          options = {
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<leader>xx";
          action = "<cmd>Trouble diagnostics toggle<cr>";
          options = {
            silent = true;
            noremap = true;
          };
        }
      ];

      extraFiles."lua/diagnostic.lua".source = ../../config/nvim/lua/diagnostic.lua;
      extraFiles."lua/telescope_config.lua".source = ../../config/nvim/lua/telescope_config.lua;

      extraConfigLua = ''
        require('diagnostic').setup()
        require('telescope_config').setup()
      '';

    };
  };
}
