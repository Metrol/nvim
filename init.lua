local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("vim-options")
require("lazy").setup("plugins")

vim.api.nvim_create_autocmd("FileType", {
    pattern = "php",
    command = "setlocal autoindent smartindent indentexpr="
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "js",
    command = "setlocal autoindent smartindent indentexpr="
})

vim.api.nvim_create_autocmd({ "BufLeave" }, {
	pattern = { "*lazygit*" },
	group = vim.api.nvim_create_augroup("git_refresh_neotree", {clear = true}),
	callback = function()
		require("neo-tree.sources.filesystem.commands").refresh(
			require("neo-tree.sources.manager").get_state("filesystem")
		)
	end,
})
