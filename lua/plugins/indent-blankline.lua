return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
    config = function()
        require('ibl').setup({
            enabled = false
        })
    end,
    keys = {
        {
            mode = { 'n' },
            "si",
            "<cmd>IBLToggle<cr>",
            desc = "Toggle Indent Guides"
        }
    }
}
