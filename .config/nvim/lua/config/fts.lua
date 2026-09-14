-- hlsl
vim.filetype.add({
  extension = {
    hlsl = "hlsl",
    hlsli = "hlsl",
  },
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "hlsl", },
  callback = function() 
    vim.treesitter.start();
    vim.bo.commentstring = "// %s"
  end,
})
