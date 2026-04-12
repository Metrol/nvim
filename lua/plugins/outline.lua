--
-- Outline
--
-- A sidebar with a tree-like outline of symbols from your code, powered by
-- LSP.
--
-- https://github.com/hedyhli/outline.nvim
--
return {
    "hedyhli/outline.nvim",
    opts = {},
    config = function()
        vim.keymap.set("n", "<leader>o", "<cmd>OutlineOpen<CR>", { desc = "Open Code Outline" })
        require('outline').setup({
            outline_window = {
                auto_close = true,
            },
            outline_items = {
                show_symbol_lineno = true,
            },
            symbol_folding = {
                autofold_depth = 1,
                auto_unfold = {
                    hovered = true,
                },
            },
            preview_window = {
                auto_preview = true,
            },
        })
    end,
}
-- I don't know if I could go on without this plugin.  Presently configured
-- to open on the right in auto preview mode.  This is my go to for vertical
-- navigation in Neovim.
-- Yeah, it really is that much nicer than just getting a list of symbols.
