local opt = vim.opt
local g = vim.g

-------------------------------------- globals -----------------------------------------
g.python3_host_prog = "/usr/bin/python3"

-------------------------------------- options ------------------------------------------
opt.laststatus = 3 -- global statusline
opt.showmode = false
opt.pumblend = 20
opt.winblend = 20
opt.clipboard = "unnamedplus"

-- Indenting
opt.expandtab = true
opt.shiftwidth = 4
opt.smartindent = true
opt.tabstop = 4
opt.softtabstop = 4

opt.fillchars = { eob = " " }
opt.smartcase = true
opt.mouse = "a"

-- Numbers
opt.relativenumber = true
opt.number = true
opt.cursorline = true
opt.colorcolumn = "80"
opt.numberwidth = 2
opt.ruler = false

-- disable nvim intro
opt.shortmess:append "sI"

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true

opt.updatetime = 250

opt.wrap = false

opt.scrolloff = 4
g.mapleader = "\\"

for _, provider in ipairs { "perl", "ruby" } do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- add binaries installed by mason.nvim to path
vim.env.PATH = vim.fn.stdpath "data" .. "/mason/bin:" .. vim.env.PATH

-------------------------------------- autocmds ------------------------------------------
local autocmd = vim.api.nvim_create_autocmd

-- dont list quickfix buffers
autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

autocmd('TextYankPost', {
  group = misc_aucmds,
  callback = function()
    vim.highlight.on_yank()
  end,
})

