-- Extend cmp-dbee's column matching while retaining its table/keyword source.
local M = {}

local function identifier(node, bufnr)
    if not node then
        return nil
    end
    local text = vim.treesitter.get_node_text(node, bufnr)
    if text:sub(1, 1) == '"' then
        return text:sub(2, -2):gsub('""', '"')
    end
    return text:lower()
end

local function find_table(bufnr, row, start_col, end_col, alias)
    -- Parse a complete placeholder in place of the field being typed. An
    -- unfinished `r.` can otherwise make FROM disappear into a parser error.
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    lines[row + 1] = lines[row + 1]:sub(1, start_col)
        .. "__dbee_column__" .. lines[row + 1]:sub(end_col + 1)
    local sql = table.concat(lines, "\n")
    local parser = vim.treesitter.get_string_parser(sql, "sql")
    local root = parser:parse()[1]:root()
    local statement = root:named_descendant_for_range(row, start_col, row, start_col)
    while statement and statement:type() ~= "statement" do
        if statement:type():find("comment") or statement:type() == "literal" then
            return nil
        end
        statement = statement:parent()
    end
    if not statement then
        return nil
    end

    local matches = {}
    local function visit(node)
        if node ~= statement and node:type() == "statement" then
            return
        end
        if node:type() == "relation" then
            for child in node:iter_children() do
                if child:type() == "object_reference" then
                    local name = identifier(child:field("name")[1], sql)
                    local relation_alias = identifier(node:field("alias")[1], sql) or name
                    if relation_alias == alias then
                        matches[#matches + 1] = {
                            table = name,
                            schema = identifier(child:field("schema")[1], sql),
                        }
                    end
                end
            end
        end
        for child in node:iter_children() do
            visit(child)
        end
    end
    visit(statement)
    if #matches == 1 then
        return matches[1]
    end
end

function M.new()
    local api = require("dbee").api.core
    local fallback = require("cmp-dbee.source"):new(require("cmp-dbee.config").merge_defaults({}))
    local structures, columns = {}, {}
    local source = setmetatable({}, { __index = fallback })

    function source:complete(params, callback)
        local bufnr = vim.api.nvim_get_current_buf()
        if vim.b[bufnr].dbee_connection_id then
            local ok, connection = pcall(require("custom.dbee_buffers").activate, bufnr)
            if not ok or not connection then
                callback({ items = {}, isIncomplete = true })
                return
            end
        end
        local cursor = vim.api.nvim_win_get_cursor(0)
        local row, col = cursor[1] - 1, cursor[2]
        local line = vim.api.nvim_get_current_line()
        local before = line:sub(1, col)
        local alias, prefix = before:match('([%a_][%w_$]*)%.("[^"]*"?)$')
        if not alias then
            alias, prefix = before:match('([%a_][%w_$]*)%.([%w_$]*)$')
        end
        if not alias or not self:is_available() then
            return fallback:complete(params, callback)
        end

        local start_col, end_col = col - #prefix, col
        local quoted = prefix:sub(1, 1) == '"'
        if quoted and (#prefix == 1 or prefix:sub(-1) ~= '"') then
            local remaining = line:sub(col + 1):match('^([^%s"]*)"')
            if remaining then
                end_col = col + #remaining + 1
            end
        elseif not quoted then
            end_col = col + #(line:sub(col + 1):match("^[%w_$]*") or "")
        end
        local ok, items = pcall(function()
            local relation = find_table(bufnr, row, start_col, end_col, alias:lower())
            if not relation then
                return {}
            end
            local connection = require("custom.dbee_buffers").connection(bufnr)
            if not connection then
                return {}
            end
            if not relation.schema then
                structures[connection.id] = structures[connection.id] or api.connection_get_structure(connection.id)
                -- Resolve only unique unqualified names; don't guess search_path
                -- when several schemas contain a table with the same name.
                local schemas = {}
                for _, schema in ipairs(structures[connection.id]) do
                    for _, candidate in ipairs(schema.children or {}) do
                        if candidate.name == relation.table then
                            schemas[#schemas + 1] = schema.name
                        end
                    end
                end
                if #schemas ~= 1 then
                    return {}
                end
                relation.schema = schemas[1]
            end
            local key = vim.json.encode({ connection.id, relation.schema, relation.table })
            columns[key] = columns[key] or api.connection_get_columns(connection.id, relation)

            local result = {}
            for _, column in ipairs(columns[key]) do
                local text = column.name
                if quoted or not text:match("^[a-z_][a-z0-9_]*$") then
                    text = '"' .. text:gsub('"', '""') .. '"'
                end
                result[#result + 1] = {
                    label = column.name,
                    filterText = (quoted and '"' or "") .. column.name,
                    kind = vim.lsp.protocol.CompletionItemKind.Field,
                    detail = column.type,
                    textEdit = {
                        newText = text,
                        range = {
                            start = { line = row, character = vim.str_utfindex(line, "utf-16", start_col, false) },
                            ["end"] = { line = row, character = vim.str_utfindex(line, "utf-16", end_col, false) },
                        },
                    },
                }
            end
            return result
        end)
        if not ok then
            vim.notify_once("DBee column completion: " .. tostring(items), vim.log.levels.WARN)
        end
        callback({ items = ok and items or {}, isIncomplete = true })
    end

    return source
end

return M
