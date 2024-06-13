vim.g.terminal_emulator = "konsole-Arun"

local opt = vim.opt

opt.relativenumber = true
opt.number = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.swapfile = false
opt.grepprg = "rg --vimgrep"
opt.syntax = "on"
opt.autoindent = true
opt.cursorline = true
opt.encoding = "utf-8"
opt.hidden = true
opt.showcmd = true
opt.showmatch = true

vim.g.mapleader = " "
