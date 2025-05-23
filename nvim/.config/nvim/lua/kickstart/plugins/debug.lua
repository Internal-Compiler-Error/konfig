-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
	-- -- NOTE: Yes, you can install new plugins here!
	-- "mfussenegger/nvim-dap",
	-- -- NOTE: And you can specify dependencies as well
	-- dependencies = {
	-- 	"nvim-neotest/nvim-nio",
	--
	-- 	-- Creates a beautiful debugger UI
	-- 	"rcarriga/nvim-dap-ui",
	--
	-- 	-- Installs the debug adapters for you
	-- 	"williamboman/mason.nvim",
	-- 	"jay-babu/mason-nvim-dap.nvim",
	--
	-- 	-- Add your own debuggers here
	-- },
	-- config = function()
	-- 	local dap = require("dap")
	-- 	local dapui = require("dapui")
	--
	-- 	require("mason-nvim-dap").setup({
	-- 		-- Makes a best effort to setup the various debuggers with
	-- 		-- reasonable debug configurations
	-- 		automatic_setup = true,
	--
	-- 		-- You can provide additional configuration to the handlers,
	-- 		-- see mason-nvim-dap README for more information
	-- 		handlers = {},
	--
	-- 		-- You'll need to check that you have the required things installed
	-- 		-- online, please don't ask me how to install them :)
	-- 		ensure_installed = {
	-- 			-- Update this to ensure that you have the debuggers for the langs you want
	-- 			-- 'delve',
	-- 		},
	-- 	})
	--
	-- 	-- Basic debugging keymaps, feel free to change to your liking!
	-- 	vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
	-- 	vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
	-- 	vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
	-- 	vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
	-- 	vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
	-- 	vim.keymap.set("n", "<leader>B", function()
	-- 		dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
	-- 	end, { desc = "Debug: Set Breakpoint" })
	--
	-- 	-- Dap UI setup
	-- 	-- For more information, see |:help nvim-dap-ui|
	-- 	dapui.setup({
	-- 		-- Set icons to characters that are more likely to work in every terminal.
	-- 		--    Feel free to remove or use ones that you like more! :)
	-- 		--    Don't feel like these are good choices.
	-- 		icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
	-- 		controls = {
	-- 			icons = {
	-- 				pause = "⏸",
	-- 				play = "▶",
	-- 				step_into = "⏎",
	-- 				step_over = "⏭",
	-- 				step_out = "⏮",
	-- 				step_back = "b",
	-- 				run_last = "▶▶",
	-- 				terminate = "⏹",
	-- 				disconnect = "⏏",
	-- 			},
	-- 		},
	-- 	})
	--
	-- 	-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
	-- 	vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })
	--
	-- 	dap.listeners.after.event_initialized["dapui_config"] = dapui.open
	-- 	dap.listeners.before.event_exited["dapui_config"] = dapui.close
	-- end,

	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"nvim-neotest/nvim-nio",
			--
			-- 	-- Creates a beautiful debugger UI
			-- 	"rcarriga/nvim-dap-ui",
			--
			-- 	-- Installs the debug adapters for you
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
		},
		opts = {},
		config = function()
			-- local dap = require("dap")

			-- Set keymaps to control the debugger
			vim.keymap.set("n", "<F5>", require("dap").continue, { desc = "Debug: Start/Continue" })
			vim.keymap.set("n", "<F7>", require("dap").step_into, { desc = "Debug: Step Into" })
			vim.keymap.set("n", "<F8>", require("dap").step_over, { desc = "Debug: Step Over" })
			vim.keymap.set("n", "<S-<F8>>", require("dap").step_out, { desc = "Debug: Step Out" })
			vim.keymap.set("n", "<leader>b", require("dap").toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>B", function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint Condition: "))
			end, {
				desc = "Debug: Breakpoint With Condition",
			})

			require("mason-nvim-dap").setup({
				automatic_installation = true,
				-- Makes a best effort to setup the various debuggers with
				-- reasonable debug configurations
				automatic_setup = true,

				-- You can provide additional configuration to the handlers,
				-- see mason-nvim-dap README for more information
				handlers = {},

				-- You'll need to check that you have the required things installed
				-- online, please don't ask me how to install them :)
				ensure_installed = {
					-- Update this to ensure that you have the debuggers for the langs you want
					-- 'delve',
				},
			})
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		event = "VimEnter",
		config = function()
			require("dapui").setup()
			local dap, dapui = require("dap"), require("dapui")

			dap.listeners.before.attach.dapui_config = dapui.open
			dap.listeners.before.launch.dapui_config = dapui.open
			dap.listeners.before.event_terminated.dapui_config = dapui.close
			dap.listeners.before.event_exited.dapui_config = dapui.close
			vim.keymap.set("n", "<leader>ui", dapui.toggle, { desc = "Debug: toggle UI" })
		end,
	},
	{
		"mxsdev/nvim-dap-vscode-js",
		event = "VimEnter", -- TODO: this probably can be run later
		config = function()
			require("dap-vscode-js").setup({
				debugger_path = "/home/liangw/.local/share/nvim/lazy/vscode-js-debug", -- Path to vscode-js-debug installation. TODO: use user env
				adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
			})

			local js_based_languages = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

			for _, language in ipairs(js_based_languages) do
				require("dap").configurations[language] = {
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
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-chrome",
						request = "launch",
						name = 'Start Chrome with "localhost"',
						url = "http://localhost:3000",
						webRoot = "${workspaceFolder}",
						userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
					},
				}
			end
		end,
		dependencies = {
			{
				"microsoft/vscode-js-debug",
				build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
			},
		},
	},
}

-- vim: ts=2 sts=2 sw=2 et
