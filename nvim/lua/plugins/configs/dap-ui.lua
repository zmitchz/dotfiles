local options = {
  icons = { expanded = "▾", collapsed = "▸" },
  expand_lines = true,
  layouts = {
    {
      elements = {
        "scopes",
      },
      size = 0.3,
      position = "right",
    },
    {
      elements = {
        "repl",
        "breakpoints",
      },
      size = 0.3,
      position = "bottom",
    },
  },
  floating = {
    max_height = nil,
    max_width = nil,
    border = "single",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil,
  },
  controls = {
    enabled = true,
    element = "repl",
  },
}

return options
