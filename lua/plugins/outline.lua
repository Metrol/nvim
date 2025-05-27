return {
    "hedyhli/outline.nvim",
    opts = {},
    config = function()
        vim.keymap.set("n", "<leader>o", "<cmd>OutlineOpen<CR>", { desc = "Open Code Outline" })
        require('outline').setup({
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
                auto_preview = false,
            },
        })
    end,
}
