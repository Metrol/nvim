return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            auto_install = true,
--            ensure_installed = { "php", "phpdoc", "lua", "vim", "vimdoc", "query", "go", "ini", "javascript", "json", "html", "twig", "css", "csv", "d", "bash", "fish", "yaml", "xml", "sql" },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true }
        })
    end
}

