-- 
-- Metrol NeoVim never ending configuration
--

--
-- Functional wrapper for mapping custom keybindings
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = " "   -- Set the <leader> key to a space


-- Show a line at col 80 as a reference
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"

vim.opt.number         = true           -- Show line numbers by default
vim.opt.relativenumber = true           -- Relative line numbers

-- Default to 4 space indenting
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.fileencoding = 'utf-8'

vim.opt.ignorecase = true				-- enable case insensitive searching
vim.opt.smartcase = true				-- all searches are case insensitive unless there's a capital letter
vim.opt.hlsearch = false				-- disable all highlighted search results
vim.opt.incsearch = true				-- enable incremental searching
vim.opt.wrap      = false               -- disable text wrapping

vim.opt.scrolloff = 8					-- scroll page when cursor is 8 lines from top/bottom
vim.opt.sidescrolloff = 8				-- scroll page when cursor is 8 spaces from left/right

vim.opt.splitbelow = true				-- split go below
vim.opt.splitright = true				-- vertical split to the right

-- Diagnostics display
vim.diagnostic.config({
    virtual_lines = true
})

-- Code folding options
vim.opt.foldcolumn = '1'
vim.opt.foldlevel  = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
map('n', '-', '<cmd>foldclose<CR>', { desc = 'Close code fold' })
map('n', '+', '<cmd>foldopen<CR>', { desc = 'Open code fold' })

-- Visual Maps
map("v", "<leader>r", "\"hy:%s/<C-r>h//g<left><left>", {desc = "Replace all instances of highlighted" })
map("v", "<C-s>", ":sort<CR>", {desc = "Sort highlighted text"})
map("v", "J", ":m '>+1<CR>gv=gv", {desc = "Move current line down"})
map("v", "K", ":m '>-2<CR>gv=gv", {desc = "Move current line up"})

-- Quick buffer switching
map("n", "<Tab>", ":bnext <CR>")				-- Tab goes to next buffer
map("n", "<S-Tab>", ":bprevious <CR>")			-- Shift+Tab goes to previous buffer
