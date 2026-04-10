return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        branch = "main",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local buf = args.buf
                    local ft = vim.bo[buf].filetype
                    local lang = vim.treesitter.language.get_lang(ft)
                    if lang then
                        pcall(vim.treesitter.start, buf)
                    end
                end,
            })

            -- Disable treesitter indenting for the following
            local no_ts_indent = {
                "javascript",
                "twig"
            }

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local buf = args.buf
                    local ft = vim.bo[buf].filetype

                    if vim.tbl_contains(no_ts_indent, ft) then
                        vim.bo[buf].indentexpr = ""
                    else
                        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
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
     {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("nvim-treesitter-textobjects").setup({
                move = {
                    enable = true,
                    set_jumps = true,
                },
            })

            -- Alt-Up / Alt-Down for jumping between methods/functions
            vim.keymap.set("n", "<A-Up>", function()
                require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
            end, { desc = "Previous function/method" })

            vim.keymap.set("n", "<A-Down>", function()
                require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
            end, { desc = "Next function/method" })
        end,
    },
}
