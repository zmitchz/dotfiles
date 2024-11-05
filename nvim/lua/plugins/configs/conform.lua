local opts = {
  formatters_by_ft = {
    ["*"] = { "trim_whitespace" },
    css = { "prettierd", "prettier" },
    java = { "google-java-format" },
    javascript = { "prettierd", "prettier" },
    lua = { "stylua" },
    markdown = { "markdownlint" },
    python = { "isort", "black" },
    rust = { "rustfmt" },
    typescript = { "prettierd", "prettier" },
    typescriptreact = { "prettierd", "prettier" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = false,
  },
}

return opts
