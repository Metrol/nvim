return {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
        require('ufo').setup({
            provider_selector = function(bufnr, filetype, buftype)
                return {'treesitter', 'indent'}
            end,
            vim.keymap.set('n', 'zR', require('ufo').openAllFolds),
            vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
        })
    end,
}

