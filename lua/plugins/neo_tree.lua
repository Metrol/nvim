return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim"
    },
    config = function()
--        vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>')
        vim.keymap.set('n', '<leader>e', ':Neotree focus<CR>', { desc = 'File Explorer'})
        vim.keymap.set('n', '<leader>wb', ':Neotree buffers float<CR>', { desc = 'Open Buffers'})
--        vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>')
        require("neo-tree").setup({
            window = {
                mappings = {
                    ["l"] = "open",
                    ["h"] = "close_node"
                }
            },
--         Automatically close tree view after file selected
           -- event_handlers = {
           --    {
           --         event = "file_opened",
           --         handler = function()
           --             require("neo-tree.command").execute({ action = "close" })
           --         end
           --     }
           -- },
           {
               close_if_last_window = true
           }
        })
    end
}

