return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
    config = function()
        vim.keymap.set("n", "si", "<cmd>IBLToggle<CR>", { desc = "Toggle Indent Guides" })
        require('ibl').setup({
            enabled = false
        })
    end
}
