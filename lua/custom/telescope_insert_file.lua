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

local function substitute_placeholders(lines)
    local current_year = os.date("%Y")

    -- Simple pattern-based substitution
    for i, line in ipairs(lines) do
        lines[i] = line
        :gsub("%[YEAR%]", current_year)
        :gsub("%[DATE%]", os.date("%Y-%m-%d"))
        :gsub("%[TIME%]", os.date("%H:%M"))
        :gsub("%[FILENAME%]", vim.fn.expand("%:t"))
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
                    finder = finders.new_table({ results = results }),
                    sorter = conf.generic_sorter({}),
                    attach_mappings = function(_, map)
                        actions.select_default:replace(function(prompt_bufnr)
                            local selection = action_state.get_selected_entry()
                            actions.close(prompt_bufnr)

                            local filepath = snippets_dir .. "/" .. selection[1]
                            local lines = vim.fn.readfile(filepath)

                            lines = substitute_placeholders(lines)

                            vim.api.nvim_put(lines, "l", true, true)
                        end)
                        return true
                    end,
                }):find()
            end)
        end,
    }):start()
end

return M

