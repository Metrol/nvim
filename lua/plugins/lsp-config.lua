return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "tsserver",
                    "bashls",
                    "intelephense",
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local get_intelephense_license = function()
                local f = assert(io.open(os.getenv("HOME") .. "/.config/intelephense/license.txt", "rb"))
                local content = f:read("*a")
                f:close()
                return string.gsub(content, "%s+", "")
            end

            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
            })
            lspconfig.tsserver.setup({
                capabilities = capabilities,
            })
            lspconfig.bashls.setup({
                capabilities = capabilities,
            })
            lspconfig.intelephense.setup({
                capabilities = capabilities,
                init_options = {
                    licenseKey = get_intelephense_license(),
                },
            })

            vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {})
            vim.keymap.set('n', '<leader>gk', vim.lsp.buf.hover, {})
            vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, {})
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

            -- Commands that don't seem to do anything with intelephense
            vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, {}) -- doesn't work
            vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, {}) -- doesn't work
            vim.keymap.set('n', '<leader>gK', vim.lsp.buf.signature_help, {}) -- doesn't work
            vim.keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition, {}) -- Nope
            -- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {}) -- Don't trust it
        end,
    },
}
