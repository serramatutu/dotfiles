return {
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
}
