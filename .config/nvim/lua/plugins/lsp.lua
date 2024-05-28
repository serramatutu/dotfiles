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
      ensure_installed = {
        "lua_ls",
        "ruff_lsp",
        "pyright",
        "kotlin_language_server",
        "rust_analyzer",
        "yamlls",
        "terraformls",
      },
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
        yaml = {
          settings = {
            validate = true,
            schemaStore = {
              enable = false,
              url = "",
            },
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            },
          },
        },
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
      lspconfig.yamlls.setup({})
      lspconfig.rust_analyzer.setup({})
      lspconfig.terraformls.setup({})
    end,
    keys = {
      { "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { noremap = true, silent = true } },
    },
  },

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
