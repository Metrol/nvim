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
                    "ts_ls",
                    "bashls",
                    "gopls",
                    "phpactor"
                    -- "intelephense",
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- local get_intelephense_license = function()
            --     local f = assert(io.open(os.getenv("HOME") .. "/.config/intelephense/license.txt", "rb"))
            --     local content = f:read("*a")
            --     f:close()
            --     return string.gsub(content, "%s+", "")
            -- end

            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
            })
            lspconfig.ts_ls.setup({
                capabilities = capabilities,
            })
            lspconfig.bashls.setup({
                capabilities = capabilities,
            })
            lspconfig.gopls.setup({
                capabilities = capabilities,
            })
            -- lspconfig.intelephense.setup({
            --     capabilities = capabilities,
            --     init_options = {
            --         licenseKey = get_intelephense_license(),
            --     },
            -- })

            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "use lsp folding",
                callback = function(event)
                local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

                if not client:supports_method("textDocument/foldingRange") then
                    return
                end

                local win = vim.api.nvim_get_current_win()
                vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
                end,
            })

            vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, { desc = "Go to Definition"})
            vim.keymap.set('n', '<leader>gk', vim.lsp.buf.hover, { desc = "Show Description" })
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Find Uses" })
            vim.keymap.set('n', '<space>ga', vim.lsp.buf.code_action, { desc = "Code Action" })
            vim.keymap.set({ "n", "v" }, "<leader>ga", vim.lsp.buf.code_action, { desc = "Code Action" })

            -- Commands that don't seem to do anything with intelephense
            vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, { desc = "Declaration" }) -- doesn't work
            vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, { desc = "Implementation" }) -- doesn't work
            vim.keymap.set('n', '<leader>gK', vim.lsp.buf.signature_help, { desc = "Signature Help" }) -- doesn't work
            vim.keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition, { desc = "Type Definition" }) -- Nope
            -- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {}) -- Don't trust it
        end,
    },
}
