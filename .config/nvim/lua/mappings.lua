local normal = {
	{ "<leader>n", "<cmd> set number!<CR>", { desc = "Toggle number lines" } },
	{ "<leader>rn", "<cmd> set relativenumber!<CR>", { desc = "Toggle relative lines" } },
}

return {
	n = normal,
}
