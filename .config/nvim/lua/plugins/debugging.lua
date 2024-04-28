local get_cwd = function()
	local package_json_path = vim.fn.findfile("package.json", ".;", -1)[1]
	if package_json_path ~= "" then
		local project_dir = vim.fn.fnamemodify(package_json_path, ":h")

		return project_dir
	else
		print("Error: package.json not found in the current or parent directories.")
	end

	return ""
end

return {
	{
		"microsoft/vscode-js-debug",
		opt = true,
		run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"mxsdev/nvim-dap-vscode-js",
      "nvim-neotest/nvim-nio"
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()

			require("dap-vscode-js").setup({
				adapters = { "pwa-node", "pwa-chrome", "node-terminal" },
				debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
			})

			for _, lang in ipairs({ "javascript", "typescript" }) do
				dap.configurations[lang] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "Debug Mocha Tests",
						-- trace = true, -- include debugger info
						runtimeExecutable = "node",
						runtimeArgs = {
							"--inspect-brk",
							"./node_modules/mocha/bin/mocha",
							"${file}",
						},
						cwd = get_cwd,
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
					},
				}
			end

			-- UI config
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			-- dap.listeners.before.event_terminated.dapui_config = function()
			-- 	dapui.close()
			-- end
			-- dap.listeners.before.event_exited.dapui_config = function()
			-- 	dapui.close()
			-- end

			-- Keymaps
			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, {})
			vim.keymap.set("n", "<leader>dc", dap.continue, {})
			vim.keymap.set("n", "<leader>dsi", dap.step_into, {})
			vim.keymap.set("n", "<leader>dso", dap.step_out, {})
			vim.keymap.set("n", "<leader>dsc", dap.step_over, {})
      vim.keymap.set("n", "<leader>dq", dapui.close, {})
		end,
	},
}
