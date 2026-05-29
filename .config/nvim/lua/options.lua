local opt = vim.opt

-- Tabs to 2 spaces
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.clipboard = "unnamedplus"

-- Numbers
opt.number = true
opt.numberwidth = 1

-- Map leader key to space
vim.g.mapleader = " "

-- Conceallevel
vim.opt.conceallevel = 2
vim.g.markdown_recommended_style = 0

-- Folding
---- Set a high fold level so everything starts expanded
opt.foldlevel = 99
opt.foldlevelstart = 99

-- Ensure folding is enabled so you can still use manual commands
opt.foldenable = true
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

