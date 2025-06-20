vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set number relativenumber")
vim.cmd("set colorcolumn=80")
vim.cmd("set cursorline")

vim.g.mapleader = " "

vim.opt.ignorecase = true				-- enable case insensitive searching
vim.opt.smartcase = true				-- all searches are case insensitive unless there's a capital letter
vim.opt.hlsearch = false				-- disable all highlighted search results
vim.opt.incsearch = true				-- enable incremental searching

vim.opt.scrolloff = 8					-- scroll page when cursor is 8 lines from top/bottom
vim.opt.sidescrolloff = 8				-- scroll page when cursor is 8 spaces from left/right

vim.opt.splitbelow = true				-- split go below
vim.opt.splitright = true				-- vertical split to the right

-- Functional wrapper for mapping custom keybindings
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Visual Maps
map("v", "<leader>r", "\"hy:%s/<C-r>h//g<left><left>", {desc = "Replace all instances of highlighted" })
map("v", "<C-s>", ":sort<CR>", {desc = "Sort highlighted text"})
map("v", "J", ":m '>+1<CR>gv=gv", {desc = "Move current line down"})
map("v", "K", ":m '>-2<CR>gv=gv", {desc = "Move current line up"})
