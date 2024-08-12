local home = vim.fn.expand('$HOME')

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        'git', 'clone', '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git', '--branch=stable', -- latest stable release
        lazypath
    })
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = ' ' -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.editorconfig = false
vim.g.vsnip_snippet_dir = vim.fn.expand('~/.config/nvim/snippets/')
vim.opt.termguicolors = true

require('lazy').setup({
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)"
            }, {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)"
            }, {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)"
            }, {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)"
            }, {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)"
            }, {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)"
            }
        }
    }, {'Mofiqul/dracula.nvim'}, {
        "f-person/auto-dark-mode.nvim",
        opts = {
            update_interval = 2000,
            set_dark_mode = function()
                vim.api.nvim_set_option_value("background", "dark", {})
                vim.cmd("colorscheme dracula")
            end,
            set_light_mode = function()
                vim.api.nvim_set_option_value("background", "light", {})
                vim.cmd("colorscheme vim")
            end
        }
    }, {
        'goolord/alpha-nvim',
        event = "VimEnter",
        enabled = true,
        init = false,
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")
            dashboard.section.header.val = {
                [[                                                                       ]],
                [[  ██████   █████                   █████   █████  ███                  ]],
                [[ ░░██████ ░░███                   ░░███   ░░███  ░░░                   ]],
                [[  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ]],
                [[  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ]],
                [[  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ]],
                [[  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ]],
                [[  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ]],
                [[ ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]],
                [[                                                                       ]]
            }

            dashboard.section.buttons.val = {
                dashboard.button("SPC f", " " .. " Find file",
                                 "<cmd> Telescope find_files <cr>")
            }

            alpha.setup(dashboard.opts)
            vim.cmd([[ autocmd FileType alpha setlocal nofoldenable ]])
        end
    }, {
        'echasnovski/mini.nvim',
        version = '*',
        config = function()
            require('mini.indentscope').setup()
            require('mini.jump').setup()
            require('mini.trailspace').setup()

            local miniMap = require('mini.map')
            miniMap.setup()
            vim.keymap.set('n', '<Leader>mt', miniMap.toggle)

            require('mini.surround').setup({
                -- Add custom surroundings to be used on top of builtin ones. For more
                -- information with examples, see `:h MiniSurround.config`.
                custom_surroundings = nil,

                -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
                highlight_duration = 1000,

                -- Module mappings. Use `''` (empty string) to disable one.
                mappings = {
                    add = 'sa', -- Add surrounding in Normal and Visual modes
                    delete = 'sd', -- Delete surrounding
                    find = 'sf', -- Find surrounding (to the right)
                    find_left = 'sF', -- Find surrounding (to the left)
                    replace = 'sr' -- Replace surrounding
                }
            })
            require('mini.pairs').setup({
                -- In which modes mappings from this `config` should be created
                modes = {insert = true, command = false, terminal = false},

                -- Global mappings. Each right hand side should be a pair information, a
                -- table with at least these fields (see more in |MiniPairs.map|):
                -- - <action> - one of 'open', 'close', 'closeopen'.
                -- - <pair> - two character string for pair to be used.
                -- By default pair is not inserted after `\`, quotes are not recognized by
                -- `<CR>`, `'` does not insert pair after a letter.
                -- Only parts of tables can be tweaked (others will use these defaults).
                mappings = {
                    ['('] = {
                        action = 'open',
                        pair = '()',
                        neigh_pattern = '[^\\].'
                    },
                    ['['] = {
                        action = 'open',
                        pair = '[]',
                        neigh_pattern = '[^\\].'
                    },
                    ['{'] = {
                        action = 'open',
                        pair = '{}',
                        neigh_pattern = '[^\\].'
                    },

                    [')'] = {
                        action = 'close',
                        pair = '()',
                        neigh_pattern = '[^\\].'
                    },
                    [']'] = {
                        action = 'close',
                        pair = '[]',
                        neigh_pattern = '[^\\].'
                    },
                    ['}'] = {
                        action = 'close',
                        pair = '{}',
                        neigh_pattern = '[^\\].'
                    },

                    ['"'] = {
                        action = 'closeopen',
                        pair = '""',
                        neigh_pattern = '[^\\].',
                        register = {cr = false}
                    },
                    ['\''] = {
                        action = 'closeopen',
                        pair = '\'\'',
                        neigh_pattern = '[^%a\\].',
                        register = {cr = false}
                    },
                    ['`'] = {
                        action = 'closeopen',
                        pair = '``',
                        neigh_pattern = '[^\\].',
                        register = {cr = false}
                    }
                }
            })
        end
    }, {'vimpostor/vim-lumen'}, {
        'NeogitOrg/neogit',
        dependencies = {
            'nvim-lua/plenary.nvim', -- required
            'sindrets/diffview.nvim', -- optional - Diff integration
            'nvim-telescope/telescope.nvim' -- optional
        },
        config = true
    }, {
        'vhyrro/luarocks.nvim',
        priority = 1000,
        config = true,
        opts = {rocks = {'lua-curl', 'nvim-nio', 'mimetypes', 'xml2lua'}}
    }, {
        'stevearc/oil.nvim',
        keys = {{'<leader>o', '<cmd>Oil<cr>', desc = 'Oil'}},
        opts = {skip_confirm_for_simple_edits = true},
        -- Optional dependencies
        dependencies = {'nvim-tree/nvim-web-devicons'}
    }, {'neovim/nvim-lspconfig'}, {
        'sbdchd/neoformat',
        config = function()
            vim.cmd [[
				let g:neoformat_try_node_exe = 1 " try to find exe on node_modules
			]]
        end
    }, {
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
    }, {
        'williamboman/mason-lspconfig.nvim',
        config = function()
            local mason = require 'mason-lspconfig'
            mason.setup({
                ensure_installed = {
                    'bashls', 'lua_ls', 'biome', 'tailwindcss', 'basedpyright',
                    'tsserver', 'volar'
                }
            })
        end
    }, {'hrsh7th/cmp-nvim-lsp'}, {'hrsh7th/cmp-buffer'}, {'hrsh7th/cmp-path'},
    {'hrsh7th/cmp-cmdline'}, {'hrsh7th/cmp-vsnip'}, {'hrsh7th/vim-vsnip'}, {
        'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require('cmp')

            cmp.setup {
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered()
                },
                snippet = {
                    expand = function(args)
                        vim.fn['vsnip#anonymous'](args.body) -- For `vsnip` users.
                    end
                },
                sources = cmp.config.sources({
                    {name = 'nvim_lsp'}, {name = 'vsnip'} -- For vsnip users.
                }, {{name = 'buffer'}}),
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(), -- trigger auto complete
                    ['<CR>'] = cmp.mapping.confirm({select = true}),
                    ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(),
                                            {'i', 'c'}),
                    ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(),
                                            {'i', 'c'})
                })
            }
        end
    }, {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'}, {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        -- or                              , branch = '0.1.x',
        dependencies = {'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep'},
        config = function()
            -- telescope
            local telescope = require('telescope')
            telescope.setup({
                defaults = {
                    layout_strategy = 'vertical',
                    layout_config = {
                        vertical = {width = 0.8}
                        -- other layout configuration here
                    }
                    -- other defaults configuration here
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = 'smart_case'
                    }
                }
                -- other configuration values here
            })

            telescope.load_extension('fzf')

            local builtin = require('telescope.builtin')

            vim.keymap.set('n', '<leader>f',
                           function()
                builtin.find_files({hidden = true})
            end, {})
            vim.keymap.set('n', '<leader>b', builtin.buffers, {})
            vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols, {})
            vim.keymap.set('n', 'gR', builtin.lsp_references, {})

            local default_livegrep_args = {'--hidden'}

            vim.keymap.set('n', '<leader>1', function()
                builtin.resume()
            end, {noremap = true, silent = true})

            vim.keymap.set('n', '<leader>3', function()
                builtin.live_grep({additional_args = default_livegrep_args})
            end, {})

            vim.keymap.set({'n', 'v'}, '<leader>4', function()
                local word = vim.fn.expand('<cword>')
                builtin.live_grep({
                    additional_args = default_livegrep_args,
                    default_text = word
                })
            end, {})
        end
    }, {
        'nvim-lualine/lualine.nvim',
        dependencies = {'nvim-tree/nvim-web-devicons'},
        config = function()
            local lualine = require 'lualine'
            lualine.setup({
                sections = {lualine_a = {}, lualine_c = {'filename'}}
            })
        end
    }, {
        'chrisgrieser/nvim-scissors',
        dependencies = 'nvim-telescope/telescope.nvim', -- optional
        opts = {snippetDir = '~/.config/nvim/snippets'}
    }, {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            local configs = require('nvim-treesitter.configs')

            configs.setup({
                ensure_installed = 'all',
                sync_install = false,
                auto_install = false,
                highlight = {enable = true},
                indent = {enable = true}
            })
        end
    }, {
        'windwp/nvim-ts-autotag',
        dependencies = 'nvim-treesitter/nvim-treesitter',
        config = function()
            require('nvim-ts-autotag').setup({
                opts = {
                    -- Defaults
                    enable_close = true, -- Auto close tags
                    enable_rename = true, -- Auto rename pairs of tags
                    enable_close_on_slash = false -- Auto close on trailing </
                },
                -- Also override individual filetype configs, these take priority.
                -- Empty by default, useful if one of the "opts" global settings
                -- doesn't work well in a specific filetype
                per_filetype = {["html"] = {enable_close = false}}
            })
        end
    }, {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = 'nvim-treesitter/nvim-treesitter',
        config = function()
            require'nvim-treesitter.configs'.setup {
                textobjects = {
                    select = {
                        enable = true,

                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,

                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@class.outer',
                            -- You can optionally set descriptions to the mappings (used in the desc parameter of
                            -- nvim_buf_set_keymap) which plugins like which-key display
                            ['ic'] = {
                                query = '@class.inner',
                                desc = 'Select inner part of a class region'
                            }
                        },
                        -- You can choose the select mode (default is charwise 'v')
                        --
                        -- Can also be a function which gets passed a table with the keys
                        -- * query_string: eg '@function.inner'
                        -- * method: eg 'v' or 'o'
                        -- and should return the mode ('v', 'V', or '<c-v>') or a table
                        -- mapping query_strings to modes.
                        selection_modes = {
                            ['@parameter.outer'] = 'v', -- charwise
                            ['@function.outer'] = 'V', -- linewise
                            ['@class.outer'] = '<c-v>' -- blockwise
                        },
                        -- If you set this to `true` (default is `false`) then any textobject is
                        -- extended to include preceding or succeeding whitespace. Succeeding
                        -- whitespace has priority in order to act similarly to eg the built-in
                        -- `ap`.
                        --
                        -- Can also be a function which gets passed a table with the keys
                        -- * query_string: eg '@function.inner'
                        -- * selection_mode: eg 'v'
                        -- and should return true or false
                        include_surrounding_whitespace = true
                    }
                }
            }

        end

    }
}, {
    performance = {rtp = {disabled_plugins = {'matchparen'}}},
    checker = {enabled = false, notify = true},
    change_detection = {
        -- automatically check for config file changes and reload the ui
        enabled = true,
        notify = true -- get a notification when changes are found
    }
})

vim.opt.cursorline = true
vim.opt.mouse = ''
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes:1'
vim.opt.so = 5
vim.opt.timeoutlen = 300

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

vim.api.nvim_create_autocmd("FileType", {
    pattern = "gleam",
    callback = function()
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.expandtab = true
    end
})

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
vim.keymap.set('n', '<leader>se',
               function() require('scissors').editSnippet() end)
-- When used in visual mode prefills the selection as body.
vim.keymap.set({'n', 'x'}, '<leader>sa',
               function() require('scissors').addNewSnippet() end)

-- LSP Servers

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp
                                                                      .protocol
                                                                      .make_client_capabilities())

require'lspconfig'.bashls.setup {capabilities = capabilities}

require'lspconfig'.biome.setup {capabilities = capabilities}

require'lspconfig'.lua_ls.setup {
    capabilities = capabilities,
    settings = {Lua = {diagnostics = {globals = {'vim'}}}}
}

require'lspconfig'.gleam.setup {capabilities = capabilities}

require'lspconfig'.tailwindcss.setup {capabilities = capabilities}

require'lspconfig'.tsserver.setup {
    capabilities = capabilities,
    init_options = {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = home ..
                    "/.local/share/nvim/mason/packages/vue-typescript-plugin/node_modules/@vue/typescript-plugin",
                -- languages = {"javascript", "typescript", "vue"}
                languages = {"vue"}
            }
        }
    },
    filetypes = {
        'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue'
    }
}

require'lspconfig'.basedpyright.setup {
    capabilities = capabilities,
    settings = {basedpyright = {analysis = {typeCheckingMode = 'basic'}}}
}

require'lspconfig'.volar.setup {
    capabilities = capabilities,
    filetypes = {"vue"}
}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)
vim.keymap.set('n', '<F7>', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<F8>', vim.diagnostic.goto_next)
vim.keymap.set('n', '<F12>', ':Neoformat<CR>')
vim.keymap.set('v', 'gr', ':.w !bash<CR>') -- run highlighted command in bash

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
        local opts = {buffer = ev.buf}

        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.rename, opts)
        vim.keymap.set({'n', 'v'}, '<leader>.', vim.lsp.buf.code_action, opts)
    end
})

vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, {
        border = "double" -- You can use "single", "double", "rounded", "solid", "shadow"
    })
