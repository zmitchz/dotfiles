local M = {}

M.init = function()
  require("luasnip.loaders.from_vscode").lazy_load()
  require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }
  require("luasnip.loaders.from_snipmate").load()
  require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }
  require("luasnip.loaders.from_lua").load()
  require("luasnip.loaders.from_lua").lazy_load { paths = vim.g.lua_snippets_path or "" }
  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      if
        require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require("luasnip").session.jump_active
      then
        require("luasnip").unlink_current()
      end
    end,
  })
end

M.opts = {
  history = true,
  update_events = "TextChanged,TextChangedI",
}

M.snipexts = function()
  require("luasnip").filetype_extend("typescript", { "javascript" })
  require("luasnip").filetype_extend("typescript", { "html" })
  -- standardized comments snippets
  require("luasnip").filetype_extend("typescript", { "tsdoc" })
  require("luasnip").filetype_extend("javascript", { "jsdoc" })
  require("luasnip").filetype_extend("lua", { "luadoc" })
  require("luasnip").filetype_extend("python", { "pydoc" })
  require("luasnip").filetype_extend("rust", { "rustdoc" })
  require("luasnip").filetype_extend("cs", { "csharpdoc" })
  require("luasnip").filetype_extend("java", { "javadoc" })
  require("luasnip").filetype_extend("c", { "cdoc" })
  require("luasnip").filetype_extend("cpp", { "cppdoc" })
  require("luasnip").filetype_extend("php", { "phpdoc" })
  require("luasnip").filetype_extend("kotlin", { "kdoc" })
  require("luasnip").filetype_extend("ruby", { "rdoc" })
  require("luasnip").filetype_extend("sh", { "shelldoc" })
end

return M
