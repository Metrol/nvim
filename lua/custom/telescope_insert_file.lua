local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local Path = require("plenary.path")
local Job = require("plenary.job")

local M = {}

local function get_buf_extension()
    local filename = vim.api.nvim_buf_get_name(0)
    return filename:match("^.+%.(.+)$")
end

local function get_project_root()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    for _, client in ipairs(clients) do
        local root = client.config.root_dir
        if root and Path:new(root .. "/snippets"):is_dir() then
            return root
        end
    end

    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    if vim.v.shell_error == 0 and Path:new(git_root .. "/snippets"):is_dir() then
        return git_root
    end

    return nil
end

local function get_psr4_namespace(current_file, project_root)
    local composer_path = project_root .. "/composer.json"

    local f = io.open(composer_path, "r")
    if not f then return nil end

    local content = f:read("*a")
    f:close()

    local ok, decoded = pcall(vim.json.decode, content)

    if not ok or not decoded.autoload or not decoded.autoload["psr-4"] then
        return nil
    end

    for namespace, base_dir in pairs(decoded.autoload["psr-4"]) do
        local base_path = project_root .. "/" .. base_dir:gsub("/$", "")
        local abs_path = vim.fn.fnamemodify(current_file, ":p")

        if abs_path:find(base_path, 1, true) == 1 then
            local relative_ns_path = abs_path:sub(#base_path + 2)
            local ns = relative_ns_path:gsub("[/\\]", "\\"):gsub("\\[^\\]*$", "")
            return namespace .. ns
        end
    end

    return nil
end

local function substitute_placeholders(lines)
    local current_file = vim.api.nvim_buf_get_name(0)
    local project_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1] or ""

    -- Compute PHP namespace
    local php_namespace = get_psr4_namespace(current_file, project_root)

    -- Get filename without extension
    local file_no_ext = vim.fn.fnamemodify(current_file, ":t:r")

    local substitutions = {
        ["%[YEAR%]"] = os.date("%Y"),
        ["%[DATE%]"] = os.date("%Y-%m-%d"),
        ["%[TIME%]"] = os.date("%H:%M"),
        ["%[AUTHOR%]"] = os.getenv("USER") or "unknown",
        ["%[FILENAME%]"] = file_no_ext,
        ["%[PHPNAMESPACE%]"] = php_namespace,
    }

    -- Prompt for user input (supports [INPUT:key], [INPUT:"Prompt"], [INPUT:key:"Prompt"])
    local input_prompts = {}

    for _, line in ipairs(lines) do
        for raw in line:gmatch("%[INPUT:.-%]") do
            local content = raw:match("%[INPUT:(.-)%]")
            local key, prompt

            -- Match [INPUT:key:"Prompt"]
            key, prompt = content:match('^(.-):"(.-)"$')

            if not key then
                -- Match [INPUT:"Prompt"]
                prompt = content:match('^"(.-)"$')
                if prompt then
                    key = prompt
                else
                    -- Fallback to [INPUT:key]
                    key = content
                    prompt = "Enter value for " .. key
                end
            end

            if not input_prompts[key] then
                input_prompts[key] = vim.fn.input(prompt .. ": ")
            end
        end
    end

    -- Replace [PHPNS:<cutoff>] with trimmed namespace
    for i, line in ipairs(lines) do
        line = line:gsub("%[PHPNS:([%w_]+)%]", function(cutoff)
            local ns_parts = vim.split(php_namespace, "\\")
            local cutoff_index = nil
            for idx, part in ipairs(ns_parts) do
                if part == cutoff then
                    cutoff_index = idx
                    break
                end
            end
            if cutoff_index then
                return table.concat(vim.list_slice(ns_parts, 1, cutoff_index), "\\")
            else
                return php_namespace -- fallback to full namespace
            end
        end)
        lines[i] = line
    end

    -- Apply substitutions
    for i, line in ipairs(lines) do
        for pattern, value in pairs(substitutions) do
            line = line:gsub(pattern, value)
        end
        for key, value in pairs(input_prompts) do
            line = line:gsub("%[INPUT:.-%]", function(m)
                local match_content = m:match("%[INPUT:(.-)%]")
                local match_key = match_content:match('^(.-):"') or match_content:match('^"(.-)"$') or match_content
                return match_key == key and value or m
            end)
        end
        lines[i] = line
    end

    -- Track cursor placeholder
    local cursor_pos = nil
    for i, line in ipairs(lines) do
        for pattern, value in pairs(substitutions) do
            line = line:gsub(pattern, value)
        end
        for key, value in pairs(input_prompts) do
            line = line:gsub("%[INPUT:?\"?" .. key .. "\"?%]", value)
        end

        local col = line:find("%[XX%]")
        if col then
            cursor_pos = { i, col - 1 } -- 0-based indexing
            line = line:gsub("%[XX%]", "")
        end

        lines[i] = line
    end

    return lines, cursor_pos
end

function M.insert_file_from_snippets()
    local root = get_project_root()
    if not root then
        vim.notify("No 'snippets' directory found in project root", vim.log.levels.INFO)
        return
    end

    local ext = get_buf_extension()
    if not ext then
        vim.notify("Could not determine file extension", vim.log.levels.WARN)
        return
    end

    local snippets_dir = root .. "/snippets"
    local previewers = require("telescope.previewers")

    -- Use fd to find matching extension files
    Job:new({
        command = "fdfind",
        args = { "--type", "f", "--extension", ext },
        cwd = snippets_dir,
        on_exit = function(j)
            local results = j:result()
            if vim.tbl_isempty(results) then
                vim.schedule(function()
                    vim.notify("No snippets found for ." .. ext, vim.log.levels.INFO)
                end)
                return
            end

            vim.schedule(function()
                pickers.new({}, {
                    prompt_title = "Insert Snippet (." .. ext .. ")",
                    finder = finders.new_table({
                        results = vim.tbl_map(function(file)
                            local abs = Path:new(snippets_dir, file):absolute()
                            return {
                                display = file,           -- shows nicely relative in the list
                                value = abs,              -- used by previewer and insertion
                                ordinal = file,
                            }
                        end, results),
                        entry_maker = function(entry)
                            return entry
                        end,
                    }),
                    sorter = conf.generic_sorter({}),
                    previewer = previewers.new_buffer_previewer({
                        define_preview = function(self, entry, _)
                            local lines = vim.fn.readfile(entry.value)
                            if lines then
                                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
                            end
                        end,
                    }),

                    attach_mappings = function(_, map)
                        actions.select_default:replace(function(prompt_bufnr)
                            local selection = action_state.get_selected_entry()
                            actions.close(prompt_bufnr)

                            if not selection or not selection.value then
                                vim.notify("Invalid selection", vim.log.levels.ERROR)
                                return
                            end

                            local full_path = selection.value

                            if not vim.fn.filereadable(full_path) then
                                vim.notify("File not readable: " .. full_path, vim.log.levels.ERROR)
                                return
                            end

                            local lines = vim.fn.readfile(full_path)
                            if vim.tbl_isempty(lines) then
                                vim.notify("Snippet is empty", vim.log.levels.WARN)
                                return
                            end

                            -- lines = substitute_placeholders(lines)
                            -- vim.api.nvim_put(lines, "l", false, true)
                            local new_lines, cursor_pos = substitute_placeholders(lines)
                            vim.api.nvim_put(new_lines, "l", false, true)

                            if cursor_pos then
                                local row = vim.api.nvim_win_get_cursor(0)[1] - #new_lines + cursor_pos[1] - 1
                                local col = cursor_pos[2]
                                vim.api.nvim_win_set_cursor(0, { row, col })
                            end
                        end)
                        return true
                    end,
                }):find()
            end)
            end,
        }):start()
    end

return M

