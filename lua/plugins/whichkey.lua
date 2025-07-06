return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        spec = {
            {
                mode = { "n", "v" },
                { "<leader>d", group = "Debug" },
                { "<leader>D", group = "Database" },
                { "<leader>f", group = "Finders" },
                { "<leader>g", group = "LSP Functions" },
                { "<leader>w", group = "Windowing" },
                { "<leader>x", group = "Diagnostics" },
            }
        }
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}
