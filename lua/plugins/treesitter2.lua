return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        build = ":TSUpdate",
        branch = "main",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            ensure_installed = {
                "lua", "vim", "vimdoc",
                "php", "phpdoc", "twig", "html",
                "javascript", "typescript", "jsdoc"
            },

            -- Setting this to true will run `:TSUpdate` on every startup
            auto_install = true,

            highlight = {
                enable = true,
                additional_vim_regex_highlighting = true
            },

            indent = {
                enable = true,
                disable = {"javascript"},
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.config").setup(opts)
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-ts-autotag").setup({
                opts = {
                    enable_close = true,
                    enable_rename = true,
                    enable_close_on_slash = false,
                },
            })
        end,
    },
}
