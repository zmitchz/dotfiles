local opts = {
  formatters_by_ft = {
    ["*"] = { "trim_whitespace" },
    css = { { "prettierd", "prettier" } },
    javascript = { { "prettierd", "prettier" } },
    typescript = { { "prettierd", "prettier" } },
    typescriptreact = { { "prettierd", "prettier" } },
    lua = { "stylua" },
    python = { "isort", "black" },
    rust = { "rustfmt" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = false,
  },
}

return opts
