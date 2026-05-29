llm = {
  fast = {
    http = {
      name = "ollama",
    },
    acp = {
      name = "opencode",
    }
  }
}

-- lazy.nvim
return {
  {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    opts = {
      log_level = 'DEBUG',
      interactions = {
        chat = {
          adapter = llm.fast.acp,
        },
        inline = {
          adapter = llm.fast.http,
        },
        cmd = {
          adapter = llm.fast.http,
        },
        background = {
          adapter = llm.fast.http,
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({})
    end,
  },
}
