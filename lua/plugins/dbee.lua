-- DBee downloads the backend matching its pinned release; no local build is needed.
-- SQL completion uses nvim-cmp; Blink handles other filetypes.
return {
    {
        "Metrol/nvim-dbee",
        tag = "v0.2.0-metrol.1",
        main = "dbee",
        dependencies = { "MunifTanjim/nui.nvim" },
        cmd = "Dbee",
        keys = {
            { "<leader>Do", function() require("custom.dbee_buffers").open() end, desc = "Open SQL in database client" },
            { "<leader>Dt", "<cmd>Dbee toggle<CR>", desc = "Toggle database client" },
            { "<leader>Dc", "<cmd>Dbee close<CR>", desc = "Close database client" },
            { "<leader>Dd", function() require("custom.dbee_layout").toggle_sidebar() end, desc = "Toggle database sidebar" },
        },
        build = function()
            require("dbee").install()
        end,
        opts = function()
            return {
                window_layout = require("custom.dbee_layout").new(),
                drawer = {
                    window_options = { winfixheight = false },
                    mappings = vim.list_extend(vim.deepcopy(require("dbee.config").default.drawer.mappings), {
                        { key = "h", mode = "n", action = "collapse" },
                        { key = "l", mode = "n", action = "expand" },
                    }),
                },
            }
        end,
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
