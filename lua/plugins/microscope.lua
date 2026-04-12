--
-- Microscope
--
-- Quickly look into or edit declarations of functions, variables, and more
-- through a floating window
--
-- https://github.com/Cpoing/microscope.nvim
--
return {
    "Cpoing/microscope.nvim",
    cmd = "MicroscopePeek",
    keys = {
        { "<leader>gp", ":MicroscopePeek<CR>", desc = "Peek definition" },
    },
    config = function()
        require("microscope")
    end,
}
