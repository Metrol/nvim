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
