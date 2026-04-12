--
-- AutoPairs
--
-- Automatically creates pairs of patterns.
--
-- https://github.com/windwp/nvim-autopairs
--
return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
        require("nvim-autopairs").setup({})
    end
}

