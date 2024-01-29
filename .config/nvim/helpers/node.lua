local M = {}

M.get_cwd = function ()
  local package_json_path = vim.fn.findfile('package.json', '.;', -1)[0]
  if package_json_path ~= '' then
    local project_dir = vim.fn.fnamemodify(package_json_path, ':h')

    return project_dir
  else
    print("Error: package.json not found in the current or parent directories.")
  end

  return ''
end

M.get_mocha_executable = function ()
  local cwd = M.get_cwd()

  return cwd .. '/node_modules/mocha/bin/mocha'
end

return M
