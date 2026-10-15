-- DBee uses the local development checkout and its compiled Go backend.
-- SQL completion uses nvim-cmp; Blink handles other filetypes.
return {
    {
        "Metrol/nvim-dbee",
        dir = vim.fn.expand("~/Projects/nvim-dbee"),
        main = "dbee",
        dependencies = { "MunifTanjim/nui.nvim" },
        cmd = "Dbee",
        keys = {
            { "<leader>Do", "<cmd>Dbee open<CR>", desc = "Open database client" },
            { "<leader>Dt", "<cmd>Dbee toggle<CR>", desc = "Toggle database client" },
            { "<leader>Dc", "<cmd>Dbee close<CR>", desc = "Close database client" },
        },
        -- Rebuild this checkout rather than downloading an upstream binary.
        build = function(plugin)
            local install_dir = vim.fn.stdpath("data") .. "/dbee/bin"
            vim.fn.mkdir(install_dir, "p")
            local result = vim.system({
                "go", "build", "-C", plugin.dir .. "/dbee",
                "-o", install_dir .. "/dbee", ".",
            }, {
                env = { GOTOOLCHAIN = "go1.23.4", CGO_ENABLED = "0" },
                text = true,
            }):wait()
            if result.code ~= 0 then
                error(result.stderr or "DBee backend build failed")
            end
        end,
        opts = {},
        config = function(_, opts)
            vim.fn.mkdir(vim.fn.stdpath("cache") .. "/dbee", "p")
            require("dbee").setup(opts)
            require("custom.dbee_buffers").setup()
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        ft = "sql",
        dependencies = {
            "Metrol/nvim-dbee",
            "nvim-treesitter/nvim-treesitter",
            "hrsh7th/cmp-buffer",
            "MattiasMTS/cmp-dbee",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                enabled = function()
                    return vim.bo.filetype == "sql"
                        and vim.bo.buftype ~= "prompt"
                        and vim.api.nvim_get_mode().mode ~= "c"
                end,
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end,
                },
                sources = {},
            })

            cmp.setup.filetype("sql", {
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { "i" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { "i" }),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                }),
                sources = cmp.config.sources({
                    { name = "cmp-dbee" },
                }, {
                    { name = "buffer" },
                }),
            })

            cmp.register_source("cmp-dbee", require("custom.dbee_completion").new())
        end,
    },
}
