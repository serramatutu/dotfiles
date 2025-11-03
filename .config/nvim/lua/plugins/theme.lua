return {
  {
    "Shatur/neovim-ayu",
    name = "ayu",
    lazy = false,
    priority = 10000,
    config = function()
      local ayu = require("ayu")

      local colors = require("ayu.colors")
      colors.generate()

      local cursor = {
        fg = "#ffffff",
        bg = "#ff0000",
      }

      ayu.setup({
        dark = true,
        overrides = {
          TermCursor = cursor,
          Cursor = cursor,
          LineNr = { fg = colors.fg },
          CursorLineNr = { fg = colors.bg, bg = colors.fg },
        },
      })
      ayu.colorscheme()
    end,
  },
}
