-- Custom nvim commands

vim.api.nvim_create_user_command("CopyPath", ":let @+ = expand('%:p')", { nargs = 0 })
