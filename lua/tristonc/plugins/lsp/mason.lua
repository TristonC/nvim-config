return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				-- LSP servers
				"lua-language-server", -- lua_ls
				"pyright", -- Python language server
				"clangd", -- C/C++ language server
				-- Formatters and linters
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python formatter
				"ruff", -- python formatter
				"pylint", -- python linter
				"eslint_d", --js linter
			},
		})
	end,
}
