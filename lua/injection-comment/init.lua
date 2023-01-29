local M = {}

local function get_available_parsers()
	local available_parsers = {}
	local parsers_files = vim.api.nvim_get_runtime_file("parser/**.*", true)

	for _, parser in ipairs(parsers_files) do
		local parser_name = vim.fn.fnamemodify(parser, ":t:r")
		table.insert(available_parsers, parser_name)
	end

	return available_parsers
end

local function init_ts(conf)
	local hl_query_prefix = "query:ft:"
	local hl_query_pattern = hl_query_prefix .. "[%l]+"

	vim.treesitter.query.add_predicate("injection_comment?", function(
		match, -- :table,
		_, -- pattern:string
		bufnr, -- :number
		predicate, -- :string[]
		_ -- metadata:table
	)
		local node = match[predicate[2]]
		local comment_text = vim.treesitter.query.get_node_text(node, bufnr)
		return comment_text:match(hl_query_pattern)
	end)

	vim.treesitter.query.add_directive("injection_comment!", function(
		match, -- :table,
		_, -- pattern:string
		bufnr, -- :number
		predicate, -- :string[]
		metadata -- :table
	)
		local node = match[predicate[2]]
		local comment_text = vim.treesitter.query.get_node_text(node, bufnr)
		local lang = comment_text:match(hl_query_pattern):sub(#hl_query_prefix + 1) or ""

		for _, value in ipairs(conf.available_parsers) do
			if value == lang then
				metadata.language = lang
				break
			end
		end
	end)
end

function M.setup(conf)
	conf = conf or {}
	conf.prefix = conf.prefix or "query:ft:"
	conf.available_parsers = get_available_parsers()

	init_ts(conf)

	if conf.cmp then
		require("injection-comment.cmp").init(conf)
	end
end

return M
