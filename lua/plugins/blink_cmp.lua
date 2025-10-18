return {
    {
        'saghen/blink.compat',
        version = '2.*',
        lazy = true,
        opts = {},
    },
    {
        'saghen/blink.cmp',
        dependencies = {
            {
                'saghen/blink.cmp',
                version = '1.*',
                dependencies = {
                    { 'dmitmel/cmp-digraphs' },
                },
            },
            {
                "MattiasMTS/cmp-dbee",
                dependencies = {
                    {
                        "kndndrj/nvim-dbee"
                    }
                },
                ft = 'sql',
                opts = {}
            },
            {
                'rafamadriz/friendly-snippets'
            },
        },

        version = '1.*',
        opts = {
            keymap = { preset = 'super-tab' },

            appearance = {
                nerd_font_variant = 'mono'
            },

            -- (Default) Only show the documentation popup when manually triggered
            completion = { documentation = { auto_show = true } },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                {
                    "cmp-dbee"
                },
                default = { 'lsp', 'path', 'snippets', 'buffer', 'digraphs' },
                per_filetype = {
                    sql = { 'dbee', 'buffer' }
                },
                providers = {
                    dbee = { name = 'cmp-dbee', module = 'blink.compat.source' },
                    digraphs = {
                        -- IMPORTANT: use the same name as you would for nvim-cmp
                        name = 'digraphs',
                        module = 'blink.compat.source',
                        score_offset = -3,
                        opts = {
                            cache_digraphs_on_start = true,
                        },
                    },
                },

                fuzzy = { implementation = "prefer_rust_with_warning" }
            },
            opts_extend = { "sources.default" },
        },
    }
}
