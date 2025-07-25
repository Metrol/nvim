return {
    'lmantw/themify.nvim',
    lazy = false,
    priority = 999,

    config = function()
        require('themify').setup({
            'xiantang/darcula-dark.nvim',
            'catppuccin/nvim',
            'folke/tokyonight.nvim',
            'rebelot/kanagawa.nvim',
            'marko-cerovac/material.nvim',
            'neanias/everforest-nvim',
            'luisiacc/gruvbox-baby',
        })
    end
}
