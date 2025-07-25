return {
    {
        "hrsh7th/cmp-nvim-lsp"
    },
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
            require("luasnip.loaders.from_vscode").lazy_load()
			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
                        -- For `luasnip` users.
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
                    -- Accept currently selected item. Set `select` to `false`
                    -- to only confirm explicitly selected items. 
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
                    { name = 'vim-dadbod-completion' },
					{ name = "luasnip" }, -- For luasnip users.
                    { name = "lazydev", group_index = 1 },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
}
