return {
  {
    "ms-jpq/coq_nvim",
    branch = "coq",
    main = "coq",
    event = "VeryLazy",
    dependencies = {
      {
        "ms-jpq/coq.artifacts",
        branch = "artifacts",
      },
    },
    opts = {
      clients = {
        lsp = {
          enabled = true,
        },
      },
    },
  },
}
