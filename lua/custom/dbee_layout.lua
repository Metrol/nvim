local M = {}
local active

function M.new()
    local ui = require("dbee.api.ui")
    local tools = require("dbee.layouts.tools")
    local layout = require("dbee.layouts").Default:new()
    layout.sidebar_visible = true

    local function valid(win)
        return win and vim.api.nvim_win_is_valid(win)
    end

    function layout:show_sidebar()
        local previous = vim.api.nvim_get_current_win()
        vim.api.nvim_set_current_win(self.windows.editor)
        -- Split only the upper editor area, leaving results across the bottom.
        vim.cmd("leftabove " .. self.drawer_width .. "vsplit")
        local drawer = vim.api.nvim_get_current_win()
        self.windows.drawer = drawer
        ui.drawer_show(drawer)
        self:configure_window_on_switch(self.on_switch, drawer, ui.drawer_show)
        self:configure_window_on_quit(drawer)

        vim.cmd("belowright " .. self.call_log_height .. "split")
        local history = vim.api.nvim_get_current_win()
        self.windows.call_log = history
        ui.call_log_show(history)
        self:configure_window_on_switch(self.on_switch, history, ui.call_log_show)
        self:configure_window_on_quit(history)
        self.sidebar_visible = true
        if valid(previous) then vim.api.nvim_set_current_win(previous) end
    end

    function layout:hide_sidebar()
        local drawer, history = self.windows.drawer, self.windows.call_log
        if valid(drawer) then self.drawer_width = vim.api.nvim_win_get_width(drawer) end
        if valid(history) then self.call_log_height = vim.api.nvim_win_get_height(history) end
        local current = vim.api.nvim_get_current_win()
        if current == drawer or current == history then
            vim.api.nvim_set_current_win(self.windows.editor)
        end
        for _, name in ipairs({ "call_log", "drawer" }) do
            local win = self.windows[name]
            if valid(win) then vim.api.nvim_win_close(win, false) end
            self.windows[name] = nil
        end
        self.sidebar_visible = false
    end

    function layout:toggle_sidebar()
        if not self:is_open() then return end
        if self.sidebar_visible then self:hide_sidebar() else self:show_sidebar() end
    end

    function layout:open()
        self.egg = tools.save()
        self.windows = {}
        tools.make_only(0)
        local editor = vim.api.nvim_get_current_win()
        self.windows.editor = editor
        ui.editor_show(editor)
        self:configure_window_on_switch(self.on_switch, editor, ui.editor_show, true)
        self:configure_window_on_quit(editor)

        vim.cmd("botright " .. self.result_height .. "split")
        local result = vim.api.nvim_get_current_win()
        self.windows.result = result
        ui.result_show(result)
        self:configure_window_on_switch(self.on_switch, result, ui.result_show)
        self:configure_window_on_quit(result)
        if self.sidebar_visible then self:show_sidebar() end
        vim.api.nvim_set_current_win(editor)
        self.is_opened = true
        self:reset()
    end

    function layout:reset()
        local available = vim.o.lines - vim.o.cmdheight - 2
        local result_height = math.max(1, math.min(self.result_height, math.floor(available / 2)))
        if valid(self.windows.drawer) then
            vim.api.nvim_win_set_width(self.windows.drawer, self.drawer_width)
        end
        if valid(self.windows.call_log) then
            local history_height = math.max(1, math.min(self.call_log_height, math.floor((available - result_height) / 3)))
            vim.api.nvim_win_set_height(self.windows.call_log, history_height)
        end
        -- Size results last, after all upper-pane splits have been resized.
        if valid(self.windows.result) then
            vim.api.nvim_win_set_height(self.windows.result, result_height)
        end
    end

    active = layout
    return layout
end

function M.toggle_sidebar()
    if not active or not active:is_open() then
        require("dbee").open()
        return
    end
    active:toggle_sidebar()
end

return M
