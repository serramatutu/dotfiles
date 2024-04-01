return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = { "lua_ls", "ruff_lsp", "pyright", "kotlin_language_server", "rust_analyzer" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      servers = {
        pyright = {
          settings = {
            pyright = {
              disableOrganizeImports = true, -- Using Ruff
            },
            python = {
              analysis = {
                ignore = { "*" }, -- Using Ruff
              },
            },
          },
        },
        ruff_lsp = {},
      },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason = require("mason")

      mason.setup()

      local on_attach = function(client, bufnr)
        if client.name == "ruff_lsp" then
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false
        end
      end

      lspconfig.pyright.setup({})
      lspconfig.ruff_lsp.setup({
        on_attach = on_attach,
      })
    end,
    keys = {
      { "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { noremap = true, silent = true } },
    },
  },

  -- JSON schema
  { import = "lazyvim.plugins.extras.lang.json" },

  -- Null-ls to import code actions and stuff
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.completion.luasnip,
        },
      })
    end,
  },
}
