return {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files'})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live GREP' })
            vim.keymap.set('n', '<leader>wf', builtin.buffers, { desc = 'Search Buffers' })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help Tags' })
            -- Outline View
            vim.keymap.set('n', '<leader>fo', builtin.treesitter, { desc = 'Tree Sitter' })
            vim.keymap.set('n', '<leader>fm', builtin.marks, { desc = 'Marks' })
            vim.keymap.set('n', '<leader>ft', builtin.current_buffer_fuzzy_find, { desc = 'Find Text In Buffer' })
            vim.keymap.set('n', '<leader>fp', function() vim.cmd [[Telescope projects initial_mode=normal]] end, { desc = 'Project Picker' })
            vim.keymap.set('n', '<leader>fr', function() vim.cmd [[Telescope recent_files initial_mode=insert]] end, { desc = 'Recent Files' })

            vim.keymap.set('n', '<leader>ch', function() vim.cmd [[Telescope neoclip initial_mode=normal]] end, { desc = 'Clipboard History' })
            vim.keymap.set('n', '<leader>cl', function() vim.cmd [[Telescope registers initial_mode=normal]] end, { desc = 'List Registers' })

            vim.keymap.set("n", "<leader>fi", function()
                require("custom.telescope_insert_file").insert_file_from_snippets()
            end, { desc = "Insert file contents" })

            vim.keymap.set('n', '<leader>xn', function() vim.cmd [[Telescope notify initial_mode=normal]] end, { desc = 'Notifications' })
            vim.keymap.set('n', '<leader>xe', "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = 'Code Errors (Telescope)' })
        end,
        require('telescope').setup(
        {
            pickers = {
                buffers   = { initial_mode = 'normal' },
                marks     = { initial_mode = 'normal' },
                registers = { initial_mode = 'normal' },
            },
            recent_files = {
                only_cwd = true
            }
        }),
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
    },
    {
        "smartpde/telescope-recent-files"
    }
}
