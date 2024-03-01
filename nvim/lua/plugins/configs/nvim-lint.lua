require('lint').linters_by_ft = {
    markdown = { "vale" },
    python = { "pylint" },
    latex = { "chktex", "lacheck" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end,
})
