--
-- Todo Comments
--
-- todo-comments is a lua plugin for Neovim >= 0.8.0 to highlight and
-- search for todo comments like TODO, HACK, BUG in your code base.
--
-- https://github.com/folke/todo-comments.nvim
--
return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    }
}
