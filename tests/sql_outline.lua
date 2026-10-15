-- Run with the configured editor: nvim --headless -i NONE '+luafile tests/sql_outline.lua'
local ok, err = xpcall(function()
	local provider = require("outline.providers.sql")
	local function sql_buffer(sql)
		local buffer = vim.api.nvim_create_buf(true, false)
		vim.bo[buffer].filetype = "sql"
		vim.api.nvim_buf_set_lines(buffer, 0, -1, false, vim.split(sql, "\n"))
		return buffer
	end
	local function symbols(buffer)
		local supported, info = provider.supports_buffer(buffer)
		assert(supported)
		local result, options
		provider.request_symbols(function(value, opts)
			result, options = value, opts
		end, { test = true }, info)
		assert(options.test)
		return result
	end
	local source = [[-- WITH fake AS (SELECT 0)
WITH first_cte AS (
  SELECT ':not_a_parameter WITH fake AS (SELECT 0)' AS label
), second_cte AS (
  SELECT label FROM first_cte WHERE label = :label
)
SELECT * FROM second_cte;
SELECT 2;
]]
	local buffer = sql_buffer(source)
	local tree = symbols(buffer)
	assert(#tree == 2 and tree[1].name == "WITH query" and tree[2].name == "SELECT", vim.inspect(tree))
	assert(#tree[1].children == 3)
	local first, second, main = unpack(tree[1].children)
	assert(first.name == "first_cte" and first.selectionRange.start.line == 1)
	assert(second.name == "second_cte" and second.selectionRange.start.line == 3)
	assert(main.name == "SELECT" and main.selectionRange.start.line == 6)
	assert(first.range["end"].line == 3 and second.range["end"].line == 5)
	local nested = sql_buffer([[WITH RECURSIVE "Top" (id) AS (
  WITH "Inner界" AS (SELECT 1)
  SELECT * FROM "Inner界"
), other AS MATERIALIZED (SELECT :id::int)
SELECT * FROM "Top";]])
	local recursive = symbols(nested)[1]
	assert(recursive.name == "WITH RECURSIVE query")
	assert(recursive.children[1].name == '"Top"')
	assert(recursive.children[1].children[1].children[1].name == '"Inner界"', vim.inspect(recursive))
	assert(recursive.children[2].name == "other")
	assert(symbols(buffer)[1].children[1].name == "first_cte", "Buffers must not share parser state")
	local malformed = sql_buffer("WITH unfinished AS (SELECT")
	assert(type(symbols(malformed)) == "table")
	local lua_buffer = vim.api.nvim_create_buf(true, false)
	vim.bo[lua_buffer].filetype = "lua"
	assert(not provider.supports_buffer(lua_buffer))
	vim.api.nvim_set_current_buf(buffer)
	vim.cmd("OutlineOpen")
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	assert(vim.bo.filetype == "Outline", "Outline did not open")
	vim.cmd("normal l") -- Preserve the existing Outline folding behavior.
	lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	assert(table.concat(lines, "\n"):find("first_cte", 1, true), "Expanding WITH must show its CTEs")
	local line
	for index, text in ipairs(lines) do
		if text:find("second_cte", 1, true) then
			line = index
			break
		end
	end
	assert(line)
	vim.api.nvim_win_set_cursor(0, { line, 0 })
	vim.cmd.normal({ args = { vim.api.nvim_replace_termcodes("<CR>", true, false, true) }, bang = false })
	assert(vim.api.nvim_get_current_buf() == buffer)
	assert(vim.api.nvim_win_get_cursor(0)[1] == 4, "Outline must jump to the selected CTE definition")
	assert(table.concat(vim.api.nvim_buf_get_lines(buffer, 0, -1, false), "\n") == source)
	print(
		"PASS: SQL CTEs, nested/recursive/quoted definitions, parameters, multiple buffers, malformed SQL, and real Outline navigation"
	)
end, debug.traceback)
if not ok then
	io.stderr:write(err .. "\n")
end
vim.cmd(ok and "qa!" or "cquit 1")
