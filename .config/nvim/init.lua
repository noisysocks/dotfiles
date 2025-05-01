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
		"Shatur/neovim-ayu",
		priority = 1000,
		config = function()
			local function get_macos_appearance()
				local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
				if handle then
					local result = handle:read("*a")
					handle:close()
					return result:match("Dark") and "dark" or "light"
				end
				return "light"
			end

			require("ayu").setup({
				mirage = get_macos_appearance() == "light",
			})
			require("ayu").colorscheme()
		end,
	},

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
		"nmac427/guess-indent.nvim",
		config = function()
			require("guess-indent").setup()
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
}, {
	install = {
		colorscheme = { "ayu" },
	},
})

-- Prefer spaces with a width of 4 spaces
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Exclude useless files from * expansion in command mode
vim.opt.wildignore:append({ "./git/*", "node_modules/*" })

-- Use ripgrep when searching with :grep
vim.opt.grepprg = "rg --vimgrep"
