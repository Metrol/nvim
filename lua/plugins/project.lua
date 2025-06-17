return {
  {
    "ahmedkhalf/project.nvim",
    config = function()
        require("project_nvim").setup {
            manual_mode = false,
        }

        require('telescope').load_extension('projects')
    end
  },
}
