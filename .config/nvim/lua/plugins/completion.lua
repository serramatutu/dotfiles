return {
  {
    "ms-jpq/coq_nvim",
    branch = "coq",
    event = "VeryLazy",
    build = ":COQdeps",
    init = function()
      vim.g.coq_settings = {
        auto_start = "shut-up",
        match = {
          look_ahead = 1,
        },
      }
    end,
    dependencies = {
      {
        "ms-jpq/coq.artifacts",
        branch = "artifacts",
      },
    },
  },
}
