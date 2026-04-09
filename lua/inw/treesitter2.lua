return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = "*",
        build = ":TSUpdate",
        lazy  = false,
        opts = {
            ensure_installed = {
                "lua", "vim", "vimdoc",
                "php", "phpdoc", "twig", "html", "css",
                "javascript", "typescript", "jsdoc"
            },
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false
            },
            indent = {
                enable = true,
                disable = {"javascript"},
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
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
