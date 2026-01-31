return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				-- Use stylua for lua files
				lua = { "stylua" },

				-- Use clang-format for JS/TS (it supports Allman natively)
				javascript = { "clang-format", lsp_format = "never" },
				typescript = { "clang-format", lsp_format = "never" },
				javascriptreact = { "clang-format", lsp_format = "never" },
				typescriptreact = { "clang-format", lsp_format = "never" },

				php = { "php_cs_fixer", lsp_format = "never" },
			},
			formatters = {
				clang_format = {
					prepend_args = {
						"-style={BasedOnStyle: WebKit, BreakBeforeBraces: Allman, IndentWidth: 4, ColumnLimit: 100}",
					},
				},
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
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
