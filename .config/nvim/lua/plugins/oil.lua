return {
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        delete_to_trash = true,
        lsp_file_methods = {
          timeout_ms = 1000,
          autosave_changes = true,
        },
      })
    end
  }
}
