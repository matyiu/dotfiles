local M = {
   functions = {
    type = "pwa-node",
    request = "launch",
    name = "Azure Function: start",
    runtimeExecutabe = "func host start",
    cwd = require('custom.helpers.node').get_func_cwd,
    console = "integratedTerminal",
    internalConsoleOptions = "neverOpen",
  }
}

return M
