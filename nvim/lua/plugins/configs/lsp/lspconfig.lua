local M = {}

M.on_attach = function(client, bufnr)
  local signs = { Error = "", Warn = "", Hint = "󰘥", Info = "" }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
  vim.diagnostic.config {
    signs = {
      linehl = {
        [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      },
      numhl = {
        [vim.diagnostic.severity.WARN] = "WarningMsg",
      },
    },
  }
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument = {
  completion = {
    completionItem = {
      documentationFormat = { "markdown", "plaintext" },
      snippetSupport = true,
      preselectSupport = true,
      insertReplaceSupport = true,
      labelDetailsSupport = true,
      deprecatedSupport = true,
      commitCharactersSupport = true,
      tagSupport = { valueSet = { 1 } },
      resolveSupport = {
        properties = {
          "documentation",
          "detail",
          "additionalTextEdits",
        },
      },
    },
  },
  foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  },
}

require("lspconfig").arduino_language_server.setup {
  on_attach = M.on_attach,
}

require("lspconfig").bashls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}
require("lspconfig").lua_ls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  require "plugins.configs.lsp.lua-lsp",
}

require("lspconfig").clangd.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").cssls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

require("lspconfig").ltex.setup {}

require("lspconfig").pyright.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}
require("lspconfig").rust_analyzer.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}
require("lspconfig").texlab.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}
require("lspconfig").tsserver.setup {
  on_attach = M.on_attach,
}

require("lspconfig").yamlls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    local bufnr = ev.buf
    require("mappings").plugins.lspconfig(bufnr)
  end,
})
return M
