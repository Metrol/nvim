return {
    {
        "neovim/nvim-lspconfig",
        dependencies = { 'saghen/blink.cmp' },
        config = function()
            local get_intelephense_license = function()
                local f = assert(io.open(os.getenv("HOME") .. "/.config/intelephense/license.txt", "rb"))
                local content = f:read("*a")
                f:close()
                return string.gsub(content, "%s+", "")
            end

            vim.lsp.config('intelephense', {
                init_options = {
                    licenseKey = get_intelephense_license(),
                },
            })

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

            vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, { desc = "Go to Definition" })
            vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, { desc = "Go to Declaration" })
            vim.keymap.set('n', '<leader>gk', vim.lsp.buf.hover, { desc = "Show Description" })
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Find Uses" })
            vim.keymap.set('n', '<leader>ga', vim.lsp.buf.code_action, { desc = "Code Action" })
            vim.keymap.set('n', '<leader>gc', ':LspRestart<CR>', { desc = "Restart LSP Servers" })
            vim.keymap.set({ "n", "v" }, "<leader>ga", vim.lsp.buf.code_action, { desc = "Code Action" })

            -- Trying these again
            vim.keymap.set('n', '<leader>gK', vim.lsp.buf.signature_help, { desc = "Signature Help" })
            vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, { desc = "Go to Implementation" })
            vim.keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition, { desc = "Type Definition" })

            -- Commands that don't seem to do anything with intelephense
            -- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {}) -- Don't trust it
        end,
    },
}
