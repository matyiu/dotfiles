return {
	{"L3MON4D3/LuaSnip"},
	{"godlygeek/tabular"},
	{"folke/tokyonight.nvim"},
	{"preservim/vim-markdown"},
	{"TimUntersberger/neogit"},
	{"ryanoasis/vim-devicons"},
	{"benfowler/telescope-luasnip.nvim"},
	{"nvim-telescope/telescope-ui-select.nvim"},
  {
    "nvim-telescope/telescope-project.nvim",
    after = "telescope.nvim",
    config = function ()
      require("telescope").load_extension("project")
    end
  },
  {
    "nvim-telescope/telescope.nvim",
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

  },
  {
    "gelguy/wilder.nvim",
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
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
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

        -- Microsoft
        b.formatting.csharpier.with {
          command = "dotnet",
          args = { "csharpier", "--write-stdout" }
        },

        -- Shell
        b.formatting.shfmt,
        b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
      }

      null_ls.setup {
        debug = true,
        sources = sources,
      }
    end,
  },
  {
    "CRAG666/code_runner.nvim",
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
  },
  {
    "lukas-reineke/indent-blankline.nvim",
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
  },
  {
    "beauwilliams/focus.nvim",
    config = function()
      require("focus").setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function ()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false
  },
  {
    "Pocco81/auto-save.nvim",
    config = function ()
      require("auto-save").setup {}
    end,
    lazy = false
  },
  {
    "mfussenegger/nvim-dap",
    lazy = false,
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function ()
      require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
    end
  },
  {
    "microsoft/vscode-js-debug",
    version = "v1.74.1",
    run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    version = "v1.1.0",
    config = function ()
      require("dap-vscode-js").setup({
        adapters = {
          "pwa-node",
        },
        debugger_path = "/home/rjeffvalle/bin/vscode-js-debug",
      })

      for _, language in ipairs({ "typescript", "javascript" }) do
        require('dap').configurations[language] = {
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            cwd = "${workspaceFolder}",
            rootPath = "${workspaceFolder}",
            continueOnAttach = true,
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Mocha Tests",
            runtimeExecutabe = "node",
            runtimeargs = {
              "--inspect-brk",
              "./node_modules/mocha/bin/mocha",
              "${file}",
            },
            cwd = require('custom.helpers.node').get_cwd,
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          },
          require('custom.daps.job.flexxible').ProcessAgentLog,
          require('custom.daps.azure.functions').functions
        }
      end
    end,
    dependencies = {
      "mfussenegger/nvim-dap"
    },
    lazy = false
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function ()
      require("dapui").setup()
    end,
    dependencies = {
      "mfussenegger/nvim-dap"
    },
    lazy = false,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = false,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  -- {
  --   "pmizio/typescript-tools.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --   opts = {},
  -- }
}
