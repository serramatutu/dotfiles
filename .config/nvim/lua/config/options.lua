-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- <Space> as leader
vim.g.mapleader = " "

-- display relative line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- highlight cursor
vim.wo.cursorline = true
vim.wo.cursorcolumn = true

-- colors
vim.opt.guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20"

-- use ripgrep for :grep
vim.opt.grepprg = "rg"
