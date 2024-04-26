local M = {}

M.init = function()
  vim.notify = require "notify"
end

M.opts = {
  background_colour = "#000000",
}

return M
