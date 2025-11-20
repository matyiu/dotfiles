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
