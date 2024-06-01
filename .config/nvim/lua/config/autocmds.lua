-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      local opts = { noremap = true, silent = true, buffer = true }
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    bufmap("n", "<leader>h", "<cmd>lua vim.lsp.buf.hover()<cr>")
    bufmap("n", "<leader>ds", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
    bufmap("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<cr>")
    bufmap("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<cr>")
    bufmap("n", "<leader>do", "<cmd>lua vim.diagnostic.open_float()<cr>")
    bufmap("n", "<leader>da", "<cmd>lua vim.lsp.buf.code_action()<cr>")

    vim.lsp.inlay_hint.enable()
  end,
})
