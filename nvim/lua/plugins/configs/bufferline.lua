local bufferline = require('bufferline')

local options = { options = {
    mode = "buffers", 
    style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
    themable = true,
    numbers = "none",
    close_command = "bdelete! %d",
    indicator = {
        style = 'none',
    },
    buffer_close_icon = '󰅖',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    max_name_length = 18,
    max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
    truncate_names = true, -- whether or not tab names should be truncated
    tab_size = 18,
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match("error") and " " or " "
        return " " .. icon .. count
    end,
    offsets = {
        {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "left",
            separator = true
        }
    },
    color_icons = true, -- whether or not to add the filetype icon highlights
    get_element_icon = function(element)
        -- element consists of {filetype: string, path: string, extension: string, directory: string}
        -- This can be used to change how bufferline fetches the icon
        local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype, { default = false })
        return icon, hl
    end,
    show_buffer_icons = true,
    show_buffer_close_icons = false,
    show_close_icon = false,
    show_tab_indicators = true,
    show_duplicate_prefix = true,
    persist_buffer_sort = true,
    move_wraps_at_ends = false,
    separator_style = { "󰇙", "" },
    enforce_regular_tabs = true,
    always_show_bufferline = true,
    hover = {
        enabled = true,
        delay = 200,
        reveal = {'close'}
    },
    sort_by = 'id'
}}

return options
