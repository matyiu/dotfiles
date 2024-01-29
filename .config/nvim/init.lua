local g = vim.g

vim.wo.wrap = false

--[[
vim.api.nvim_set_keymap('i', '<c-j>', 'pumvisible() ? "\\<c-n>" : "\\<c-j>"' , { noremap = true, expr=true })
vim.api.nvim_set_keymap('i', '<c-k>', 'pumvisible() ? "\\<c-p>" : "\\<c-j>"' , { noremap = true, expr=true })
vim.api.nvim_set_keymap('n', '<space>f', function () vim.lsp.buf.format { async = true } end, { noremap = true, expr = true })
--]]

g.neovide_refresh_rate=65
g.neovide_transparency=0.8

-- Neovide Cursor
g.neovide_cursor_animation_length=0.05
g.neovide_cursor_trail_length=0.01
g.neovide_cursor_scroll_length=0.2

g.neovide_cursor_vfx_mode = "railgun"
g.neovide_remember_dimensions = true;
g.neovide_remember_window_size = true
g.neovide_no_idle = false;

vim.opt.guifont = { "JetBrains Mono NL", ":h16" }
vim.opt.wildignore:append('**/node_modules')
vim.opt.wildignore:append('node_modules')
vim.opt.wildignore:append('.git')

-- Rememeber last editing position.
--[[
local api = vim.api
api.nvim_create_autocmd({ 'BufRead', 'BufReadPost' }, {
  callback = function()
    local row, column = table.unpack(api.nvim_buf_get_mark(0, '"'))
    local buf_line_count = api.nvim_buf_line_count(0)

    if row >= 1 and row <= buf_line_count then
      api.nvim_win_set_cursor(0, { row, column })
    end
  end,
})
--]]


vim.api.nvim_create_user_command('SetCWD', function ()
  local package_json_path = vim.fn.findfile('package.json', '.;', -1)[0]
  if package_json_path ~= '' then
    local project_dir = vim.fn.fnamemodify(package_json_path, ':h')
    vim.fn.jobstart("pwd", { cwd = project_dir })
  else
    print("Error: package.json not found in the current or parent directories.")
  end
end
, {})

-- LSP diagnostics tweaks
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
  }
)
