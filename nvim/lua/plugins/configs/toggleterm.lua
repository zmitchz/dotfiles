local options = {
  size = 10,
  shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
  shading_factor = -30, -- the percentage by which to lighten terminal background, default: -30 (gets multiplied by -3 if background is light)
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  terminal_mappings = true,
  persist_size = false,
  persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
  direction = "horizontal",
}

return options
