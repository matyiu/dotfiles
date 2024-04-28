return {
  {
    "numToStr/FTerm.nvim",
    config = function()
      local fterm = require("FTerm")

      vim.api.nvim_create_user_command("FTermOpen", fterm.open, { bang = true })
      vim.api.nvim_create_user_command("FTermClose", fterm.close, { bang = true })
      vim.api.nvim_create_user_command("FTermExit", fterm.exit, { bang = true })
      vim.api.nvim_create_user_command("FTermToggle", fterm.toggle, { bang = true })

      vim.keymap.set("n", "<leader>tt", "<cmd>FTermToggle<CR>", {})
      vim.keymap.set("n", "<leader>to", "<cmd>FTermOpen<CR>", {})
      vim.keymap.set("n", "<leader>tc", "<cmd>FTermClose<CR>", {})
      vim.keymap.set("n", "<leader>tq", "<cmd>FTermExit<CR>", {})

      vim.keymap.set("n", "<leader>tg", function()
        fterm.run("lazygit")
      end, {})
    end,
  },
}
