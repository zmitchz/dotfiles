local options = {
    signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "󰍵" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "│" },
    },
    on_attach = function(bufnr)
        require("mappings").plugins.gitsigns(bufnr)
    end,
}

return options
