vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.o.termguicolors = true
vim.o.encoding = "UTF-8"
-- Make line numbers default
vim.wo.number = true
-- Do not save when switching buffers
vim.o.hidden = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true
vim.o.breakindent = true
vim.o.clipboard = "unnamedplus"
vim.o.cursorline = true
-- Save undo histothery
vim.cmd([[set undofile]])
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.colorcolumn = "80"

require("keymap")
require("lsp-config")
require("plugins")
require("compe")

vim.cmd([[colorscheme onedark]])
