local utils = require("sqeletor.utils")
local M = {}
local api = vim.api

local function prompt_for_data()
	-- prompt for script name
	local script_name_title = "Enter script name (YYMMDDxxNN): "
	local script_name_prompt = os.date("%y%m%d")
	local script_name = vim.fn.inputdialog(script_name_title, script_name_prompt)

	if script_name == nil then
		return nil
	end

	-- prompt for ticket number
	local ticket_name_title = "Enter ticket: "
	local ticket_name = vim.fn.inputdialog(ticket_name_title)

	if ticket_name == nil then
		return nil
	end

	-- prompt for description
	local description_title = "Enter description: "
	local description = vim.fn.inputdialog(description_title)

	if description == nil then
		return nil
	end

	return { script_name = script_name, ticket_name = ticket_name, description = description }
end

local function script_template(result)
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
			.. result.script_name
			.. "', '"
			.. string.upper(result.ticket_name)
			.. " - "
			.. result.description
			.. "', '"
			.. tostring(iso_date):upper()
			.. "');",
	}

	return template
end

local function write_to_buffer(result)
	local bufnr = api.nvim_create_buf(true, false)
	api.nvim_set_current_buf(bufnr)

	api.nvim_buf_set_lines(bufnr, 0, 0, false, script_template(result))
	-- api.nvim_buf_set_name(bufnr, current_dir .. "\\" .. result.script_name .. ".sql")
	local test_file_root = utils.find_root()
	print(test_file_root)
	api.nvim_buf_set_name(bufnr, result.script_name .. ".sql")
	api.nvim_buf_set_option(bufnr, "filetype", "sql")

	-- reposition the cursor to the appropriate location to start entering the script info
	local new_pos = { 3, 0 }
	local win = api.nvim_get_current_win()
	api.nvim_win_set_cursor(win, new_pos)
end

function M.prompt_for_input()
	local result = prompt_for_data()
	if result == nil then
		return
	else
		write_to_buffer(result)
	end
end

return M
