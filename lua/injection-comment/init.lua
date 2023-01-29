local M = {
	conf = {
		available_parsers = {},
		prefix = "query:ft:",
		pattern = "[%l]+",
		cmp = false,
	},
}

local function get_available_parsers()
	local available_parsers = {}
	local parsers_files = vim.api.nvim_get_runtime_file("parser/**.*", true)

	for _, parser in ipairs(parsers_files) do
		local parser_name = vim.fn.fnamemodify(parser, ":t:r")
		table.insert(available_parsers, parser_name)
	end

	return available_parsers
end

vim.treesitter.query.add_predicate("injection_comment?", function(
	match, -- :table,
	_, -- pattern:string
	bufnr, -- :number
	predicate, -- :string[]
	_ -- metadata:table
)
	local node = match[predicate[2]]
	local comment_text = vim.treesitter.query.get_node_text(node, bufnr)
	return comment_text:match(M.conf.prefix .. M.conf.pattern)
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
	local lang = comment_text:match(M.conf.prefix .. M.conf.pattern):sub(#M.conf.prefix + 1) or ""

	for _, value in ipairs(M.conf.available_parsers) do
		if value == lang then
			metadata.language = lang
			break
		end
	end
end)

function M.setup(conf)
	M.conf.prefix = conf.prefix or M.conf.prefix
	M.conf.pattern = conf.pattern or M.conf.pattern
	M.conf.available_parsers = conf.available_parsers or get_available_parsers()
	M.conf.cmp = conf.cmp

	if M.conf.cmp then
		require("injection-comment.cmp").init(M.conf)
	end
end

return M
