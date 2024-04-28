return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	config = function()
		vim.keymap.set("n", "<C-n>", ":Neotree reveal toggle left<CR>", {})

		require("neo-tree").setup({
			filesystem = {
				follow_current_file = {
					enabled = true,
					leave_dirs_open = true,
				},
				use_libuv_file_watcher = true,
			},
		})
	end,
}
