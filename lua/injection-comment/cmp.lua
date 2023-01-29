local M = {}

local function get_available_parsers_labels(parsers)
	local available_parsers_labels = {}
	for _, parser in ipairs(parsers) do
		table.insert(available_parsers_labels, { label = parser })
	end
	return available_parsers_labels
end

local source = {
	conf = {},
}

source.__index = source

function source.new()
	return setmetatable({}, source)
end

function source:complete(request, callback)
	local prefix = source.conf.prefix
	local available_parsers_labels = source.available_parsers_labels
	local with_prefix = request.context.cursor_before_line:sub(-#prefix) == prefix
	local prefix_label = { { label = prefix } }
	local labels = with_prefix and available_parsers_labels or prefix_label

	callback(labels)
end

function source:get_trigger_characters()
	return { ":" }
end

function source:is_available()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local pos_captures = vim.treesitter.get_captures_at_pos(0, cursor[1] - 1, cursor[2] - 1)
	local is_available = pos_captures and (pos_captures[1] and pos_captures[1].capture == "comment") or false

	return is_available
end

function M.init(conf)
	local status, cmp = pcall(require, "cmp")
	if not status then
		return
	end

	source.conf = conf
	source.available_parsers_labels = get_available_parsers_labels(conf.available_parsers)

	cmp.register_source("injection-comment", source.new())
end

return M
