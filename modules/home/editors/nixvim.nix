{ inputs
, config
, lib
, pkgs
, ...
}:
let
  # Use Stylix palette if present; otherwise fall back to Catppuccin Mocha background
  notifyBg = lib.attrByPath [ "lib" "stylix" "colors" "base01" ] "1e1e2e" config;
in
{
  # Bring in Nixvim's Home Manager module so programs.nixvim options exist
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    # Core editor options
    opts = {
      number = true;
      relativenumber = false;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      swapfile = false;
      termguicolors = true;
      signcolumn = "yes";
      updatetime = 200;
      cursorline = true;
      spell = true;
      spelllang = [ "en" ];
      # Send all yanks/deletes to the system clipboard (Wayland/X11)
      clipboard = "unnamedplus";
    };

    # Theme: Catppuccin (mocha)
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = false;
      };
    };

    plugins = {
      # UI and visuals
      web-devicons.enable = true;
      lualine = {
        enable = true;
        settings = {
          options = { theme = "catppuccin"; };
        };
      };
      bufferline.enable = true;
      indent-blankline.enable = true;
      colorizer.enable = true;
      illuminate.enable = true;

      # File tree (Neo-tree to match NVF)
      neo-tree = {
        enable = true;
      };

      # Fuzzy finder
      telescope.enable = true;

      # Treesitter for syntax/TS features
      treesitter.enable = true;
      treesitter-context.enable = false;

      # Project management
      project-nvim.enable = true;

      # Notifications and UI polish
      notify.enable = true;
      noice.enable = true;

      # Startup dashboard
      alpha = {
        enable = true;
        theme = "dashboard"; # required by nixvim: either set a theme or a custom layout
      };

      # Git integrations
      gitsigns.enable = true;
      diffview.enable = true;

      # Motions and editing helpers
      hop.enable = true;
      leap.enable = true;
      vim-surround.enable = true;
      comment.enable = true;
      which-key.enable = true;

      # Autopairs for (), {}, [], '', "", etc.
      nvim-autopairs = {
        enable = true;
        settings = {
          check_ts = true; # leverage Treesitter for smarter pairing
          enable_check_bracket_line = false;
          fast_wrap = {
            enable = true;
            map = "<M-e>"; # Alt+e to fast-wrap
            chars = [ "{" "[" "(" "\"" "'" "`" ];
          };
        };
      };

      # Terminal
      toggleterm = {
        enable = true;
        settings = { direction = "float"; };
      };

      # Diagnostics UI
      trouble.enable = true;

      # Markdown preview
      markdown-preview.enable = true;

      # Completion and snippets
      cmp = {
        enable = true;
      };
      # Completion sources for LSP, buffer, path, and snippets
      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp_luasnip.enable = true;

      luasnip.enable = true;
      friendly-snippets.enable = true;

      # Signature help while typing function params
      lsp-signature.enable = true;

      # LSP configuration
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          lua_ls.enable = true;
          pyright.enable = true;
          ts_ls.enable = true;
          html.enable = true;
          cssls.enable = true;
          clangd.enable = true;
          zls.enable = true;
          marksman.enable = true;
          # hyprls is optional; keep tools available via extraPackages
        };
        keymaps = {
          diagnostic = {
            "<leader>dl" = "open_float";
            "[d" = "goto_prev";
            "]d" = "goto_next";
          };
        };
      };

      # Formatter: conform.nvim (Prettierd, Stylua, etc.)
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            nix = [ "nixpkgs_fmt" ];
            lua = [ "stylua" ];
            javascript = [ "prettierd" ];
            typescript = [ "prettierd" ];
            javascriptreact = [ "prettierd" ];
            typescriptreact = [ "prettierd" ];
            css = [ "prettierd" ];
            html = [ "prettierd" ];
            markdown = [ "prettierd" ];
            sh = [ "shfmt" ];
          };
          format_on_save = {
            lsp_fallback = true;
          };
        };
      };
    };

    # Keymaps aligned with your NVF setup
    keymaps = [
      # Insert-mode escape
      {
        key = "jk";
        mode = [ "i" ];
        action = "<ESC>";
        options.desc = "Exit insert mode";
      }

      # Telescope
      {
        key = "<leader>ff";
        mode = [ "n" ];
        action = "<cmd>Telescope find_files<cr>";
        options.desc = "Search files by name";
      }
      {
        key = "<leader>lg";
        mode = [ "n" ];
        action = "<cmd>Telescope live_grep<cr>";
        options.desc = "Search files by contents";
      }

      # File tree (Neo-tree)
      {
        key = "<leader>fe";
        mode = [ "n" ];
        action = "<cmd>Neotree toggle<cr>";
        options.desc = "File browser toggle";
      }

      # Terminal
      {
        key = "<leader>t";
        mode = [ "n" ];
        action = "<cmd>ToggleTerm<CR>";
        options.desc = "Toggle terminal";
      }

      # Comment line (Doom Emacs style)
      {
        key = "<leader>.";
        mode = [ "n" ];
        action = "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>";
        options.desc = "Comment line";
      }
      {
        key = "<leader>.";
        mode = [ "v" ];
        action = "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>";
        options.desc = "Comment selection";
      }

      # Diagnostics
      {
        key = "<leader>dj";
        mode = [ "n" ];
        action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
        options.desc = "Go to next diagnostic";
      }
      {
        key = "<leader>dk";
        mode = [ "n" ];
        action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
        options.desc = "Go to previous diagnostic";
      }
      {
        key = "<leader>dl";
        mode = [ "n" ];
        action = "<cmd>lua vim.diagnostic.open_float()<CR>";
        options.desc = "Show diagnostic details";
      }
      {
        key = "<leader>dt";
        mode = [ "n" ];
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "Toggle diagnostics list";
      }

      # Disable accidental F1 across modes
      {
        key = "<F1>";
        mode = [ "n" "i" "v" "x" "s" "o" "t" "c" ];
        action = "<Nop>";
        options.desc = "Disable accidental F1 help";
      }
      # Help mappings
      {
        key = "<leader>h";
        mode = [ "n" ];
        action = ":help<Space>";
        options = {
          desc = "Open :help prompt";
          nowait = true;
        };
      }
      {
        key = "<leader>H";
        mode = [ "n" ];
        action = ":help <C-r><C-w><CR>";
        options.desc = "Help for word under cursor";
      }
    ];

    # Runtime tools and language servers
    extraPackages = with pkgs; [
      ripgrep
      fd
      bat
      # Wayland clipboard provider used by Neovim for system clipboard access
      wl-clipboard
      lazygit
      nixd
      hyprls
      nodePackages.typescript-language-server
      nodePackages.typescript
      vscode-langservers-extracted
      pyright
      lua-language-server
      zls
      marksman
      clang-tools
      prettierd
      stylua
      shfmt
      nixpkgs-fmt
      figlet
      toilet
    ];

    # Diagnostic UI and notify background tweaks
    extraConfigLua = ''
      -- Inline diagnostics (virtual text) similar to NVF virtual_lines
      vim.diagnostic.config({
        virtual_text = { prefix = "●", spacing = 2 },
        update_in_insert = true,
        severity_sort = true,
        underline = true,
        signs = true,
      })

      -- Basic LSP keymaps when LSP attaches
      local function lsp_on_attach(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map('n', 'K', vim.lsp.buf.hover, 'Hover docs')
        map('n', 'gd', vim.lsp.buf.definition, 'Goto definition')
        map('n', 'gD', vim.lsp.buf.declaration, 'Goto declaration')
        map('n', 'gi', vim.lsp.buf.implementation, 'Goto implementation')
        map('n', 'gr', vim.lsp.buf.references, 'References')
        map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
        map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code action')
      end

      -- If nixvim exposes a hook, register it; otherwise set a global autocmd
      if vim.g.__nixvim_lsp_attached ~= true then
        vim.g.__nixvim_lsp_attached = true
        vim.api.nvim_create_autocmd('LspAttach', {
          callback = function(args)
            local bufnr = args.buf
            lsp_on_attach(nil, bufnr)
          end,
        })
      end

      -- Notify background using Stylix palette
      local ok, notify = pcall(require, 'notify')
      if ok then
        notify.setup({ background_colour = "#${notifyBg}" })
        vim.notify = notify
      end

      -- nvim-cmp integration with nvim-autopairs (optional)
      do
        local ok_cmp, cmp = pcall(require, "cmp")
        local ok_ap, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
        if ok_cmp and ok_ap then
          cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end
      end

      -- Startup dashboard (alpha-nvim)
      do
        local ok_alpha, alpha = pcall(require, "alpha")
        if ok_alpha then
          local dashboard = require("alpha.themes.dashboard")

          -- Prefer generating the header with toilet (ansi-shadow), then figlet; fall back if unavailable
          local header_lines = nil
          local function gen_banner(cmd)
            local h = io.popen(cmd)
            if not h then return nil end
            local out = h:read("*a") or ""
            h:close()
            if #out == 0 then return nil end
            local lines = {}
            for line in out:gmatch("([^\n]*)\n?") do
              if line ~= "" then table.insert(lines, line) end
            end
            return #lines > 0 and lines or nil
          end

          header_lines = gen_banner('toilet -f ansi-shadow NIXOS 2>/dev/null')
            or gen_banner('figlet -f "ANSI Shadow" NIXOS 2>/dev/null')
            or gen_banner('figlet NIXOS 2>/dev/null')

          if not header_lines then
            header_lines = {
              " _   _ ___  __  __  ___   ___   ____  ",
              "| \\ | |_ _| \\ \\/ / / _ \\ / _ \\\ |  _ \\ ",
              "|  \\| || |   \\  / | | | | | | || | | |",
              "| |\\  || |   /  \\ | |_| | |_| || |_| |",
              "|_| \\_|___| /_/\\_\\ \\___/ \\___/ |____/ ",
            }
          end
          dashboard.section.header.val = header_lines

          dashboard.section.buttons.val = {
            dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
            dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
            dashboard.button("g", "󰺮  Live grep", ":Telescope live_grep<CR>"),
            dashboard.button("n", "  New file", ":enew<CR>"),
            dashboard.button("e", "  File browser", ":Neotree toggle<CR>"),
            dashboard.button("q", "  Quit", ":qa<CR>"),
          }

          local v = vim.version()
          dashboard.section.footer.val = string.format("NixVim • Neovim %d.%d.%d", v.major, v.minor, v.patch)

          dashboard.opts.opts.noautocmd = true
          alpha.setup(dashboard.config)

          -- Disable folding in alpha buffer
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "alpha",
            callback = function()
              vim.opt_local.foldenable = false
            end,
          })
        end
      end
    '';
  };
}
