local M = {}
local tree_widths = {}
local quitting = false
local buffer_visits = {}
local visit = 0

local function editing_buffers()
    local buffers = {}
    for _, info in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
        if vim.bo[info.bufnr].buftype == "" and vim.bo[info.bufnr].filetype ~= "dashboard" then
            local lines = vim.api.nvim_buf_get_lines(info.bufnr, 0, 2, false)
            if info.name ~= "" or vim.bo[info.bufnr].modified or #lines > 1 or (lines[1] or "") ~= "" then
                table.insert(buffers, info)
            end
        end
    end
    table.sort(buffers, function(a, b)
        local a_visit, b_visit = buffer_visits[a.bufnr] or 0, buffer_visits[b.bufnr] or 0
        if a_visit ~= b_visit then
            return a_visit > b_visit
        end
        if a.lastused ~= b.lastused then
            return a.lastused > b.lastused
        end
        return a.bufnr > b.bufnr
    end)
    return buffers
end

local function normal_windows(tab)
    local windows = {}
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
        if vim.api.nvim_win_get_config(win).relative == "" then
            table.insert(windows, win)
        end
    end
    return windows
end

local function reconcile(tab, deleted)
    if vim.v.exiting ~= vim.NIL and vim.v.exiting ~= nil then
        return
    end
    if not vim.api.nvim_tabpage_is_valid(tab) or vim.api.nvim_get_current_tabpage() ~= tab then
        return
    end

    local buffers = editing_buffers()
    local windows = normal_windows(tab)
    if #windows == 0 then
        return
    end

    -- A deleted final buffer should leave one dashboard, without closing tools
    -- such as terminals or help windows that still have useful content.
    if deleted and #buffers == 0 then
        local target = windows[1]
        for _, win in ipairs(windows) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            if ft ~= "neo-tree" and ft ~= "dashboard" then
                if vim.bo[buf].buftype ~= "" then
                    return
                end
                target = win
            end
        end
        if #windows == 1 and vim.bo[vim.api.nvim_win_get_buf(target)].filetype == "dashboard" then
            return
        end
        vim.api.nvim_set_current_win(target)
        for _, win in ipairs(windows) do
            if win ~= target then
                vim.api.nvim_win_close(win, false)
            end
        end
        vim.cmd("Dashboard")
        return
    end

    -- Closing a window leaves its buffer available. Restore the most recently
    -- used file beside the tree, or open the dashboard if no files remain.
    for _, win in ipairs(windows) do
        if vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "neo-tree" then
            return
        end
    end
    local tree = windows[1]
    local width = tree_widths[tree] or 40
    local buf = buffers[1] and buffers[1].bufnr or vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, { split = "right", win = tree })
    vim.api.nvim_win_set_width(tree, width)
    if buffers[1] then
        vim.api.nvim_set_current_win(win)
        -- Barbar's default close behavior uses the alternate buffer. A split
        -- restored from the tree must point at a file, rather than the tree.
        vim.fn.setreg("#", tostring((buffers[2] or buffers[1]).bufnr))
    else
        vim.cmd("Dashboard")
    end
end

function M.setup()
    local group = vim.api.nvim_create_augroup("editing_windows", { clear = true })
    vim.api.nvim_create_autocmd("BufEnter", {
        group = group,
        callback = function(event)
            if vim.bo[event.buf].buftype == "" and vim.bo[event.buf].filetype ~= "dashboard" then
                visit = visit + 1
                buffer_visits[event.buf] = visit
            end
        end,
    })
    vim.api.nvim_create_autocmd("WinLeave", {
        group = group,
        callback = function()
            for _, win in ipairs(normal_windows(vim.api.nvim_get_current_tabpage())) do
                if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "neo-tree" then
                    tree_widths[win] = vim.api.nvim_win_get_width(win)
                end
            end
        end,
    })
    vim.api.nvim_create_autocmd("QuitPre", {
        group = group,
        callback = function()
            quitting = true
            vim.schedule(function()
                quitting = false
            end)
        end,
    })
    vim.api.nvim_create_autocmd({ "BufDelete", "WinClosed" }, {
        group = group,
        desc = "Restore an editing window or the dashboard",
        callback = function(event)
            if quitting then
                return
            end
            if event.event == "BufDelete" and
                (vim.bo[event.buf].buftype ~= "" or vim.bo[event.buf].filetype == "dashboard") then
                return
            end
            if event.event == "BufDelete" and vim.api.nvim_buf_get_name(event.buf) == "" and
                not vim.bo[event.buf].modified then
                local lines = vim.api.nvim_buf_get_lines(event.buf, 0, 2, false)
                if #lines <= 1 and (lines[1] or "") == "" then
                    return
                end
            end
            local tab = vim.api.nvim_get_current_tabpage()
            vim.schedule(function()
                reconcile(tab, event.event == "BufDelete")
            end)
        end,
    })
end

return M
