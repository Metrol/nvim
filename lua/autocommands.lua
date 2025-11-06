-- 
-- Metrol NeoVim never ending configuration
--
vim.api.nvim_create_autocmd("FileType", {
    pattern = "php",
    command = "setlocal autoindent smartindent indentexpr="
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "js",
    command = "setlocal autoindent smartindent indentexpr="
})

-- Refreshes the NeoTree file listing after LazyGit closes
-- vim.api.nvim_create_autocmd({ "BufLeave" }, {
-- 	pattern = { "*lazygit*" },
-- 	group = vim.api.nvim_create_augroup("git_refresh_neotree", {clear = true}),
-- 	callback = function()
-- 		require("neo-tree.sources.filesystem.commands").refresh(
-- 			require("neo-tree.sources.manager").get_state("filesystem")
-- 		)
-- 	end,
-- })

-- Set the mode to "normal" after telescope has selected a file
vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave" }, {
    callback = function(event)
        if vim.bo[event.buf].filetype == "TelescopePrompt" then
            vim.api.nvim_exec2("silent! stopinsert!", {})
        end
    end
})

-- Should bring up the Dashboard once the last buffer has closed
vim.api.nvim_create_autocmd("BufDelete", {
    group = vim.api.nvim_create_augroup("bufdelpost_autocmd", {}),
    desc = "BufDeletePost User autocmd",
    callback = function()
        vim.schedule(function()
            vim.api.nvim_exec_autocmds("User", {
                pattern = "BufDeletePost",
            })
        end)
    end,
})

-- Opens the dashboard after the last buffer has been closed
vim.api.nvim_create_autocmd("User", {
    pattern = "BufDeletePost",
    group = vim.api.nvim_create_augroup("dashboard_delete_buffers", {}),
    desc = "Open Dashboard when no available buffers",
    callback = function(ev)
        local deleted_name = vim.api.nvim_buf_get_name(ev.buf)
        local deleted_ft = vim.api.nvim_get_option_value("filetype", { buf = ev.buf })
        local deleted_bt = vim.api.nvim_get_option_value("buftype", { buf = ev.buf })
        local dashboard_on_empty = deleted_name == "" and deleted_ft == "" and deleted_bt == ""

        if dashboard_on_empty then
            vim.cmd("Dashboard")
        end
    end,
})
