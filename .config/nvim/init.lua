-- Lazy package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("options")

local default_opts = { noremap = false, silent = true }

-- Mappings
local merge_tb = vim.tbl_deep_extend

local mappings = require("mappings")

for mode, commands in pairs(mappings) do
  for _, command in ipairs(commands) do
    local mapping = command[1]
    local func = command[2]
    local opts = merge_tb("force", default_opts, command[3])

    vim.keymap.set(mode, mapping, func, opts)
  end
end

require("lazy").setup("plugins")
