local custom_fname = require("lualine.components.filename"):extend()
local highlight = require "lualine.highlight"
local default_status_colors = { saved = "#115457", modified = "#DD677B" }

function custom_fname:init(options)
  custom_fname.super.init(self, options)
  self.status_colors = {
    saved = highlight.create_component_highlight_group(
      { bg = default_status_colors.saved },
      "filename_status_saved",
      self.options
    ),
    modified = highlight.create_component_highlight_group(
      { bg = default_status_colors.modified },
      "filename_status_modified",
      self.options
    ),
  }
  if self.options.color == nil then
    self.options.color = ""
  end
end

function custom_fname:update_status()
  local data = custom_fname.super.update_status(self)
  data = highlight.component_format_highlight(
    vim.bo.modified and self.status_colors.modified or self.status_colors.saved
  ) .. data
  return data
end

local secs = {
  a = { "mode" },
  b = {
    "branch",
    { "diff", symbols = { added = "", modified = "", removed = "" } },
    {
      "diagnostics",
      sources = { "nvim_lsp", "nvim_diagnostic" },
      symbols = { error = "", warn = "", info = "", hint = "󰰂" },
    },
  },
  c = {
    {
      custom_fname,
      symbols = {
        modified = "", -- Text to show when the file is modified.
        readonly = "󱧉", -- Text to show when the file is non-modifiable or readonly.
        unnamed = "󰢤", -- Text to show for unnamed buffers.
        newfile = "", -- Text to show for newly created file before first write
      },
    },
  },
  x = { "encoding", "fileformat", "filetype" },
  y = { "progress", "location" },
  z = { "searchcount", "selectioncount" },
}

local options = {
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "󰇙", right = "󰇙" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
  },
  sections = {
    lualine_a = secs.a,
    lualine_b = secs.b,
    lualine_c = secs.c,
    lualine_x = secs.x,
    lualine_y = secs.y,
    lualine_z = secs.z,
  },
  inactive_sections = {
    lualine_a = secs.a,
    lualine_b = secs.b,
    lualine_c = secs.c,
    lualine_x = secs.x,
    lualine_y = secs.y,
    lualine_z = secs.z,
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {
    "aerial",
    "fugitive",
    "fzf",
    "lazy",
    "man",
    "mason",
    "nvim-dap-ui",
    "nvim-tree",
    "quickfix",
    "toggleterm",
    "trouble",
  },
}

return options
