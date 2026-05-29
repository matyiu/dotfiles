local normal = {
  { "<leader>n",  "<cmd> set number!<CR>",          { desc = "Toggle number lines" } },
  { "<leader>rn", "<cmd> set relativenumber!<CR>",  { desc = "Toggle relative lines" } },
  { "<C-c>a",     "<cmd> CodeCompanionActions<CR>", { desc = "Open code companion action menu" } },
}

local term = {
  { "<Esc>", [[<C-\><C-n>]], { noremap = true } }
}

return {
  n = normal,
  t = term,
}
