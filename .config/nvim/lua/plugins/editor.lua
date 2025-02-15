return {
  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash",
        "hcl",
        "html",
        "javascript",
        "json",
        "go",
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
    event = { "BufReadPre", "BufNewFile" },
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      max_lines = 1,
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "BufReadPre", "BufNewFile" },
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
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml" },
  },

  -- indent
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    -- issue with latest nvim
    -- https://github.com/lukas-reineke/indent-blankline.nvim/issues/936
    tag = "v3.8.2",
  },
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
  { "f-person/git-blame.nvim", event = "VeryLazy" },

  -- powerline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      vim.g.gitblame_display_virtual_text = 0
      git_blame = require("gitblame")

      require("lualine").setup({
        options = {
          theme = "ayu_dark",
        },
        sections = {
          lualine_x = {
            { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
          },
        },
      })
    end,
  },

  -- Comment
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
  },

  -- File tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>tt", "<cmd>:Neotree toggle<cr>", desc = "Toggle file tree" },
      { "<leader>tb", "<cmd>:Neotree toggle buffers<cr>", desc = "Toggle buffer tree" },
      { "<leader>tg", "<cmd>:Neotree toggle git_status<cr>", desc = "Toggle git status tree" },
    },
    config = function()
      local neotree = require("neo-tree")

      neotree.setup({
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignore = true,
            hide_by_name = {
              ".git",
              ".venv",
            },
          },
        },
        commands = {
          close_window = function()
            local state = require("neo-tree.sources.manager").get_state("filesystem")
            state.commands.revert_preview(state)
          end,
        },
        event_handlers = {
          {
            event = "file_opened",
            handler = function(file_path)
              require("neo-tree.command").execute({ action = "close" })
            end,
          },
        },
        window = {
          position = "left",
          width = 100,
          mappings = {
            ["l"] = "open",
            ["h"] = "close_node",
            ["<esc>"] = "close_window",
          },
        },
      })
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
    event = "VeryLazy",
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
    "ms-jpq/coq_nvim",
    branch = "coq",
    event = "VeryLazy",
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
    event = "VeryLazy",
    opts = {
      default_mappings = true,
    },
  },

  -- git conflicts
  {
    "akinsho/git-conflict.nvim",
    event = "VeryLazy",
    version = "*",
    config = true,
  },

  -- better quickfix list
  {
    "stevearc/quicker.nvim",
    event = "FileType qf",
    keys = {
      {
        "<leader>q",
        function()
          require("quicker").toggle()
        end,
        desc = "Toggle quickfix",
      },
      {
        "<leader>l",
        function()
          require("quicker").toggle({ loclist = true })
        end,
        desc = "Toggle loclist",
      },
    },
    opts = {},
  },
}
