return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				-- Use stylua for lua files
				lua = { "stylua" },

				-- You can also add standard PHP formatting here if you want
				-- php = { "php_cs_fixer" },
			},
			-- Set up format-on-save
			-- format_on_save = {
			-- 	lsp_fallback = true, -- If stylua isn't found, try the LSP
			-- 	async = false,
			-- 	timeout_ms = 500,
			-- },
		})

		-- Optional: Keymap to format manually
		vim.keymap.set({ "n", "v" }, "<leader>gf", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
