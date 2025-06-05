return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
    event = "VeryLazy",
    config = function()
      local telescope = require("telescope")
      telescope.setup()
      telescope.load_extension("ui-select")
    end,
    keys = {
      -- find
      { "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find file" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffer" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Open recent file" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find in all files", remap = true },
      {
        "<leader>fs",
        "<cmd>lua require'telescope.builtin'.lsp_document_symbols{symbols={'function', 'class', 'method'}}<cr>",
        desc = "Find document functions and classes",
        remap = true,
      },

      -- lsp stuff
      {
        "<leader>d",
        "<cmd>lua require'telescope.builtin'.diagnostics{bufnr=0}<cr>",
        desc = "Open diagnostics",
        remap = true,
        silent = true,
      },
      {
        "<leader>gi",
        "<cmd>lua require'telescope.builtin'.lsp_implementations{}<cr>",
        desc = "Go to implementations",
        remap = true,
        silent = true,
      },
      {
        "<leader>gr",
        "<cmd> lua require'telescope.builtin'.lsp_references{}<cr>",
        desc = "Go to references",
        remap = true,
        silent = true,
      },
      {
        "<leader>gd",
        "<cmd>lua require'telescope.builtin'.lsp_definitions{}<cr>",
        desc = "Go to definitions",
        remap = true,
        silent = true,
      },
    },
  },
}
