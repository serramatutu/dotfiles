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
        "gopls",
        "basedpyright",
        "cssls",
        "eslint",
        "html",
        "kotlin_language_server",
        "lua_ls",
        "ruff",
        "terraformls",
        "ts_ls",
        "yamlls",
        "zls",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      inlay_hints = {
        enabled = true,
      },
      servers = {
        basedpyright = {
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

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        title = "signature",
        border = "single",
      })

      require("go").setup({
        lsp_cfg = false,
      })

      mason.setup()

      local on_attach = function(client, bufnr)
        if client.name == "ruff" then
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false
        end
      end

      lspconfig.basedpyright.setup({})
      lspconfig.ruff.setup({
        on_attach = on_attach,
      })
      lspconfig.yamlls.setup({})
      lspconfig.terraformls.setup({})
      lspconfig.ts_ls.setup({})
      lspconfig.eslint.setup({})
      lspconfig.html.setup({})
      lspconfig.cssls.setup({})
      lspconfig.kotlin_language_server.setup({})
      lspconfig.zls.setup({})

      local go_cfg = require("go.lsp").config()
      lspconfig.gopls.setup(go_cfg)
    end,
    keys = {
      { "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { noremap = true, silent = true } },
    },
  },

  -- Default rust LSP kinda sucks so we use this plugin instead
  {
    "mrcjkb/rustaceanvim",
    ft = "rust",
    version = "^4",
  },

  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
}
