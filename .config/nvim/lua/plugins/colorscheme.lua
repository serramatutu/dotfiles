return {
  {
    "Shatur/neovim-ayu",
    name = "ayu",
    config = function()
      local colors = require("ayu.colors")
      colors.generate()

      local normal = { fg = colors.fg, bg = "#000000" }
      local cursor = {
        fg = "#ffffff",
        bg = "#ff0000",
      }

      require("ayu").setup({
        dark = true,
        terminal = true,
        overrides = {
          Normal = normal,
          NormalFloat = normal,
          Visual = {
            bg = colors.fg,
            fg = colors.bg,
          },
          TermCursor = cursor,
          Cursor = cursor,
          LineNr = { fg = colors.fg },
          CursorLineNr = { fg = colors.bg, bg = colors.fg },
        },
      })
    end,
  },
}
