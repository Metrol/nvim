local M = { name = "sql" }

function M.supports_buffer(bufnr)
	bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
	if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "sql" then
		return false
	end
	local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "sql")
	return ok and parser ~= nil, { bufnr = bufnr }
end

local function range(node)
	local row, col, end_row, end_col = node:range()
	return {
		start = { line = row, character = col },
		["end"] = { line = end_row, character = end_col },
	}
end

local function symbol(name, kind, node, selection)
	return { name = name, kind = kind, range = range(node), selectionRange = range(selection or node), children = {} }
end

local function has_ctes(node)
	for child in node:iter_children() do
		if child:type() == "cte" then
			return true
		end
	end
	return false
end

local build_statement

-- Include WITH queries inside a CTE or subquery without listing every SELECT.
local function nested_queries(node, bufnr, children)
	if node:type() == "statement" and has_ctes(node) then
		children[#children + 1] = build_statement(node, bufnr)
		return
	end
	for child in node:iter_children() do
		if child:named() then
			nested_queries(child, bufnr, children)
		end
	end
end

build_statement = function(node, bufnr)
	local ctes, main, recursive = {}, nil, false
	for child in node:iter_children() do
		local kind = child:type()
		if kind == "cte" then
			local identifier = child:named_child(0)
			if identifier and identifier:type() == "identifier" then
				local entry = symbol(vim.treesitter.get_node_text(identifier, bufnr), 23, child, identifier)
				for part in child:iter_children() do
					if part:named() and part ~= identifier then
						nested_queries(part, bufnr, entry.children)
					end
				end
				ctes[#ctes + 1] = entry
			end
		elseif kind == "keyword_recursive" then
			recursive = true
		elseif
			not main
			and child:named()
			and kind ~= "keyword_with"
			and kind ~= "ERROR"
			and not kind:find("comment")
		then
			main = child
		end
	end

	local query
	if main then
		local name = main:type():gsub("^keyword_", ""):gsub("_", " "):upper()
		query = symbol(name, 12, node, main)
		query.range.start = range(main).start
		for child in node:iter_children() do
			if child:named() and child:type() ~= "cte" then
				nested_queries(child, bufnr, query.children)
			end
		end
	end
	if #ctes == 0 then
		return query or symbol("SQL statement", 12, node)
	end
	local group = symbol(recursive and "WITH RECURSIVE query" or "WITH query", 3, node)
	group.children = ctes
	if query then
		group.children[#group.children + 1] = query
	end
	return group
end

function M.request_symbols(callback, opts, info)
	local bufnr = info and info.bufnr or vim.api.nvim_get_current_buf()
	local ok, symbols = pcall(function()
		local parser = vim.treesitter.get_parser(bufnr, "sql")
		local tree = parser:parse()[1]
		local result = {}
		local function statements(node)
			if node:type() == "statement" then
				result[#result + 1] = build_statement(node, bufnr)
				return
			end
			for child in node:iter_children() do
				if child:named() then
					statements(child)
				end
			end
		end
		if tree then
			statements(tree:root())
		end
		return result
	end)
	callback(ok and symbols or {}, opts)
end

function M.get_status()
	return { "SQL CTE navigation using the installed Tree-sitter SQL parser." }
end

return M
