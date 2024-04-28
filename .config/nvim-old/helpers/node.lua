local M = {}

local function find_root_by_file(file_name)
  local file_path = vim.fn.findfile(file_name, '.;', -1)[0]
  if file_path ~= '' then
    local project_dir = vim.fn.fnamemodify(file_path, ':h')

    return project_dir
  else
    print("Error: " + file_name +  " not found in the current or parent directories.")
  end

  return ''
end

M.get_func_cwd = function ()
  return find_root_by_file('host.json')
end

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
