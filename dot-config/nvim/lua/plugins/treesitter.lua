local M = {
	"nvim-treesitter/nvim-treesitter",
	version = false,
	build = function()
		require("nvim-treesitter.install").update({ with_sync = true })()
	end,
	event = { "VeryLazy" },
	lazy = vim.fn.argc(-1) == 0, -- load early when opening a file from the command line
	init = function(plugin)
		require("lazy.core.loader").add_to_rtp(plugin)
		require("nvim-treesitter.query_predicates")
	end,
	cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
	keys = {
		{ "<c-space>", desc = "Increment Selection" },
		{ "<bs>", desc = "Decrement Selection", mode = "x" },
	},
	config = function()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			ensure_installed = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"rust",
				"python",
			},
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}

return { M }
