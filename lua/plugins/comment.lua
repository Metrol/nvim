return {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup({
            padding = true,
        })
    end,

    lazy = false,
}
