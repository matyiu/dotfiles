return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = false,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   "BufReadPre path/to/my-vault/**.md",
    --   "BufNewFile path/to/my-vault/**.md",
    -- },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      legacy_commands = false,
      -- obsidian_command = "setsid /usr/bin/obsidian",
      workspaces = {
        {
          name = "personal",
          path = "~/Nextcloud/Personal/Notes",
          overrides = {
            -- new_notes_location = "0 - Index",
            note_id_func = function(title)
              local timestamp = os.date "%Y%m%d%H%M"
              local suffix = ""
              if title ~= nil and title ~= "" then
                suffix = "-" .. title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
              end
              return timestamp .. suffix
            end
          },
        }
      },
    },
  }
}
