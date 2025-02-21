local opt = vim.opt

vim.g.mapleader = " "
-- Enable true color support
opt.termguicolors = true

-- Enable line numbers
opt.number = true
opt.relativenumber = false

-- Indentation settings
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4

-- Enable mouse support
opt.mouse = 'a'

-- Enable line wrapping
opt.wrap = true

-- Show matching brackets
opt.showmatch = true

-- Always show status line
opt.laststatus = 2

-- Improve search behavior
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- Highlight current line
opt.cursorline = true

-- Enable syntax highlighting
vim.cmd('syntax on')

-- Diagnostics
vim.diagnostic.config({
    virtual_text = true, -- Show inline errors
    signs = true,        -- Show gutter signs (🔴, ⚠️)
    underline = true,    -- Underline errors
    update_in_insert = false, -- Don't update while typing
    severity_sort = true, -- Show severe errors first
})
vim.keymap.del("n", "gcc")
