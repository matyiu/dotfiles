local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "phpactor", "vala_ls", "eslint", "pylsp", "tsserver", "marksman", "ansiblels" }

local on_attach = function (client, bufnr)
  require('plugins.configs.lspconfig').on_attach(client, bufnr)
  client.server_capabilities.semanticTokensProvider = nil
end

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = function (client, bufnr)
      on_attach(client, bufnr)
      client.server_capabilities.semanticTokensProvider = nil
    end,
    capabilities = capabilities
  }
end

lspconfig.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = function (...)
    return require("lspconfig.util").root_pattern(".git")(...)
  end
}

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

