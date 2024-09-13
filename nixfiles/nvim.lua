vim.opt.shell = vim.fn.executable('nu') and 'nu' or 'bash'

vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 2
vim.opt.expandtab = false

require 'lspconfig'.nil_ls.setup {} -- Set up nil

