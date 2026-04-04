return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        branch = 'main',

        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                auto_install = true,
                ensure_installed = {"php", "phpdoc", "twig", "javascript", "jsdoc", "html"},
                sync_install = false,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = true
                },

                indent = {
                    enable = true,
                    disable = {"javascript"},
                },
            })
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects"
    }
}
