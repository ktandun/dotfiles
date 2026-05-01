local vim = vim
local o = vim.opt
local g = vim.g
local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("user.cfg", {clear = true})

g.mapleader = ' ' -- Make sure to set `mapleader` before lazy so your mappings are correct
g.editorconfig = false

o.termguicolors = true
o.autoread = true
o.swapfile = false
o.cursorline = true
o.mouse = ''
o.relativenumber = true
o.signcolumn = 'yes:1'
o.so = 5
o.timeoutlen = 300

-- plugins

vim.pack.add({
    'https://github.com/sbdchd/neoformat',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    {src = "https://github.com/catppuccin/nvim", name = "catppuccin"}
})

-- color scheme

require("catppuccin").setup({
    flavour = "auto" -- latte, frappe, macchiato, mocha
})

vim.cmd.colorscheme "catppuccin-nvim"

-- mappings

map('n', '<leader>e', ':e ~/.config/nvim/init.lua<CR>')
map('n', '<F12>', ':Neoformat<CR>')

-- mason

require("mason").setup()
require("mason-lspconfig").setup({ensure_installed = {"ty", "lua_ls"}})
vim.lsp.enable({'ty', 'lua-language-server'})

-- lsp

autocmd("LspAttach", {
    group = augroup,
    callback = function(ev)
        local bufopts = {buffer = ev.buf, silent = true}
        map("n", "gd", vim.lsp.buf.definition, bufopts)
        map("n", "gD", vim.lsp.buf.declaration, bufopts)
        map("n", "gI", vim.lsp.buf.implementation, bufopts)
        map("n", "gy", vim.lsp.buf.type_definition, bufopts)
        map("i", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        map("n", "<leader>ca", vim.lsp.buf.code_action,
            {buffer = ev.buf, desc = "Code action"})
        map("n", "<leader>cr", vim.lsp.buf.rename,
            {buffer = ev.buf, desc = "Rename"})

        map('n', '<F7>',
            function() vim.diagnostic.jump({count = -1, float = true}) end)
        map('n', '<F8>',
            function() vim.diagnostic.jump({count = 1, float = true}) end)

        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, ev.buf,
                                      {autotrigger = true})
        end
    end
})

-- run neoformat on save

autocmd("BufWritePre", {
    group = augroup,
    pattern = "*",
    callback = function() vim.cmd("Neoformat") end
})
