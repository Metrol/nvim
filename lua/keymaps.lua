--
-- Metrol NeoVim never ending configuration
--

-- Functional wrapper for mapping custom keybindings
function Map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.keymap.set('n', '<leader>xt', function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })

-- Close quick fix window after pressing enter
vim.keymap.set("n", "<CR>", "<CR><Cmd>cclose<CR>",
    { buffer = false, noremap = true, silent = true })

-- Super star search, but don't jump away
Map('n', '*', '*N')

-- Turn off highlights quickly
vim.opt.hlsearch = true
Map('n', '<leader>/', ':noh<CR>', { desc = 'Disable highlights from search' })

Map('n', '-', '<cmd>foldclose<CR>', { desc = 'Close code fold' })
Map('n', '+', '<cmd>foldopen<CR>', { desc = 'Open code fold' })

-- Copy paste to the system clipboard
vim.keymap.set({'n', 'v', 'x'}, '<leader>cy', '"+y<CR>', { desc = 'Copy to system clipboard'})
vim.keymap.set({'n', 'v', 'x'}, '<leader>cd', '"+d<CR>', { desc = 'Cut to system clipboard'})
vim.keymap.set({'n', 'v'}, '<leader>cp', '"+p<CR>', { desc = 'Paste from system clipboard'})

-- Paste without overwriting register
vim.keymap.set("v", "p", '"_dP')

-- Make Y behave like C or D
vim.keymap.set("n", "Y", "y$")

-- Select all
vim.keymap.set("n", "==", "gg<S-v>G")

-- Visual Maps
Map("v", "<leader>r", "\"hy:%s/<C-r>h//g<left><left>", {desc = "Replace all instances of highlighted" })
Map("v", "<C-s>", ":sort<CR>", {desc = "Sort highlighted text"})
Map("v", "J", ":m '>+1<CR>gv=gv", {desc = "Move current line down"})
Map("v", "K", ":m '>-2<CR>gv=gv", {desc = "Move current line up"})

-- Quick buffer switching
Map("n", "<Tab>", ":bnext <CR>")				-- Tab goes to next buffer
Map("n", "<S-Tab>", ":bprevious <CR>")			-- Shift+Tab goes to previous buffer

-- Toggle word wrap
vim.opt.linebreak = true
-- Map("n", "<leader>sw", ":set wrap! <CR>", { desc = "Toggle word wrap" })
-- Lua function to toggle wrap and colorcolumn
vim.api.nvim_set_keymap('n', '<leader>pw', '', {
    desc = 'Toggle word wrap and colorcolumn',
    callback = function()
        -- Toggle wrap
        vim.wo.wrap = not vim.wo.wrap
        -- Set colorcolumn based on wrap state
        vim.wo.colorcolumn = vim.wo.wrap and '' or '80'
    end
})
Map("n", "<leader>pt", ":Themify <CR>", { desc = "Set color theme" })
Map("n", "<leader>pl", ":Lazy <CR>", { desc = "Manage plugins" })
Map("n", "<leader>pm", ":Mason <CR>", { desc = "Manage LSPs" })
Map("n", "<leader>ph", ":set cursorline! <CR>", { desc = "Toggle line highlight" })

vim.keymap.set('n', '<leader>pd', function()
    local new_config = not vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })

-- Quick fix list related key maps
Map('n', '<leader>qo', ':copen <CR>', { desc = 'Open quickfix window'})
Map('n', '<leader>qq', ':cclose <CR>', { desc = 'Close quickfix window'})
Map('n', '<leader>qn', ':cnext <CR>', { desc = 'Next quick fix item'})
Map('n', '<leader>qp', ':cprevious <CR>', { desc = 'Previous quick fix item'})
Map('n', '<leader>qf', ':Telescope quickfix <CR>', { desc = 'Open quick fix picker'})

