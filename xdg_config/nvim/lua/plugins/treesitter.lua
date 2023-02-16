return {
	"nvim-treesitter/nvim-treesitter",
	enabled = true,
	dependencies = {
		"p00f/nvim-ts-rainbow",
		"nvim-treesitter/nvim-treesitter-context",
		"nvim-treesitter/playground",
		"windwp/nvim-ts-autotag",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "bash", "git_rebase", "json", "lua", "ruby", "rust", "sql", "typescript", "vim" },
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "<C-M>",
					node_decremental = "<S-C-M>",
					scope_incremental = "grm",
				},
			},
			query_linter = {
				enable = true,
				use_virtual_text = true,
				lint_events = { "bufwrite", "cursorhold" },
			},
		})
	end
}

-- vim: ts=2 sts=2 sw=2 et
