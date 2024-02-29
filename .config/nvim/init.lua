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

-- Explicitly set <Leader> so that mini.basics doesn't change it to <Space>
vim.g.mapleader = [[\]]

require("lazy").setup({
	{
		"navarasu/onedark.nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("onedark")
		end,
	},

	"github/copilot.vim",
	"teoljungberg/vim-grep-motion",

	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup()
			require("mini.basics").setup({
				mappings = {
					option_toggle_prefix = "|",
				},
			})
			require("mini.bracketed").setup({
				oldfile = { suffix = "h" },
			})
			require("mini.comment").setup()
			require("mini.completion").setup()
			require("mini.files").setup()
			require("mini.pairs").setup()
			require("mini.statusline").setup()
			require("mini.surround").setup()
			require("mini.tabline").setup()

			vim.keymap.set("n", "<Leader>e", function()
				local files = require("mini.files")
				if not files.close() then
					files.open(vim.api.nvim_buf_get_name(0))
				end
			end)
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			require("ibl").setup({
				scope = { enabled = false },
			})
		end,
	},

	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		keys = {
			{ "<Leader>b", "<Cmd>FzfLua buffers<CR>" },
			{ "<Leader>f", "<Cmd>FzfLua files<CR>" },
			{ "<Leader>g", "<Cmd>FzfLua grep_project<CR>" },
			{ "<Leader>h", "<Cmd>FzfLua oldfiles<CR>" },
			{ "<Leader>s", "<Cmd>FzfLua lsp_document_symbols<CR>" },
			{ "<Leader>t", "<Cmd>FzfLua tags<CR>" },
		},
		config = function()
			require("fzf-lua").setup()
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				highlight = { enable = true },
			})
		end,
	},

	{
		"ludovicchabant/vim-gutentags",
		init = function()
			vim.g.gutentags_cache_dir = vim.fn.stdpath("cache")
			vim.g.gutentags_file_list_command = "rg --files"
			vim.g.gutentags_generate_on_empty_buffer = true
			vim.g.gutentags_ctags_exclude = {
				"*.json",
				"*.md",
			}
			vim.g.gutentags_ctags_extra_args = {
				"--map-TypeScript=+.tsx",
			}
		end,
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"folke/neodev.nvim",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("neodev").setup()
			require("mason").setup()
			require("mason-lspconfig").setup()

			require("mason-lspconfig").setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local opts = { buffer = args.buf }
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<Leader>ra", vim.lsp.buf.code_action, opts)
				end,
			})
		end,
	},

	{
		"mfussenegger/nvim-lint",
		ft = {
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
			"php",
		},
		config = function()
			local lint = require("lint")

			-- Custom linter that uses local phpcs if available.
			lint.linters.vendor_phpcs = function()
				local cmd
				if vim.fn.executable("vendor/bin/phpcs") then
					cmd = "vendor/bin/phpcs"
				else
					cmd = "phpcs"
				end
				return vim.tbl_extend("force", {}, lint.linters.phpcs, {
					cmd = cmd,
				})
			end

			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				php = { "vendor_phpcs" },
			}

			vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},

	{
		"mhartington/formatter.nvim",
		ft = {
			"lua",
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
			"php",
		},
		config = function()
			-- Custom formatter that uses local phpcbf if available.
			function vendor_phpcbf()
				local exe
				if vim.fn.executable("vendor/bin/phpcbf") then
					exe = "vendor/bin/phpcbf"
				else
					exe = "phpcbf"
				end
				return vim.tbl_extend("force", {}, require("formatter.filetypes.php").phpcbf(), {
					exe = exe,
				})
			end

			require("formatter").setup({
				filetype = {
					lua = { require("formatter.filetypes.lua").stylua },
					javascript = {
						require("formatter.filetypes.javascript").eslint_d,
						require("formatter.filetypes.javascript").prettierd,
					},
					typescript = {
						require("formatter.filetypes.typescript").eslint_d,
						require("formatter.filetypes.typescript").prettierd,
					},
					javascriptreact = {
						require("formatter.filetypes.javascriptreact").eslint_d,
						require("formatter.filetypes.javascriptreact").prettierd,
					},
					typescriptreact = {
						require("formatter.filetypes.typescriptreact").eslint_d,
						require("formatter.filetypes.typescriptreact").prettierd,
					},
					php = { vendor_phpcbf },
				},
			})
			vim.api.nvim_create_autocmd("BufWritePost", {
				command = "FormatWrite",
			})
		end,
	},
}, {
	install = {
		colorscheme = { "onedark" },
	},
})

-- Prefer tabs with a width of 4 spaces
vim.opt.expandtab = false
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Exclude useless files from * expansion in command mode
vim.opt.wildignore:append({ "./git/*", "node_modules/*" })

-- Use ripgrep when searching with :grep
vim.opt.grepprg = "rg --vimgrep"
