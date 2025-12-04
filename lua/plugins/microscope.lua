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
