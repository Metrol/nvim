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

        self.sidebar_visible = true
        if valid(previous) then vim.api.nvim_set_current_win(previous) end
    end

    function layout:hide_sidebar()
        local drawer = self.windows.drawer
        if valid(drawer) then self.drawer_width = vim.api.nvim_win_get_width(drawer) end
        local current = vim.api.nvim_get_current_win()
        if current == drawer then
            vim.api.nvim_set_current_win(self.windows.editor)
        end
        if valid(drawer) then vim.api.nvim_win_close(drawer, false) end
        self.windows.drawer = nil
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
