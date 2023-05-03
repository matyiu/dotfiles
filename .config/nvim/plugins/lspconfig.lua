local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "phpactor" }

local util = require "lspconfig.util"

lspconfig.tsserver.setup {
  root_dir = util.root_pattern('.git'),
  on_attach = on_attach,
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end

