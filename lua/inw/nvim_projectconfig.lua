-- No example configuration was found for this plugin.
--
-- For detailed information on configuring this plugin, please refer to its
-- official documentation:
--
--   https://github.com/windwp/nvim-projectconfig
--
-- If you wish to use this plugin, you can optionally modify and then uncomment
-- the configuration below.

return {
    "windwp/nvim-projectconfig",
    opts = {
        projects = {
            '/srv/me/mev2/*',
        },
        picker = {
            type = 'telescope',
        }
    },
    init = function()
        vim.opt.sessionoptions:append("globals")
    end,
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        -- optional picker
        { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
        -- { "nvim-telescope/telescope.nvim" },
        -- optional picker
        -- { "ibhagwan/fzf-lua" },
        -- { "Shatur/neovim-session-manager" },
    },
    lazy = true,
    priority = 100,
}
