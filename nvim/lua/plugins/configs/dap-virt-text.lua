local opts = {
  enabled = true,
  enabled_commands = true,
  highlight_changed_variables = true,
  highlight_new_as_changed = false,
  show_stop_reason = true,
  commented = false,
  only_first_definition = true,
  all_references = false, -- show virtual text on all all references of the variable (not only definitions)
  clear_on_continue = false,
  display_callback = function(variable, buf, stackframe, node, options)
    if options.virt_text_pos == "inline" then
      return " = " .. variable.value
    else
      return variable.name .. " = " .. variable.value
    end
  end,
  virt_text_pos = vim.fn.has "nvim-0.10" == 1 and "inline" or "eol",
}

return opts
