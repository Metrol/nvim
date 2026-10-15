local M = {}

-- Return this buffer's connection, or DBee's current connection for scratchpads.
function M.connection(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local api = require("dbee").api.core
    local id = vim.b[bufnr].dbee_connection_id
    if id then
        local ok, connection = pcall(api.connection_get_params, id)
        return ok and connection or nil
    end
    return api.get_current_connection()
end

function M.activate(bufnr)
    local connection = M.connection(bufnr)
    if not connection then
        return nil
    end
    local api = require("dbee").api.core
    local current = api.get_current_connection()
    if not current or current.id ~= connection.id then
        api.set_current_connection(connection.id)
    end
    return connection
end

function M.connect(bufnr, callback)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    if vim.bo[bufnr].filetype ~= "sql" then
        return
    end
    local dbee = require("dbee")
    local api = dbee.api.core
    local choices = {}
    for _, source in ipairs(api.get_sources()) do
        for _, connection in ipairs(api.source_get_connections(source:name())) do
            choices[#choices + 1] = connection
        end
    end
    table.sort(choices, function(a, b) return a.name < b.name end)
    if #choices == 0 then
        vim.notify("Add a connection in DBee first (Space Do).", vim.log.levels.WARN)
        return
    end
    vim.ui.select(choices, {
        prompt = "Connect SQL buffer to DBee:",
        format_item = function(connection)
            return connection.name .. " (" .. connection.type .. ")"
        end,
    }, function(connection)
        if not connection or not vim.api.nvim_buf_is_valid(bufnr) then
            return
        end
        local ok, err = pcall(function()
            api.connection_get_structure(connection.id)
            -- Initialize completion's UI state without opening the DBee layout.
            dbee.api.ui.result_get_call()
            api.set_current_connection(connection.id)
        end)
        if not ok then
            vim.notify("DBee connection failed: " .. tostring(err), vim.log.levels.ERROR)
            return
        end
        vim.b[bufnr].dbee_connection_id = connection.id
        dbee.api.ui.editor_attach_buffer(bufnr, connection.id)
        vim.notify("SQL buffer connected to " .. connection.name)
        if callback then
            callback(connection)
        else
            dbee.open()
        end
    end)
end

-- Open the actual project buffer in DBee's editor pane, not a copied query.
function M.open()
    local bufnr = vim.api.nvim_get_current_buf()
    local dbee = require("dbee")
    if vim.bo[bufnr].filetype ~= "sql" or vim.bo[bufnr].buftype ~= "" then
        dbee.open()
        return
    end
    local note = dbee.api.ui.editor_search_note_with_buf(bufnr)
    if note and not note.external then
        dbee.api.ui.editor_set_current_note(note.id)
        dbee.open()
        return
    end
    if vim.b[bufnr].dbee_connection_id then
        local connection = M.activate(bufnr)
        if connection then
            dbee.api.ui.editor_attach_buffer(bufnr, connection.id)
            dbee.open()
            return
        end
    end
    M.connect(bufnr)
end

function M.run(selection)
    local bufnr = vim.api.nvim_get_current_buf()
    local lines
    if selection then
        lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), {
            type = vim.fn.mode(),
            exclusive = vim.o.selection == "exclusive",
        })
        vim.cmd.normal({ args = { vim.api.nvim_replace_termcodes("<Esc>", true, false, true) }, bang = true })
    else
        lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    end
    local query = table.concat(lines, "\n")
    if not query:find("%S") then
        vim.notify("No SQL to run.", vim.log.levels.WARN)
        return
    end
    local function execute(connection)
        local dbee = require("dbee")
        local ok, err = pcall(function()
            dbee.api.core.set_current_connection(connection.id)
            dbee.api.ui.editor_attach_buffer(bufnr, connection.id)
            dbee.api.core.connection_run(connection.id, query, bufnr, function(call)
                dbee.api.ui.result_set_call(call)
                dbee.open()
            end)
        end)
        if not ok then
            vim.notify("DBee query failed: " .. tostring(err), vim.log.levels.ERROR)
        end
    end
    -- Require an explicit binding for project buffers; don't silently use
    -- whichever connection was last selected in DBee's drawer.
    if vim.b[bufnr].dbee_connection_id then
        local connection = M.connection(bufnr)
        if connection then
            execute(connection)
            return
        end
    end
    M.connect(bufnr, execute)
end

function M.setup()
    local function map_buffer(bufnr)
        local opts = { buffer = bufnr, desc = "Connect SQL buffer to database" }
        vim.keymap.set("n", "<leader>Db", function() M.connect(bufnr) end, opts)
        vim.keymap.set("n", "<leader>Dr", function() M.run(false) end,
            { buffer = bufnr, desc = "Run SQL buffer" })
        vim.keymap.set("x", "<leader>Dr", function() M.run(true) end,
            { buffer = bufnr, desc = "Run selected SQL" })
    end
    local group = vim.api.nvim_create_augroup("DbeeProjectBuffers", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "sql",
        callback = function(event) map_buffer(event.buf) end,
    })
    vim.api.nvim_create_autocmd("BufEnter", {
        group = group,
        callback = function(event)
            if vim.bo[event.buf].filetype == "sql" and vim.b[event.buf].dbee_connection_id then
                pcall(M.activate, event.buf)
            end
        end,
    })
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[bufnr].filetype == "sql" then
            map_buffer(bufnr)
        end
    end
end

return M
