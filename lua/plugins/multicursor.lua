--
-- Multi Cursors
--
-- The Multicursor Plugin for Neovim extends the native Neovim text editing
-- capabilities, providing a more intuitive way to edit repetitive text with
-- multiple selections. With this plugin, you can easily create and manage
-- multiple selections, perform simultaneous edits, and execute commands on
-- all selections at once.
--
-- https://github.com/smoka7/multicursors.nvim
--
return {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
        'nvimtools/hydra.nvim',
    },
    opts = {},
    cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
    keys = {
        {
            mode = { 'v', 'n' },
            '<Leader>m',
            '<cmd>MCstart<cr>',
            desc = 'Create a selection for selected text or word under the cursor',
        },
    },
}

