local languages = {
  "lua",
  "vim",
  "vimdoc",
  "javascript",
  "html",
  "css",
  "markdown",
  "markdown_inline",
  "dockerfile",
  "yaml",
  "json",
  "c_sharp",
  "bicep",
  "python",
}

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = languages,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
