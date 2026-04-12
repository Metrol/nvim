--
-- Folding UFO
--
-- The goal of nvim-ufo is to make Neovim's fold look modern and keep high
-- performance.
--
-- https://github.com/kevinhwang91/nvim-ufo
--
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

