require("nvim-dap-repl-highlights").setup()

local options = {
  ensure_installed = { "c", "dap_repl", "lua", "python", "rust" },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },
}

return options
