--
-- Project
--
-- A Neovim plugin written in Lua that, under configurable conditions,
-- automatically sets the user's cwd to the current project root and also
-- allows users to manage, access and selectively include their projects in
-- a history.
--
-- https://github.com/DrKJeff16/project.nvim
--
return {
    {
        'DrKJeff16/project.nvim',
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
                telescope = {
                    disable_file_picker = true,
                },
            })
            require('telescope').load_extension('projects')
        end
    }
}

