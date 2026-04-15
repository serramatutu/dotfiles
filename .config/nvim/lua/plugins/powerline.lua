return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      vim.g.gitblame_display_virtual_text = 0
      local git_blame = require("gitblame")

      local colors = require("ayu.colors")
      colors.generate()

      require("lualine").setup({
        options = {
          theme = "ayu_dark",
          section_separators = "",
          component_separators = "",
        },
        sections = {
          lualine_a = {},
          lualine_b = {
            { "lsp_status" },
          },
          lualine_c = {},
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
        tabline = {
          lualine_a = {
            {
              "buffers",
              buffers_color = {
                active = { fg = colors.bg, bg = colors.accent },
                inactive = { fg = colors.fg, bg = colors.bg },
              },
              symbols = {
                modified = "",
                alternate_file = "",
                directory = "",
              },
            },
          },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },
}
