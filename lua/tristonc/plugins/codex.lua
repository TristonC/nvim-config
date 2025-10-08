return {
	"rhart92/codex.nvim",
	config = function()
		local codex = require("codex")
		codex.setup({
			-- Use a floating split with consistent sizing and style.
			split = "float",
			size = 0.3,
			float = {
				width = 0.8,
				height = 0.8,
				border = "rounded",
				row = nil,
				col = nil,
				title = "Codex",
			},
			codex_cmd = { "codex" },
			focus_after_send = false,
			log_level = "warn",
			autostart = false,
		})
		vim.keymap.set("n", "<leader>cc", codex.toggle, { desc = "Codex: Toggle" })
		vim.keymap.set("v", "<leader>cs", codex.actions.send_selection, { desc = "Codex: Send selection" })
	end,
}
