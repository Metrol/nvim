return {
    "ahmedkhalf/project.nvim",
    opts = {
        manual_mode = true,
    },
    config = function(_, opts)
        require("project_nvim").setup({
            sync_root_with_cwd = true,
            respect_buf_cwd = true,
            update_focused_file = {
                enable = true,
                update_root = true
            },
        })
    end,
}
