-- Insert newlines
vim.keymap.set("n", "<M-cr>", "i<cr><Esc>", { desc = "Insert newline at cursor" })
vim.keymap.set("i", "<M-cr>", "<Esc>i<cr>", { desc = "Insert newline at cursor" })

-- Buffer navigation
vim.keymap.set("n", "H", "<cmd>:bp<cr>", { desc = "Switch to previous buffer" })
vim.keymap.set("n", "L", "<cmd>:bn<cr>", { desc = "Switch to next buffer" })

-- Quickfix navigation
vim.keymap.set("n", "<C-j>", "<cmd>:cn<cr>", { desc = "Next item in quickfix list" })
vim.keymap.set("n", "<C-k>", "<cmd>:cp<cr>", { desc = "Previous item in quickfix list" })

-- Tab navigation
vim.keymap.set("n", "<Tab>-", "<cmd>:sp<cr>", { desc = "Split horizontal" })
vim.keymap.set("n", "<Tab>_", "<cmd>:vsp<cr>", { desc = "Split vertical" })
vim.keymap.set("n", "<Tab>h", "<C-w>h", { desc = "Split vertical", noremap = true })
vim.keymap.set("n", "<Tab>j", "<C-w>j", { desc = "Split vertical", noremap = true })
vim.keymap.set("n", "<Tab>k", "<C-w>k", { desc = "Split vertical", noremap = true })
vim.keymap.set("n", "<Tab>l", "<C-w>l", { desc = "Split vertical", noremap = true })
vim.keymap.set("n", "<Tab>q", "<cmd>tabclose<cr>", { desc = "Close current tab", noremap = true })

-- Move Lines
vim.keymap.set("n", "<M-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<M-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("i", "<M-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<M-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
vim.keymap.set("v", "<M-j>", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "<M-k>", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

-- Keep visual line mode when indenting
vim.keymap.set("v", "<", "<gv", { noremap = true })
vim.keymap.set("v", ">", ">gv", { noremap = true })

-- Diagnostics
vim.diagnostic.config({
  underline = true,
  virtual_text = {
    -- source = "always",  -- Or "if_many"
    prefix = "●", -- Could be '■', '▎', 'x'
  },
  severity_sort = true,
  float = {
    source = "always", -- Or "if_many"
  },
})
