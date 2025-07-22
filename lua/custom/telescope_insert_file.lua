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
        local rel_path = vim.fn.fnamemodify(current_file, ":.")

        if rel_path:find(base_path, 1, true) == 1 then
            local relative_ns_path = rel_path:sub(#base_path + 2) -- +2 to skip slash
            local ns = relative_ns_path:gsub("[/\\]", "\\"):gsub("\\[^\\]*$", "") -- trim file and convert
            return namespace .. ns
        end
    end

    return nil
end

local function substitute_placeholders(lines)
    local current_file = vim.api.nvim_buf_get_name(0)
    local project_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1] or ""
    local rel_path = vim.fn.fnamemodify(current_file, ":." .. project_root)

    -- Compute PHP namespace
    -- local php_namespace = get_psr4_namespace(current_file, project_root) or "App1"

    local php_namespace = rel_path
      :gsub("^/?src/?", "")         -- optionally trim 'src/' prefix
      :gsub("[/\\]", "\\")          -- convert to single backslashes for PHP
      :gsub("\\[^\\]*$", "")        -- remove filename

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

    -- Prompt for user input
    local input_prompts = {}
    for _, line in ipairs(lines) do
        for match in line:gmatch("%[INPUT:([%w_]+)%]") do
            if not input_prompts[match] then
                local input = vim.fn.input("Enter value for " .. match .. ": ")
                input_prompts[match] = input
            end
        end
    end

    -- Apply substitutions
    for i, line in ipairs(lines) do
        for pattern, value in pairs(substitutions) do
            line = line:gsub(pattern, value)
        end
        for key, value in pairs(input_prompts) do
            line = line:gsub("%[INPUT:" .. key .. "%]", value)
        end
        lines[i] = line
    end

    return lines
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
                    cwd = snippets_dir,
                    finder = finders.new_oneshot_job(
                        { "fdfind", "--type", "f", "--extension", ext },
                        { cwd = snippets_dir }
                    ),
                    sorter = conf.generic_sorter({}),
                    previewer = conf.file_previewer({}),
                    -- previewer = previewers.cat.net({}),
                    attach_mappings = function(_, map)
                        actions.select_default:replace(function(prompt_bufnr)
                            local selection = action_state.get_selected_entry()
                            actions.close(prompt_bufnr)

                            if not selection or not selection[1] then
                                vim.notify("Invalid selection", vim.log.levels.ERROR)
                                return
                            end

                            -- The previewer shows relative paths from cwd, so join properly
                            local full_path = Path:new(snippets_dir, selection[1]):absolute()

                            if not vim.fn.filereadable(full_path) then
                                vim.notify("File not readable: " .. full_path, vim.log.levels.ERROR)
                                return
                            end

                            local lines = vim.fn.readfile(full_path)
                            if vim.tbl_isempty(lines) then
                                vim.notify("Snippet is empty", vim.log.levels.WARN)
                                return
                            end

                            lines = substitute_placeholders(lines)
                            vim.api.nvim_put(lines, "l", false, true)
                        end)
                        return true
                    end,
                }):find()
            end)
        end,
    }):start()
end

return M

