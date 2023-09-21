local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "phpactor", "tsserver", "vala_ls" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end

-- Setup omnisharp
local pid = vim.fn.getpid()

local on_attach_omnisharp = function (client, bufnr)
  client.server_capabilities.semanticTokensProvider = nil
  on_attach(client, bufnr)
end

local omnisharp_bin = "/usr/local/bin/omnisharp/OmniSharp"
lspconfig.omnisharp.setup {
  cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
  on_attach = on_attach_omnisharp,
  capabilities = capabilities,
}

-- Setup Bicep
local bicep_lsp_bin = "/usr/local/bin/bicep-langserver/Bicep.LangServer.dll"
lspconfig.bicep.setup {
  cmd = { "dotnet", bicep_lsp_bin },
}

-- Bicep file detection
vim.cmd [[ autocmd BufNewFile,BufRead *.bicep set filetype=bicep ]]

