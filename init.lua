require("options")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

require("lazy").setup({
	{
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({
				window = {
					border = "rounded",
					padding = { 2, 2, 2, 2 },
				},
				triggers = { "<leader>" },
			})
			require("keymaps")
		end,
	},

	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},

	{
		"mfussenegger/nvim-dap",
		event = "BufRead",
	},

	{
		"rcarriga/nvim-dap-ui",
		event = "BufRead",
		config = function()
			require("dapui").setup({
				layouts = {
					{
						position = "left",
						size = 40,
						elements = {
							-- {
							--   id = "breakpoints",
							--   size = 0.10,
							-- },
							-- {
							--   id = "stacks",
							--   size = 0.25,
							-- },
							-- {
							--   id = "watches",
							--   size = 0.25,
							-- },
							-- {
							--   id = "scopes",
							--   size = 0.40,
							-- },
						},
					},
					{
						position = "bottom",
						size = 15,
						elements = {
							-- {
							--  id = "console",
							--  size = 0.5,
							-- },
							{
								id = "repl",
								size = 0.5,
							},
						},
					},
				},
			})
		end,
	},

	{
		"jay-babu/mason-nvim-dap.nvim",
		event = "BufRead",
		config = function()
			require("mason-nvim-dap").setup({})
			require("dap").adapters.go = {
				type = "server",
				port = "63370",
				executable = {
					command = "dlv",
					args = { "dap", "-l", "127.0.0.1:63370" },
				},
			}
			local dap, dapui = require("dap"), require("dapui")
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
				vim.cmd("NvimTreeClose")
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
				vim.cmd("NvimTreeOpen")
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
				vim.cmd("NvimTreeShow")
			end

			vim.cmd("DapLoadLaunchJSON")
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			local nl = require("null-ls")
			nl.setup({
				sources = {
					nl.builtins.formatting.goimports,
				},
			})
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		config = function()
			require("mason-null-ls").setup({})
		end,
	},

	{
		"nmac427/guess-indent.nvim",
		config = function()
			require("guess-indent").setup({})
		end,
	},

	-- {
	--   "Darazaki/indent-o-matic",
	--   config = function()
	--     require("indent-o-matic").setup({
	--       standard_widths = { 2, 4 }
	--     })
	--   end,
	-- },

	{
		"akinsho/bufferline.nvim",
		config = function()
			require("bufferline").setup({
				options = {
					offsets = {
						{ filetype = "NvimTree" },
					},
				},
			})
		end,
	},
	{ "MunifTanjim/nui.nvim" },
	{ "nvim-lua/plenary.nvim" },
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require('lualine').setup()
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			vim.opt.termguicolors = true
			vim.cmd([[highlight IndentBlanklineIndent1 guibg=#1c1c29 gui=nocombine]])
			vim.cmd([[highlight IndentBlanklineIndent2 guibg=#20202e gui=nocombine]])
			require("indent_blankline").setup({
				char = "",
				char_highlight_list = {
					"IndentBlanklineIndent1",
					"IndentBlanklineIndent2",
				},
				space_char_highlight_list = {
					"IndentBlanklineIndent1",
					"IndentBlanklineIndent2",
				},
				show_trailing_blankline_indent = false,
				show_current_context = true,
			})
		end,
	},
	{
		"echasnovski/mini.nvim",
		version = "*",
		config = function()
			require("mini.indentscope").setup()
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		event = "BufRead",
		config = function()
			require("nvim-treesitter.configs").setup({})
			vim.cmd(":TSUpdate")
			vim.cmd(":TSEnable highlight")
		end,
	},
	{
		'nvim-treesitter/nvim-treesitter-context',
		config = function()
			require('treesitter-context').setup({
				patterns = {
					default = {
						'class',
						'function',
						'method',
						'for', -- These won't appear in the context
						'while',
						'if',
						'switch',
						'case',
						'element',
						'call'
					},
				},
			})
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		event = "BufRead",
		config = function()
			require("nvim-ts-autotag").setup({
				filetypes = { "html", "xml" },
			})
		end,
	},

	{
		"nvim-tree/nvim-web-devicons",
		event = "BufRead",
		config = function()
			require("nvim-web-devicons").setup()
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
				view = {
					side = "right",
				},
			})
		end,
	},
	
	{ 'otavioschwanck/telescope-alternate.nvim' },
	{ 'nvim-telescope/telescope-ui-select.nvim' },
	{ 'nvim-telescope/telescope-file-browser.nvim' },
	{
		"nvim-telescope/telescope.nvim",
		event = "BufRead",
		config = function()
			require("telescope").setup({})
		end,
	},

	{
		'folke/trouble.nvim',
		config = function()
			require('trouble').setup()
		end,
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			local on_attach = function(client, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

				-- Mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				-- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
				-- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
				-- vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
				-- vim.keymap.set('n', '<leader>wl', function()
				--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				-- end, bufopts)

				local wk = require("which-key")
				wk.register({
					["<leader>l"] = { name = "+LSP" },
					["<leader>lD"] = { ":lua vim.lsp.buf.declaration()<CR>", "Goto Declaration" },
					["<leader>ld"] = { ":lua vim.lsp.buf.definition()<CR>", "Goto Definition" },
					["<leader>lt"] = { ":lua vim.lsp.buf.type_definition()<CR>", "Goto Type Definition" },
					["<leader>lr"] = { ":lua vim.lsp.buf.rename()<CR>", "Rename All" },
					["<leader>la"] = { ":lua vim.lsp.buf.code_action()<CR>", "Code Action" },
					["<leader>lf"] = { ":lua vim.lsp.buf.format({ async = true })<CR>", "Format" },
				})
			end

			local lsp = require("lspconfig")
			lsp.gopls.setup({
				on_attach = on_attach,
			})
			lsp.rust_analyzer.setup({
				on_attach = on_attach,
				cmd = {
					"rustup",
					"run",
					"stable",
					"rust-analyzer",
				},
			})
		end,
	},

	{ "hrsh7th/nvim-cmp" },
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
	},
	{ "hrsh7th/cmp-nvim-lsp" },
	{ 'hrsh7th/cmp-buffer' },
	{ 'hrsh7th/cmp-path' },
	{
		'tzachar/cmp-tabnine',
		build = './install.sh',
		dependencies = 'hrsh7th/nvim-cmp',
	},
	{
		"VonHeikemen/lsp-zero.nvim",
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "L3MON4D3/LuaSnip" },
		  { "saadparwaiz1/cmp_luasnip" },
			{ "williamboman/mason.nvim" },
			{ 'hrsh7th/cmp-buffer' },
			{ 'tzachar/cmp-tabnine' },
			{ 'hrsh7th/cmp-path' },
			{ 'nvim-orgmode/orgmode' },
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load({})
			local cmp = require("cmp")
			local ls = require("luasnip")

			cmp.setup({
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "cmp_tabnine" },
					{ name = "path" },
					{ name = "orgmode" },
					{ name = "luasnip", option = { show_autosnippets = false } },
				}),

				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["<C-Space>"] = cmp.mapping.complete(),
				}),

				snippet = {
					expand = function(args)
						ls.lsp_expand(args.body)
					end,
				},
			})

			local M = {}
			function M.expand_or_jump()
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				end
			end

			function M.jump_prev()
				if ls.jumpable(-1) then
					ls.jump(-1)
				end
			end

			vim.keymap.set("i", "<c-i>", M.expand_or_jump)
		end,
	},

	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	{ "rafamadriz/friendly-snippets" },
	{
		"saadparwaiz1/cmp_luasnip",
		dependencies = {
			{ "L3MON4D3/LuaSnip" },
		},
	},

	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},

	{
		"folke/tokyonight.nvim",
		config = function()
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},

	{ "dstein64/vim-startuptime" },

	{
		"NvChad/nvterm",
		config = function()
			require("nvterm").setup({
				terminals = {
					shell = "/usr/local/bin/fish",
					type_opts = {
						float = {
							width = 0.8,
							height = 0.6,
							row = 0.2,
							col = 0.1,
						},
					},
				},
			})
		end,
	},

	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("illuminate").configure()
		end,
	},

	{
		'nvim-orgmode/orgmode',
		config = function()
			local om = require('orgmode')
			om.setup_ts_grammar()
			om.setup()
		end,
	},
})

vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format({ async = true }) ]])
vim.cmd([[autocmd CursorMovedI * lua vim.lsp.buf.hover() ]])
vim.cmd([[autocmd InsertEnter * lua vim.lsp.buf.hover() ]])
