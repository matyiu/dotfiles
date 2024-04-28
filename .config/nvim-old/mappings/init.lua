local M = {}

M.nvimtree = {}

M.general = {
  n = {
    ["<C-h>"] = { "<cmd> TmuxNavigateLeft<CR>", "window left" },
    ["<C-l>"] = { "<cmd> TmuxNavigateRight<CR>", "window right" },
    ["<C-j>"] = { "<cmd> TmuxNavigateDown<CR>", "window down" },
    ["<C-k>"] = { "<cmd> TmuxNavigateUp<CR>", "window up" },
    ["<space>fe"] = { "<cmd> EslintFixAll<CR>", "Fix all eslint problems" },
    ["<space>db"] = { "<cmd> DapToggleBreakpoint<CR>", "Debugger: toggle breakpoint" },
    ["<leader>dv"] = { "<cmd> DapStepOver<CR>", "Debugger: step over" },
    ["<leader>di"] = { "<cmd> DapStepInto<CR>", "Debugger: step in" },
    ["<leader>do"] = { "<cmd> DapStepOut<CR>", "Debugger: step out" },
    ["<leader>dt"] = { "<cmd>lua require('dapui').toggle()<CR>", "Debugger: toggle UI" },
    ["<leader>dc"] = { "<cmd> DapContinue<CR>", "Debugger: continue" },
    ["<leader>sw"] = { "<cmd> SetCWD<CR>", "Debugger: set working directory" },
  },
}

return M
