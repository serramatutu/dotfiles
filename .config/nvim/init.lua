-- <Space> as leader (needs to be done before lazy)
vim.g.mapleader = " "
require("config.lazy")
require("config.options")
require("config.cmds")
require("config.autocmds")
require("config.keymaps")
require("config.fts")
vim.cmd("colorscheme onedark_dark")
