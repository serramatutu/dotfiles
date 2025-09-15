return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
      },
    },
    event = "VeryLazy",
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        layout_config = {
          vertical = { width = 0.9 },
          horizontal = { width = 0.9 },
        },
      })
      telescope.load_extension("ui-select")
      telescope.load_extension("live_grep_args")
      telescope.load_extension("fzf")
    end,
    keys = {
      -- find
      { "<leader>ff", "<cmd>Telescope find_files hidden=true layout_strategy=vertical<cr>", desc = "Find file" },
      { "<leader>fb", "<cmd>Telescope buffers layout_stategy=vertical<cr>", desc = "Find buffer" },
      { "<leader>fr", "<cmd>Telescope oldfiles layout_strategy=vertical<cr>", desc = "Open recent file" },
      {
        "<leader>fg",
        "<cmd>Telescope live_grep_args layout_strategy=vertical<cr>",
        desc = "Find in all files",
        remap = true,
      },
      {
        "<leader>fs",
        "<cmd>lua require'telescope.builtin'.lsp_document_symbols{symbols={'function', 'class', 'method'}}<cr>",
        desc = "Find document functions and classes",
        remap = true,
      },
      {
        "<leader>fm",
        "<cmd>lua require'telescope.builtin'.marks{}<cr>",
        desc = "Find marks",
        remap = true,
      },

      -- lsp stuff
      {
        "<leader>fd",
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
