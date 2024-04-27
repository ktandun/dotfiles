local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "        -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.vsnip_snippet_dir = vim.fn.expand("~/.config/nvim/snippets/")
vim.opt.termguicolors = true -- Make sure to set this before bufferline

require("lazy").setup({
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		keys = {
			{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		}
	},
	{
		'stevearc/oil.nvim',
		keys = {
			{ "<leader>o", "<cmd>Oil<cr>", desc = "Oil" },
		},
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		'akinsho/bufferline.nvim',
		version = "*",
		dependencies = 'nvim-tree/nvim-web-devicons',
		config = function()
			require("bufferline").setup()
		end,
	},
	{ "neovim/nvim-lspconfig" },
	{
		"williamboman/mason.nvim",
		config = function()
			local mason = require 'mason'
			mason.setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗"
					}
				}
			})
		end
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			local mason = require 'mason-lspconfig'
			mason.setup({
				ensure_installed = {
					"cssls",
					"bashls",
					"lua_ls",
					"volar",
					"basedpyright",
					"csharp_ls",
					"tsserver",
				}
			})
		end
	},
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-cmdline" },
	{ 'hrsh7th/cmp-vsnip' },
	{ 'hrsh7th/vim-vsnip' },
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require 'cmp'
			cmp.setup {
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
					end,
				},
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'vsnip' }, -- For vsnip users.
				}, {
					{ name = 'buffer' },
				}),
				mapping = cmp.mapping.preset.insert({
					['<CR>'] = cmp.mapping.confirm({ select = true }),
					['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
					['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
				}),
			}
		end,
	},
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.6',
		-- or                              , branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
			vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
			vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
			vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols, {})
		end
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			local lualine = require 'lualine'
			lualine.setup({
				sections = {
					lualine_c = {
						-- invoke `progress` here.
						function()
							return require('lsp-progress').progress()
						end,
					},
				}
			})
		end
	},
	{
		'linrongbin16/lsp-progress.nvim',
		config = function()
			require('lsp-progress').setup()
		end
	},
	{
		"chrisgrieser/nvim-scissors",
		dependencies = "nvim-telescope/telescope.nvim", -- optional
		opts = {
			snippetDir = "~/.config/nvim/snippets",
		}
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = "all",
				sync_install = false,
				auto_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require('catppuccin').setup({
				dim_inactive = {
					enabled = false, -- dims the background color of inactive window
					shade = "dark",
					percentage = 0.15, -- percentage of the shade to apply to the inactive window
				},
				styles = {    -- Handles the styles of general hi groups (see `:h highlight-args`):
					comments = { "italic" }, -- Change the style of comments
					conditionals = { "italic" },
					loops = {},
					functions = { "bold" },
					keywords = {},
					strings = { "bold" },
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
					-- miscs = {}, -- Uncomment to turn off hard-coded styles
				},
				integrations = {
					cmp = true,
				},
			})
		end
	},
})

vim.cmd.colorscheme "catppuccin"
vim.wo.relativenumber = true
vim.wo.cursorline = true
vim.wo.so = 5
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.mouse = ""
vim.opt.timeoutlen = 200

vim.keymap.set("i", "{", "{}<Esc>ha")
vim.keymap.set("n", "<Esc>", ":nohl<CR>:echo<CR>")
vim.keymap.set("n", "<leader>c", ":e ~/.config/nvim/init.lua<CR>")
vim.keymap.set("n", "<leader>z", ":e ~/.zshrc<CR>")
vim.keymap.set("n", "gn", ":bnext<CR>")
vim.keymap.set("n", "gp", ":bprevious<CR>")
vim.cmd [[
  imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
  smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
]]


-- nvim snippets with nvim-scissors
vim.keymap.set("n", "<leader>se", function() require("scissors").editSnippet() end)
-- When used in visual mode prefills the selection as body.
vim.keymap.set({ "n", "x" }, "<leader>sa", function() require("scissors").addNewSnippet() end)

-- LSP Servers
local lspconfig = require('lspconfig')
require 'lspconfig'.cssls.setup {}
require 'lspconfig'.bashls.setup {}
require 'lspconfig'.lua_ls.setup {
	settings = {
		Lua = {
			diagnostics = {
				globals = { 'vim' }
			}
		}
	}
}
require 'lspconfig'.tsserver.setup {}
require 'lspconfig'.basedpyright.setup {}
require 'lspconfig'.csharp_ls.setup {
	-- specify root_dir, so lsp can find all solutions related to your workspace
	root_dir = function(startpath)
		return lspconfig.util.root_pattern("*.sln")(startpath)
			or lspconfig.util.root_pattern("*.csproj")(startpath)
			or lspconfig.util.root_pattern(".git")(startpath)
	end,
}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
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
		vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<leader>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gR', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<leader>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})
