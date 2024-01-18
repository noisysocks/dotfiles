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
		"navarasu/onedark.nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("onedark")
		end,
	},

	"github/copilot.vim",
	"tpope/vim-fugitive",
	"tpope/vim-repeat",
	"tpope/vim-rhubarb",
	"tpope/vim-sleuth",
	"tpope/vim-surround",

	{ "j-hui/fidget.nvim", event = "VeryLazy", opts = {} },
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", event = { "BufReadPre", "BufNewFile" }, opts = {} },
	{ "numToStr/Comment.nvim", event = { "BufReadPre", "BufNewFile" }, opts = {} },
	{ "tpope/vim-unimpaired", event = "VeryLazy" },

	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			options = {
				icons_enabled = false,
				theme = "onedark",
				component_separators = "|",
				section_separators = "",
			},
			sections = {
				lualine_c = {
					{
						"filename",
						path = 1,
					},
				},
			},
		},
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").register({
				["<leader>r"] = { name = "Refactor", _ = "which_key_ignore" },
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"yioneko/nvim-yati",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				highlight = { enable = true },
				-- indent = { enable = true },
				yati = { enable = true },
				textobjects = {
					select = {
						enable = true,
						keymaps = {
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
				},
			})
		end,
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = "Neotree",
		keys = {
			{ "<Leader>n", "<Cmd>Neotree toggle<CR>", desc = "Toggle Neotree" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			close_if_last_window = true,
			filesystem = {
				follow_current_file = { enabled = true },
			},
			default_component_configs = {
				icon = {
					folder_closed = "▶",
					folder_open = "▼",
					folder_empty = "▷",
					folder_empty_open = "▽",
					default = "",
				},
			},
		},
	},

	-- {
	-- 	"nvim-telescope/telescope.nvim",
	-- 	branch = "0.1.x",
	-- 	cmd = "Telescope",
	-- 	keys = {
	-- 		{
	-- 			"<Leader><Leader>",
	-- 			function()
	-- 				require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({
	-- 					previewer = false,
	-- 				}))
	-- 			end,
	-- 			desc = "Search buffers",
	-- 		},
	-- 		{ "<Leader>g", "<Cmd>Telescope live_grep<CR>", desc = "Live grep" },
	-- 		{ "<Leader>f", "<Cmd>Telescope find_files<CR>", desc = "Search files" },
	-- 		{ "<Leader>h", "<Cmd>Telescope oldfiles<CR>", desc = "Search history" },
	-- 		{ "<Leader>l", "<Cmd>Telescope loclist<CR>", desc = "Search location list" },
	-- 		{ "<Leader>o", "<Cmd>Telescope treesitter<CR>", desc = "Search outline" },
	-- 		{ "<Leader>q", "<Cmd>Telescope quickfix<CR>", desc = "Search quickfix list" },
	-- 		{ "<Leader>t", "<Cmd>Telescope tags<CR>", desc = "Search tags" },
	-- 	},
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		{
	-- 			"nvim-telescope/telescope-fzf-native.nvim",
	-- 			build = "make",
	-- 			cond = function()
	-- 				return vim.fn.executable("make") == 1
	-- 			end,
	-- 			config = function()
	-- 				require("telescope").load_extension("fzf")
	-- 			end,
	-- 		},
	-- 	},
	-- },

	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		keys = {
			{ "<Leader><Leader>", "<Cmd>FzfLua buffers<CR>", desc = "Search buffers" },
			{ "<Leader>g", "<Cmd>FzfLua grep_project<CR>", desc = "Live grep" },
			{ "<Leader>f", "<Cmd>FzfLua files<CR>", desc = "Search files" },
			{ "<Leader>h", "<Cmd>FzfLua oldfiles<CR>", desc = "Search history" },
			{ "<Leader>l", "<Cmd>FzfLua loclist<CR>", desc = "Search location list" },
			{ "<Leader>o", "<Cmd>FzfLua lsp_document_symbols<CR>", desc = "Search outline" },
			{ "<Leader>q", "<Cmd>FzfLua quickfix<CR>", desc = "Search quickfix list" },
			{ "<Leader>t", "<Cmd>FzfLua tags<CR>", desc = "Search tags" },
		},
		opts = {},
	},

	{
		"ludovicchabant/vim-gutentags",
		init = function()
			vim.g.gutentags_file_list_command = "rg --files"
			vim.g.gutentags_cache_dir = vim.fn.stdpath("cache")
			vim.g.gutentags_generate_on_empty_buffer = true
			vim.g.gutentags_ctags_extra_args = {
				"--map-TypeScript=+.tsx",
			}
			vim.g.gutentags_ctags_exclude = {
				"*.json",
				"*.md",
			}
			vim.api.nvim_create_autocmd("User", {
				pattern = "GutentagsUpdating",
				callback = function()
					require("fidget").notify("Updating project tags…", nil, {
						annote = "Gutentags",
						key = "gutentags",
					})
				end,
			})
			vim.api.nvim_create_autocmd("User", {
				pattern = "GutentagsUpdated",
				callback = function()
					require("fidget").notify("Updated project tags", vim.log.levels.OFF, {
						annote = "Gutentags",
						key = "gutentags",
					})
				end,
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			{ "folke/neodev.nvim", opts = {} },
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			require("cmp_nvim_lsp").default_capabilities(capabilities)
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,
			})

			require("mason-tool-installer").setup({
				ensure_installed = {
					"eslint_d",
					"stylua",
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					-- LSP sets tagfunc to vim.lsp.tagfunc by default (see :help lsp). Unset it so that I can jump to tags using <C-]>
					vim.bo[args.buf].tagfunc = nil

					local function map(mode, lhs, rhs, opts)
						vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { buffer = args.buf }, opts))
					end

					map("n", "<M-]>", vim.lsp.buf.definition, { desc = "Go to definition" })
					map("n", "K", vim.lsp.buf.hover, { desc = "Display hover information" })
					map("n", "<Leader>rf", vim.lsp.buf.references, { desc = "Find references" })
					map("n", "<Leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
					map({ "n", "v" }, "<Leader>ra", vim.lsp.buf.code_action, { desc = "Code action" })
				end,
			})
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-buffer",
			-- 'hrsh7th/cmp-path',
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				sources = {
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "buffer" },
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
				}),
			})
		end,
	},

	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				-- TODO: PHP
			}
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},

	{
		"mhartington/formatter.nvim",
		cmd = "Format",
		event = "BufWritePre",
		config = function()
			require("formatter").setup({
				filetype = {
					javascript = { require("formatter.filetypes.javascript").eslint_d },
					typescript = { require("formatter.filetypes.typescript").eslint_d },
					javascriptreact = { require("formatter.filetypes.javascriptreact").eslint_d },
					typescriptreact = { require("formatter.filetypes.typescriptreact").eslint_d },
					lua = { require("formatter.filetypes.lua").stylua },
				},
			})
			vim.api.nvim_create_autocmd("BufWritePost", {
				command = ":FormatWrite",
			})
		end,
	},
}, {
	install = {
		colorscheme = { "onedark" },
	},
})

-- Disable intro when starting neovim
vim.opt.shortmess:append({ I = true })

-- Our statusline plugin already shows the current mode, so there's no need to show it again
vim.opt.showmode = false

-- Decrease delay before showing keybindings
vim.opt.timeoutlen = 300

-- Default indentation settings
vim.opt.expandtab = false
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Automatically indent new lines.
vim.opt.smartindent = true

-- Text width settings
-- vim.opt.wrap = false
vim.opt.textwidth = 80

-- Ignore case when searching, unless the search query has capitals in it
vim.opt.smartcase = true
vim.opt.ignorecase = true

-- Exclude some common useless files from wildcard matches
vim.opt.wildignore:append({ "./git*", "node_modules/*" })

-- Use rg instead of grep
vim.opt.grepprg = "rg --vimgrep"

-- Put neovim diagnostics into the loclist for easy navigation
vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function()
		vim.diagnostic.setloclist({ open = false })
	end,
})

-- Keybindings
vim.keymap.set("n", "<M-g>", "<Cmd>grep '\\<<cword>\\>'<CR>", { silent = true, desc = "Grep word under cursor" })
