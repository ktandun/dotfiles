vim.cmd [[ colorscheme quiet ]]

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath
    })
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = ' ' -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.vsnip_snippet_dir = vim.fn.expand('~/.config/nvim/snippets/')
vim.opt.termguicolors = true

require('lazy').setup({
	{
		'tpope/vim-fugitive'
	},
    {
        'vhyrro/luarocks.nvim',
        priority = 1000,
        config = true,
        opts = { rocks = { 'lua-curl', 'nvim-nio', 'mimetypes', 'xml2lua' } }
    },
    {
        'rest-nvim/rest.nvim',
        ft = 'http',
        dependencies = { 'luarocks.nvim' },
        config = function()
            require('rest-nvim').setup({
                env_file = '.env',
                result = {
                    split = { in_place = true },
                    behavior = {
                        decode_url = true,
                        show_info = {
                            url = true,
                            headers = true,
                            http_info = true,
                            curl_command = true
                        }
                    }
                }
            })

            -- rest.nvim
            vim.cmd [[
			  nnoremap <leader>rr :Rest run<CR>
			  nnoremap <leader>rl :Rest run last<CR>
			]]
        end
    },
    {
        'stevearc/oil.nvim',
        keys = { { '<leader>o', '<cmd>Oil<cr>', desc = 'Oil' } },
        opts = {},
        -- Optional dependencies
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    { 'neovim/nvim-lspconfig' },
    {
        'mhartington/formatter.nvim',
        config = function()
            local util = require 'formatter.util'
            require('formatter').setup {
                logging = true,
                log_level = vim.log.levels.WARN,
                filetype = {
                    typescriptreact = {
                        function()
                            return {
                                exe = 'biome',
                                args = {
                                    'format',
                                    '--stdin-file-path=' ..
                                        util.escape_path(
                                            util.get_current_buffer_file_path())
                                },
                                stdin = true
                            }
                        end
                    },
                    lua = {
                        function()
                            return {
                                exe = 'lua-format',
                                args = {
                                    '--spaces-inside-table-braces',
                                    '--double-quote-to-single-quote',
                                    '--break-after-operator',
                                    '--no-keep-simple-control-block-one-line',
                                    '--no-keep-simple-function-one-line',
                                    '--chop-down-table',
                                    '--chop-down-kv-table',
                                    '--chop-down-parameter',
                                    util.escape_path(
                                        util.get_current_buffer_file_path())
                                },
                                stdin = true
                            }
                        end
                    },
                    cs = {
                        function()
                            return {
                                exe = 'dotnet-csharpier',
                                args = {
                                    '--write-stdout',
                                    util.escape_path(
                                        util.get_current_buffer_file_path())
                                },
                                stdin = true
                            }
                        end
                    },
                    python = {
                        function()
                            return {
                                exe = 'black',
                                args = {
                                    '-q',
                                    '-'
                                },
                                stdin = true
                            }
                        end
                    },
                    ['*'] = {
                        require('formatter.filetypes.any').remove_trailing_whitespace
                    }
                }
            }
        end
    },
    {
        'williamboman/mason.nvim',
        config = function()
            local mason = require 'mason'
            mason.setup({
                ui = {
                    icons = {
                        package_installed = '✓',
                        package_pending = '➜',
                        package_uninstalled = '✗'
                    }
                }
            })
        end
    },
    {
        'williamboman/mason-lspconfig.nvim',
        config = function()
            local mason = require 'mason-lspconfig'
            mason.setup({
                ensure_installed = {
                    'bashls',
                    'lua_ls',
                    'basedpyright',
                    'csharp_ls',
                    'tsserver'
                }
            })
        end
    },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/cmp-vsnip' },
    { 'hrsh7th/vim-vsnip' },
    {
        'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require('cmp')
            cmp.setup {
                snippet = {
                    expand = function(args)
                        vim.fn['vsnip#anonymous'](args.body) -- For `vsnip` users.
                    end
                },
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'vsnip' } -- For vsnip users.
                }, { { name = 'buffer' } }),
                mapping = cmp.mapping.preset.insert({
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(),
                                            { 'i', 'c' }),
                    ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(),
                                            { 'i', 'c' })
                })
            }
        end
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        -- or                              , branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep' },
        config = function()
            local builtin = require('telescope.builtin')

            vim.keymap.set('n', '<leader>f', builtin.find_files, {})
            vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>b', builtin.buffers, {})
            vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols, {})
            vim.keymap.set('n', 'gR', builtin.lsp_references, {})
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local lualine = require 'lualine'
            lualine.setup({
                sections = { lualine_a = {}, lualine_c = { 'filename' } }
            })
        end
    },
    {
        'chrisgrieser/nvim-scissors',
        dependencies = 'nvim-telescope/telescope.nvim', -- optional
        opts = { snippetDir = '~/.config/nvim/snippets' }
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            local configs = require('nvim-treesitter.configs')

            configs.setup({
                ensure_installed = 'all',
                sync_install = false,
                auto_install = false,
                highlight = { enable = true },
                indent = { enable = true }
            })
        end
    }
}, {
    performance = { rtp = { disabled_plugins = { 'matchparen' } } },
    checker = { enabled = true, notify = true },
    change_detection = {
        -- automatically check for config file changes and reload the ui
        enabled = true,
        notify = true -- get a notification when changes are found
    }
})

vim.wo.relativenumber = true
vim.wo.cursorline = true
vim.wo.so = 5

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.mouse = ''
vim.opt.timeoutlen = 300
vim.opt.signcolumn = 'yes:1'

vim.keymap.set('i', '{', '{<CR>}<Esc>O')
vim.keymap.set('n', '<Esc>', ':nohl<CR>:echo<CR>')
vim.keymap.set('n', '<leader>c', ':e ~/.config/nvim/init.lua<CR>')
vim.keymap.set('n', '<leader>z', ':e ~/.zshrc<CR>')
vim.keymap.set('n', 'gn', ':bnext<CR>')
vim.keymap.set('n', 'gp', ':bprevious<CR>')
vim.cmd [[
  imap <expr> <C-j> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-j>'
  smap <expr> <C-j> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-j>'
  imap <expr> <C-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'
  smap <expr> <C-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'
]]

local function get_directory_path_with_dots(path)
    -- Define a pattern to match the directory path
    local pattern = '(.*)/[^/]+$'
    -- Use string.match to extract the directory path
    local directory_path = string.match(path, pattern)
    -- Replace slashes with dots
    directory_path = string.gsub(directory_path, '/', '.')
    return directory_path
end

function WriteNamespace()
    -- Get the directory name
    local directory_name = get_directory_path_with_dots(vim.fn.expand('%'))
    -- Write the directory name to the current buffer
    vim.fn.append('.', 'namespace ' .. directory_name .. ';')
end

vim.keymap.set('n', '<leader>ns', '<cmd>lua WriteNamespace()<CR>')

-- nvim snippets with nvim-scissors
vim.keymap.set('n', '<leader>se', function()
    require('scissors').editSnippet()
end)
-- When used in visual mode prefills the selection as body.
vim.keymap.set({ 'n', 'x' }, '<leader>sa', function()
    require('scissors').addNewSnippet()
end)

-- telescope
require('telescope').setup({
    defaults = {
        layout_strategy = 'vertical',
        layout_config = {
            vertical = { width = 0.8 }
            -- other layout configuration here
        }
        -- other defaults configuration here
    }
    -- other configuration values here
})

-- LSP Servers

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp
                                                                      .protocol
                                                                      .make_client_capabilities())

require'lspconfig'.cssls.setup { capabilities = capabilities }
require'lspconfig'.bashls.setup { capabilities = capabilities }
require'lspconfig'.lua_ls.setup {
    capabilities = capabilities,
    settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
}
require'lspconfig'.tsserver.setup { capabilities = capabilities }
require'lspconfig'.basedpyright.setup { capabilities = capabilities }
require'lspconfig'.csharp_ls.setup {
    -- specify root_dir, so lsp can find all solutions related to your workspace
    capabilities = capabilities,
    root_dir = function(startpath)
        return lspconfig.util.root_pattern('*.sln')(startpath) or
                   lspconfig.util.root_pattern('*.csproj')(startpath) or
                   lspconfig.util.root_pattern('.git')(startpath)
    end
}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)
vim.keymap.set('n', '<F7>', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<F8>', vim.diagnostic.goto_next)
vim.keymap.set('n', '<F12>', ':FormatWrite<CR>')

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        --
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }

        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap
            .set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder,
                       opts)
        vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>.', vim.lsp.buf.code_action, opts)
    end
})
