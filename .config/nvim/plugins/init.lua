local M = {}

M.telescope_project = {
  after = "telescope.nvim",
  config = function ()
    require("telescope").load_extension("project")
  end
}

M.wilder = {
  config = function()
    local wilder = require "wilder"
    wilder.setup {
      next_key = "<C-j>",
      accept_key = "<C-l>",
      reject_key = "<C-h>",
      previous_key = "<C-k>",
      modes = { ":", "/", "?" },
    }
    wilder.set_option(
      "renderer",
      wilder.popupmenu_renderer(wilder.popupmenu_border_theme {
        pumblend = 20,
        border = "rounded",
        highlights = { border = "Normal" },
        highlighter = wilder.basic_highlighter(),
        left = { " ", wilder.popupmenu_devicons() },
      })
    )
  end,
}

M.telescope = {
  override_options = {
    defaults = {
      initial_mode = "insert",
      mappings = {
        i = {
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",
        },
        n = {},
      },
    },
    extensions = {
      file_browser = {
        hijack_netrw = true,
        path = "%:p:h",
        mappings = {
          ["i"] = {},
          ["n"] = {},
        },
      },
      project = {
        base_dirs = {
          {"~/Code", max_depth = 4},
          "~/Projects"
        }
      }
    },
  }
}

-- ######################################
-- VIM MARKDOWN
-- ######################################
M.vim_markdown = {
  config = function() end,
}

-- ######################################
-- NVIM-CMP
-- ######################################
M.cmp = {
  config = function()
    local cmp = require "cmp"
    cmp.setup {
      mapping = cmp.mapping.preset.insert {
        ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<Tab>"] = cmp.mapping(function() end, { "i", "s" }),
      },
    }
  end,
}

-- ######################################
-- NULL-LS
-- ######################################
M.null_ls = {
  config = function()
    local present, null_ls = pcall(require, "null-ls")

    if not present then
      return
    end

    local b = null_ls.builtins

    local sources = {

      -- webdev stuff
      b.formatting.deno_fmt,
      b.formatting.prettier,

      -- Lua
      b.formatting.stylua,

      -- Shell
      b.formatting.shfmt,
      b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
    }

    null_ls.setup {
      debug = true,
      sources = sources,
    }
  end,
}

-- ######################################
-- FOCUS
-- ######################################
M.focus = {
  config = function()
    require("focus").setup()
  end,
}

-- ######################################
-- CODE-RUNNER
-- ######################################
M.code_runner = {
  config = function()
    require("code_runner").setup {
      focus = false,
      filetype = {
        -- java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
        -- python = "python3 -u",
        -- typescript = "deno run",
        -- rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt",
        -- dart = "dart $dir/$fileName",
        excluded_buftypes = { "message" },
      },
    }
  end,
}

M.indent_blankline = {
  config = function()
    vim.opt.termguicolors = true
    vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

    vim.opt.list = true
    -- vim.opt.listchars:append "space:⋅"
    -- vim.opt.listchars:append "eol:↴"

    require("indent_blankline").setup {
      space_char_blankline = " ",
      char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
      },
    }
  end,
}

M.nvim_lspconfig = {
  config = function ()
    require "plugins.configs.lspconfig"
    require "custom.plugins.lspconfig"
  end
}

M.vim_tmux_navigator = {
  lazy = false
}

M.auto_save = {
  config = function ()
    require("auto-save").setup {}
  end
}

M.vim_gutentags = {}

M.vim_js_file_import = {}

return {
  ["L3MON4D3/LuaSnip"] = {},
  ["godlygeek/tabular"] = {},
  ["folke/tokyonight.nvim"] = {},
  ["preservim/vim-markdown"] = {},
  ["TimUntersberger/neogit"] = {},
  ["ryanoasis/vim-devicons"] = {},
  ["benfowler/telescope-luasnip.nvim"] = {},
  ["nvim-telescope/telescope-ui-select.nvim"] = {},
  -- ["nvim-telescope/telescope-file-browser.nvim"] = {},
  ["nvim-telescope/telescope-project.nvim"] = M.telescope_project,
  ["nvim-telescope/telescope.nvim"] = M.telescope,
  ["gelguy/wilder.nvim"] = M.wilder,
  ["jose-elias-alvarez/null-ls.nvim"] = M.null_ls,
  ["CRAG666/code_runner.nvim"] = M.code_runner,
  ["lukas-reineke/indent-blankline.nvim"] = M.indent_blankline,
  ["beauwilliams/focus.nvim"] = M.focus,
  ["neovim/nvim-lspconfig"] = M.nvim_lspconfig,
  ["christoomey/vim-tmux-navigator"] = M.vim_tmux_navigator,
  ["Pocco81/auto-save.nvim"] = M.auto_save,
  ["ludovicchabant/vim-gutentags"] = M.vim_gutentags,
  ["kristijanhusak/vim-js-file-import"] = M.vim_js_file_import,
}
