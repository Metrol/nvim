-- No example configuration was found for this plugin.
--
-- For detailed information on configuring this plugin, please refer to its
-- official documentation:
--
--   https://github.com/mrjones2014/smart-splits.nvim
--
-- If you wish to use this plugin, you can optionally modify and then uncomment
-- the configuration below.

return {
    "mrjones2014/smart-splits.nvim",

    config = function()

        vim.keymap.set('n', '<leader>w|', function() vim.cmd [[vsplit]] end, { desc = 'Vertical Split' })
        vim.keymap.set('n', '<leader>w-', function() vim.cmd [[split]] end, { desc = 'Horizontal Split' })
        -- recommended mappings
        -- resizing splits
        -- these keymaps will also accept a range,
        -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
        vim.keymap.set('n', '<C-h>', require('smart-splits').resize_left, { desc = "Resize Left" } )
        vim.keymap.set('n', '<C-j>', require('smart-splits').resize_down, { desc = "Resize Down" } )
        vim.keymap.set('n', '<C-k>', require('smart-splits').resize_up, { desc = "Resize Up" } )
        vim.keymap.set('n', '<C-l>', require('smart-splits').resize_right, { desc = "Resize Right" } )
        -- moving between splits
        vim.keymap.set('n', '<A-h>', require('smart-splits').move_cursor_left, { desc = "Move Left Window" } )
        vim.keymap.set('n', '<A-j>', require('smart-splits').move_cursor_down, { desc = "Move Down Window" } )
        vim.keymap.set('n', '<A-k>', require('smart-splits').move_cursor_up, { desc = "Move Up Window" } )
        vim.keymap.set('n', '<A-l>', require('smart-splits').move_cursor_right, { desc = "Move Right Window" } )
        vim.keymap.set('n', '<A-\\>', require('smart-splits').move_cursor_previous, { desc = "Move Previous Window" } )
        -- swapping buffers between windows
        vim.keymap.set('n', '<leader>wh', require('smart-splits').swap_buf_left, { desc = "Swap Left Window" } )
        vim.keymap.set('n', '<leader>wj', require('smart-splits').swap_buf_down, { desc = "Swap Down Window" } )
        vim.keymap.set('n', '<leader>wk', require('smart-splits').swap_buf_up, { desc = "Swap Up Window" } )
        vim.keymap.set('n', '<leader>wl', require('smart-splits').swap_buf_right, { desc = "Swap Right Window" } )
    end,
}
