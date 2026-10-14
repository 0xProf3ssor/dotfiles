vim.opt.number = true       -- show absolute line number
vim.opt.relativenumber = true

-- Fix for smear cursor animation
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

-- Java tab settings for Spring Boot development
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})
-- Treat .h files as C files (Neovim defaults .h to cpp)
vim.g.c_syntax_for_h = 1

-- C and C++ (including headers) tab settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt_local.tabstop = 8
    vim.opt_local.shiftwidth = 8
    vim.opt_local.expandtab = true
  end,
})
