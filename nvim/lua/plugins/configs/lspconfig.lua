local M = {}

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
        lineFoldingOnly = true
    },
}

require("lspconfig").lua_ls.setup {
    capabilities = M.capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                    [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                    [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
        },
    },
}

require'lspconfig'.clangd.setup{
    capabilities = M.capabilities,
}
require'lspconfig'.pyright.setup{
    capabilities = M.capabilities,
}
require'lspconfig'.rust_analyzer.setup{
    capabilities = M.capabilities,
}
require'lspconfig'.texlab.setup{
    capabilities = M.capabilities,
}
require'lspconfig'.yamlls.setup{
    capabilities = M.capabilities,
}


vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        local bufnr = ev.buf
        require("mappings").plugins.lspconfig(bufnr)
    end,
})
return M
