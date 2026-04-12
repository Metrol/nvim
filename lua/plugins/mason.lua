--
-- Mason
--
-- Portable package manager for Neovim that runs everywhere Neovim runs.
-- Easily install and manage LSP servers, DAP servers, linters, and formatters.
--
-- https://github.com/mason-org/mason.nvim
--
return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({})
        end,
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    }
}
-- Quick note: This plugin more than any other has made it possible to use
-- Neovim as a full time coding editor.  Those were dark days trying to
-- manually configure various LSPs, debug adapters, and the like.
