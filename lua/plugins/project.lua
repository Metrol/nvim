return {
    {
        'DrKJeff16/project.nvim',
        -- "ahmedkhalf/project.nvim", -- Original plugin
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
        },
        config = function(_, opts)
            require("project").setup({
                sync_root_with_cwd = true,
                respect_buf_cwd = true,
                update_focused_file = {
                    enable = true,
                    update_root = true
                },
            })
            require('telescope').load_extension('projects')
        end
    }
}
