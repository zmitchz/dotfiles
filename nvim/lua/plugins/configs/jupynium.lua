  -- python_host = { "conda", "run", "--no-capture-output", "-n", "jupynium", "python" },
local options = {
  python_host = "jupynium",
  default_notebook_URL = "localhost:8888/nbclassic",

  jupyter_command = "",

  notebook_dir = nil,

  firefox_profiles_ini_path = "/home/mitchell/.mozilla/firefox/profiles.ini",
  firefox_profile_name = "jupynium",

  auto_start_server = {
    enable = false,
    file_pattern = { "*.ju.*" },
  },

  auto_attach_to_server = {
    enable = true,
    file_pattern = { "*.ju.*", "*.md" },
  },

  auto_start_sync = {
    enable = false,
    file_pattern = { "*.ju.*", "*.md" },
  },

  auto_download_ipynb = true,

  auto_close_tab = true,

  autoscroll = {
    enable = true,
    mode = "always", -- "always" or "invisible"
    cell = {
      top_margin_percent = 20,
    },
  },

  scroll = {
    page = { step = 0.5 },
    cell = {
      top_margin_percent = 20,
    },
  },

  jupynium_file_pattern = { "*.ju.*" },

  use_default_keybindings = true,
  textobjects = {
    use_default_keybindings = true,
  },

  syntax_highlight = {
    enable = true,
  },

  shortsighted = false,

  kernel_hover = {
    floating_win_opts = {
      max_width = 84,
      border = "none",
    },
  },
}

vim.cmd [[
hi! link JupyniumCodeCellSeparator CursorLine
hi! link JupyniumMarkdownCellSeparator CursorLine
hi! link JupyniumMarkdownCellContent CursorLine
hi! link JupyniumMagicCommand Keyword
]]

return options
