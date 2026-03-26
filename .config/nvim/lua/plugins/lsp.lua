return {
  "b0o/schemastore.nvim",
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "codelldb",
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "basedpyright",
        "cssls",
        "eslint",
        "gopls",
        "html",
        "jsonls",
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
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      "b0o/schemastore.nvim",
    },
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
      },
    },
    config = function()
      local function setup(ls, config)
        if config then
          vim.lsp.config[ls] = config
        end
        vim.lsp.enable(ls)
      end

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

      setup("basedpyright", {})
      setup("lua_ls", {})
      setup("ruff", {
        on_attach = on_attach,
      })
      setup("yamlls", {
        settings = {
          yaml = {
            schemaStore = {
              -- You must disable built-in schemaStore support if you want to use
              -- this plugin and its advanced options like `ignore`.
              enable = false,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      })
      setup("jsonls", {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })
      setup("terraformls", {})
      setup("ts_ls", {})
      setup("eslint", {})
      setup("html", {})
      setup("cssls", {})
      setup("kotlin_language_server", {})
      setup("zls", {})

      local go_cfg = require("go.lsp").config()
      setup("gopls", go_cfg)
    end,
    keys = {
      { "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { noremap = true, silent = true } },
    },
  },

  -- Default rust LSP kinda sucks so we use this plugin instead
  {
    "mrcjkb/rustaceanvim",
    ft = "rust",
    version = "^6",
    init = function()
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              ["cargo"] = {
                ["targetDir"] = true,
              },
              ["check"] = {
                ["workspace"] = false,
              },
            },
          },
        },
      }
    end,
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
