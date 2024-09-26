return {
  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "hcl",
        "html",
        "javascript",
        "json",
        "kotlin",
        "lua",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "sql",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          move = {
            enable = true,
            goto_next_start = {
              ["nf"] = "@function.inner",
              ["nc"] = "@class.inner",
              ["ns"] = "@block.inner",
            },
            goto_previous_start = {
              ["pf"] = "@function.inner",
              ["pc"] = "@class.inner",
              ["ps"] = "@block.inner",
            },
          },
          select = {
            enable = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
            },
          },
        },
      })
    end,
  },
  { "windwp/nvim-ts-autotag" },

  -- indent
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = { indent = { char = "▏" } } },
  {
    "kiyoon/treesitter-indent-object.nvim",
    keys = {
      {
        "ai",
        function()
          require("treesitter_indent_object.textobj").select_indent_outer()
        end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (outer)",
      },
      {
        "aI",
        function()
          require("treesitter_indent_object.textobj").select_indent_outer(true)
        end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (outer, line-wise)",
      },
      {
        "ii",
        function()
          require("treesitter_indent_object.textobj").select_indent_inner()
        end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (inner, partial range)",
      },
      {
        "iI",
        function()
          require("treesitter_indent_object.textobj").select_indent_inner(true, "V")
        end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (inner, entire range) in line-wise visual mode",
      },
    },
  },

  -- git blame
  { "f-person/git-blame.nvim" },

  -- powerlines
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        style_preset = "minimal",
        numbers = "buffer_id",
        show_buffer_close_icons = false,
        show_close_icons = false,
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      vim.g.gitblame_display_virtual_text = 0
      git_blame = require("gitblame")

      require("lualine").setup({
        options = {
          theme = "ayu_dark",
        },
        sections = {
          lualine_c = {
            { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
          },
        },
      })
    end,
  },

  -- Comment
  {
    "numToStr/Comment.nvim",
    lazy = false,
    config = function()
      require("Comment").setup()
    end,
  },

  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = {
      {
        "JMarkin/nvim-tree.lua-float-preview",
        lazy = true,
        opts = {
          toggled_on = true,
          wrap_nvimtree_commands = true,
          scroll_lines = 20,
          window = {
            style = "minimal",
            relative = "win",
            border = "rounded",
            wrap = false,
          },
          mapping = {
            down = { "<C-d>" },
            up = { "<C-e>", "<C-u>" },
            toggle = { "<C-x>" },
          },
          hooks = {
            pre_open = function(path)
              local size = require("float-preview.utils").get_size(path)
              if type(size) ~= "number" then
                return false
              end
              local is_text = require("float-preview.utils").is_text(path)
              return size < 5 and is_text
            end,
            post_open = function(bufnr)
              return true
            end,
          },
        },
      },
    },
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      local function on_attach(bufnr)
        local api = require("nvim-tree.api")
        local FloatPreview = require("float-preview")

        FloatPreview.attach_nvimtree(bufnr)

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        local function change_root_to_global_cwd()
          local global_cwd = vim.fn.getcwd(-1, -1)
          api.tree.change_root(global_cwd)
        end

        local edit_wrap = FloatPreview.close_wrap(api.node.open.edit)
        local close_wrap = FloatPreview.close_wrap(api.tree.close)

        vim.keymap.set("n", "c", change_root_to_global_cwd, opts("Change Root To Global CWD"))
        vim.keymap.set("n", "J", api.node.navigate.sibling.next, opts("Next sibling"))
        vim.keymap.set("n", "K", api.node.navigate.sibling.prev, opts("Next sibling"))
        vim.keymap.set("n", "<Esc>", close_wrap, opts("Close tree"))
        vim.keymap.set("n", "q", close_wrap, opts("Close tree"))
        vim.keymap.set("n", "l", edit_wrap, opts("Open"))
        vim.keymap.set("n", "<Space>", edit_wrap, opts("Open"))
        vim.keymap.set("n", "<cr>", edit_wrap, opts("Open"))
        vim.keymap.set("n", "n", api.fs.create, opts("New"))
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close parent"))
        vim.keymap.set("n", "D", api.fs.trash, opts("Move to trash"))
        vim.keymap.set("n", "r", api.fs.rename_basename, opts("Rename (basename)"))
        vim.keymap.set("n", "<C-r>", api.fs.rename, opts("Rename (full)"))
        vim.keymap.set("n", "d", api.fs.cut, opts("Cut"))
        vim.keymap.set("n", "y", api.fs.copy.node, opts("Copy"))
        vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
        vim.keymap.set("n", "-", api.tree.collapse_all, opts("Collapse all"))
      end

      -- TODO: make this prettier later
      local HEIGHT_RATIO = 0.8
      local WIDTH_RATIO = 0.6
      local PREVIEW_OFFSET = 2

      require("nvim-tree").setup({
        on_attach = on_attach,
        sync_root_with_cwd = true,
        view = {
          width = function()
            return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
          end,
          float = {
            enable = true,
            open_win_config = function()
              local screen_w = vim.opt.columns:get()
              local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
              local total_w = screen_w * WIDTH_RATIO
              local window_w = total_w / 2
              local window_h = screen_h * HEIGHT_RATIO
              local window_w_int = math.floor(window_w)
              local window_h_int = math.floor(window_h)
              local center_x = (screen_w - total_w) / 2
              local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
              return {
                border = "rounded",
                relative = "editor",
                row = center_y,
                col = center_x,
                width = window_w_int,
                height = window_h_int,
              }
            end,
          },
        },
        filters = {
          custom = { "^.git$" },
        },
      })

      require("float-preview").setup({
        window = {
          wrap = false,
          trim_height = false,
          open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            local total_w = screen_w * WIDTH_RATIO
            local window_w = total_w / 2 - PREVIEW_OFFSET
            local window_h = screen_h * HEIGHT_RATIO
            local window_w_int = math.floor(window_w)
            local window_h_int = math.floor(window_h)
            local center_x = (screen_w - total_w) / 2 + window_w + 2 * PREVIEW_OFFSET -- offset by tree window
            local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
            return {
              border = "rounded",
              relative = "editor",
              row = center_y,
              col = center_x,
              width = window_w_int,
              height = window_h_int,
            }
          end,
        },
      })
    end,
    keys = {
      { "<leader>t", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
    },
  },

  -- Vertical movement
  {
    "ggandor/leap.nvim",
    config = function()
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
      vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
      vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
    lazy = false,
    config = function()
      local telescope = require("telescope")
      telescope.setup()
      telescope.load_extension("ui-select")
    end,
    keys = {
      -- find
      { "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find file" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffer" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Open recent file" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find in all files", remap = true },

      -- lsp stuff
      {
        "<leader>d",
        "<cmd>lua require'telescope.builtin'.diagnostics{bufnr=0}<cr>",
        desc = "Open diagnostics",
        remap = true,
        silent = true,
      },
      {
        "<leader>gi",
        "<cmd>lua require'telescope.builtin'.lsp_implementations{}<cr>",
        desc = "Go to implementations",
        remap = true,
        silent = true,
      },
      {
        "<leader>gd",
        "<cmd>lua require'telescope.builtin'.lsp_definitions{}<cr>",
        desc = "Go to definitions",
        remap = true,
        silent = true,
      },
    },
  },

  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
  },
  {
    "ms-jpq/coq_nvim",
    branch = "coq",
    lazy = false,
    build = ":COQdeps",
    init = function()
      vim.g.coq_settings = {
        auto_start = "shut-up",
      }
    end,
    dependencies = {
      {
        "ms-jpq/coq.artifacts",
        branch = "artifacts",
      },
    },
  },

  {
    "chentoast/marks.nvim",
    opts = {
      default_mappings = true,
    },
  },

  -- git conflicts
  { "akinsho/git-conflict.nvim", version = "*", config = true },
}
