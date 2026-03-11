vim.g.mapleader = ' ' -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.editorconfig = false
vim.opt.termguicolors = true

vim.opt.autoread = true
vim.opt.swapfile = false
vim.opt.cursorline = true
vim.opt.mouse = ''
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes:1'
vim.opt.so = 5
vim.opt.timeoutlen = 300

vim.pack.add({'https://github.com/sbdchd/neoformat'})

vim.keymap.set('n', '<F12>', ':Neoformat<CR>')
