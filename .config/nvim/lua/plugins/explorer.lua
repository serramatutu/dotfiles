return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      {
        "<leader>tt",
        function()
          Snacks.explorer.reveal()
        end,
        desc = "Toggle file tree",
      },
    },
    opts = {
      explorer = {
        enabled = true,
        replace_netrw = true,
      },
      picker = {
        sources = {
          explorer = {
            layout = { preset = "vertical" },
            ignored = true,
            hidden = true,
            auto_close = true,
            win = {
              list = {
                wo = {
                  relativenumber = true,
                },
              },
            },
          },
        },
      },
    },
  },
}
