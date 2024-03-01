local rainbow_delimiters = require("rainbow-delimiters")
local options = {
    strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        vim = rainbow_delimiters.strategy['local'],
    },
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
    },
    highlight = {
        'RainbowDelimiterViolet',
        'RainbowDelimiterGreen',
        'RainbowDelimiterBlue',
        'RainbowDelimiterRed',
        'RainbowDelimiterCyan',
        'RainbowDelimiterOrange',
        'RainbowDelimiterYellow',
    },
}

return options
