return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files'})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live GREP' })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Search Buffers' })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help Tags' })
            -- Outline View
            vim.keymap.set('n', '<leader>fo', builtin.treesitter, { desc = 'Tree Sitter' })
            vim.keymap.set('n', '<leader>fm', builtin.marks, { desc = 'Marks' })
            vim.keymap.set('n', '<leader>fr', builtin.registers, { desc = 'Registers' })
            vim.keymap.set('n', '<leader>fp', function() vim.cmd [[Telescope neoclip]] end, { desc = 'Neo Clip History' })
            vim.keymap.set('n', '<leader>de', "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = 'Code Errors' })
        end
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            -- This is your opts table
            require("telescope").setup {
                extensions = {
                    {
                        ["ui-select"] = {
                            require("telescope.themes").get_dropdown {
                                -- even more opts
                            }
                        }
                    }
                }
            }
            -- To get ui-select loaded and working with telescope, you need to call
            -- load_extension, somewhere after setup function:
            require("telescope").load_extension("ui-select")
        end
    }
}
