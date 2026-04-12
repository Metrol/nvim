--
-- Nvim Lint
--
-- An asynchronous linter plugin for Neovim (>= 0.9.5) complementary to the
-- built-in Language Server Protocol support.
--
-- https://github.com/mfussenegger/nvim-lint
--
-- Installed this one so PHPStan would actively review code as I'm writing.
-- If I used phpcs, this would be where it would go.
--
return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            php = { "phpstan" },
        }

        -- To allow running multiple linters (e.g., phpcs + phpstan), use a list:
        -- php = { "phpstan", "phpcs" },

        -- Automatically trigger linting on events
        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })
    end,
}
