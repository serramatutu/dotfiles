return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      vim.g.gitblame_display_virtual_text = 0
      local git_blame = require("gitblame")

      require("lualine").setup({
        options = {
          theme = "ayu_dark",
          section_separators = "",
          component_separators = "",
        },
        sections = {
          lualine_b = {
            { "lsp_status" },
          },
          lualine_c = {
            {
              "buffers",
              buffers_color = {
                active = "lualine_c_inactive",
                inactive = "lualine_c_normal",
              },
              symbols = {
                modified = "",
                alternate_file = "",
                directory = "",
              },
            },
          },
          lualine_x = {
            { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
          },
          lualine_y = {
            { "diff" },
          },
          lualine_z = {
            { "branch" },
          },
        },
      })
    end,
  },
}
