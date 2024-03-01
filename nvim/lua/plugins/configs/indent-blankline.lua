local M = {}

local highlight = {
    'RainbowDelimiterViolet',
    'RainbowDelimiterGreen',
    'RainbowDelimiterBlue',
    'RainbowDelimiterRed',
    'RainbowDelimiterCyan',
    'RainbowDelimiterOrange',
    'RainbowDelimiterYellow',
}

M.init = function()
    local hooks = require "ibl.hooks"
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#56B6C2" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#E5C07B" })
    end)

    vim.g.rainbow_delimiters = { highlight = highlight }
    require("ibl").setup { scope = { highlight = highlight } }
    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
end

M.opts = {
    exclude = {
        filetypes = {
            "help",
            "terminal",
            "lazy",
            "lspinfo",
            "TelescopePrompt",
            "TelescopeResults",
            "mason",
            "",
        },
    },
    indent = {
        highlight = highlight,
    },
    scope = {
        enabled = true,
        show_start = true,
        include = {
            node_type = { lua = { "return_statement", "table_constructor" } },
        },
    },
    whitespace = {
        highlight = highlight,
    },
}

return M
