local M = {}
local api = vim.api

local function script_template(script_name, ticket, description)
	local iso_date = os.date("%Y-%b-%d")

	local template = {
		"set term !;",
		"",
		"",
		"",
		"set term ;!",
		"",
		"insert into applied_scripts (name, description, script_date)",
		"    values ('"
			.. script_name
			.. "', '"
			.. string.upper(ticket)
			.. " - "
			.. description
			.. "', '"
			.. iso_date:upper()
			.. "');",
	}

	return template
end

local function write_to_buffer(script_name, ticket, description)
	-- Get the current buffer number
	local bufnr = api.nvim_get_current_buf()

	-- Insert the input at the current cursor position
	api.nvim_buf_set_lines(bufnr, 0, 0, false, script_template(script_name, ticket, description))
	api.nvim_buf_set_name(bufnr, script_name .. ".sql")

	local new_pos = { 3, 0 }
	local win = api.nvim_get_current_win()
	api.nvim_win_set_cursor(win, new_pos)
end

local function get_description(script_name, ticket)
	vim.ui.input({ prompt = "Enter description: " }, function(description)
		write_to_buffer(script_name, ticket, description)
	end)
end

local function get_ticket(script_name)
	vim.ui.input({ prompt = "Enter ticket: " }, function(ticket)
		get_description(script_name, ticket)
	end)
end

function M.prompt_for_input()
	local today_as_string = os.date("%y%m%d")
	vim.ui.input({ prompt = "Enter script name (YYMMDDxxNN): ", default = today_as_string }, function(script_name)
		get_ticket(script_name)
	end)
end

return M
