-- collection of random quality-of-life improvement plugins
return {
  -- better indent
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    -- issue with latest nvim
    -- https://github.com/lukas-reineke/indent-blankline.nvim/issues/936
    tag = "v3.8.2",
  },
  -- better comments
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
  },
  -- better marks
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {
      default_mappings = true,
    },
  },
  -- better quickfix list
  {
    "stevearc/quicker.nvim",
    event = "FileType qf",
    keys = {
      {
        "<leader>c",
        function()
          require("quicker").toggle()
        end,
        desc = "Toggle quickfix",
      },
      {
        "<leader>v",
        function()
          require("quicker").toggle({ loclist = true })
        end,
        desc = "Toggle loclist",
      },
    },
  },
}
