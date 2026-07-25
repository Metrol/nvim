--
-- Goto Preview
--
-- A small Neovim plugin for previewing native LSP's goto definition,
-- type definition, implementation, declaration and references calls in
-- floating windows.
--
-- https://github.com/rmagatti/goto-preview
--
return {
    "rmagatti/goto-preview",
    dependencies = { "rmagatti/logger.nvim" },
    event = "BufEnter",
    -- config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
    config = function()
        require('goto-preview').setup(
        {
            width = 120,
            height = 50
        })
    end,
    keys = {
        {
            "gp",
            "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
            noremap = true,
            desc = "goto preview definition",
        },
        -- {
        --     "<leader>gpD",
        --     "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>",
        --     noremap = true,
        --     desc = "goto preview declaration",
        -- },
        -- {
        --     "<leader>gpi",
        --     "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
        --     noremap = true,
        --     desc = "goto preview implementation",
        -- },
        -- {
        --     "<leader>gpy",
        --     "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
        --     noremap = true,
        --     desc = "goto preview type definition",
        -- },
        {
            "gr",
            "<cmd>lua require('goto-preview').goto_preview_references()<CR>",
            noremap = true,
            desc = "goto preview references",
        },
        {
            "gP",
            "<cmd>lua require('goto-preview').close_all_win()<CR>",
            noremap = true,
            desc = "close all preview windows",
        },
    },
}

