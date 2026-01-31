return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

        local clang_config_path = vim.fn.stdpath("config") .. "/.clang-format"

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "clang-format", lsp_format = "never" },
				typescript = { "clang-format", lsp_format = "never" },
				javascriptreact = { "clang-format", lsp_format = "never" },
				typescriptreact = { "clang-format", lsp_format = "never" },
				php = { "php_cs_fixer", lsp_format = "never" },
			},
			formatters = {
				["clang-format"] = {
					prepend_args = { "-style=file:" .. clang_config_path },
				},
			},
		})
		vim.keymap.set({ "n", "v" }, "<leader>gf", function()
			conform.format({
				lsp_fallback = false,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
