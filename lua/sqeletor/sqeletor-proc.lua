local M = {}
local api = vim.api

local function proc_template(proc_name)
	local template = {
		"set term !;",
		"",
		"alter procedure " .. proc_name .. "()",
		"returns ()",
		"as",
		"begin",
		"",
		"    suspend;",
		"end!",
		"",
		"set term ;!",
		"",
		"/* add the following to the appropriate AIS8_Procedures.scl and remove this comment",
		"",
		"   SCRIPT=" .. proc_name .. ".sps",
		"",
		"*/",
	}

	return template
end

local function script_template(script_name, ticket, description, proc_name)
	local iso_date = os.date("%Y-%b-%d")

	local template = {
		"set term !;",
		"",
		"create procedure " .. proc_name .. "()",
		"returns ()",
		"as",
		"begin",
		"    suspend;",
		"end!",
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

local function write_to_buffer(script_name, ticket, description, proc_name)
	-- Get the current buffer number
	local bufnr = api.nvim_get_current_buf()

	-- Insert the input at the current cursor position
	api.nvim_buf_set_lines(bufnr, 0, 0, false, script_template(script_name, ticket, description, proc_name))
	api.nvim_buf_set_name(bufnr, script_name .. ".sql")

	-- create the new buffer and put the procedure template in there
	local proc_buffer = api.nvim_create_buf(true, false)
	api.nvim_set_current_buf(proc_buffer)
	bufnr = api.nvim_get_current_buf()
	api.nvim_buf_set_lines(bufnr, 0, 0, false, proc_template(proc_name))
	api.nvim_buf_set_name(bufnr, proc_name .. ".sql")

	local new_pos = { 7, 0 }
	local win = api.nvim_get_current_win()
	api.nvim_win_set_cursor(win, new_pos)
end

local function get_proc_name(script_name, ticket, description)
	vim.ui.input({ prompt = "Enter procedure name: " }, function(proc_name)
		write_to_buffer(script_name, ticket, description, proc_name)
	end)
end

local function get_description(script_name, ticket)
	vim.ui.input({ prompt = "Enter description: " }, function(description)
		get_proc_name(script_name, ticket, description)
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
