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

	-- prompt for procedure name
	local procedure_title = "Enter procedure name: "
	local procedure = vim.fn.inputdialog(procedure_title)

	if procedure == nil then
		return nil
	end

	return { script_name = script_name, ticket_name = ticket_name, description = description, procedure = procedure }
end

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

local function script_template(result)
	local iso_date = os.date("%Y-%b-%d")

	local template = {
		"set term !;",
		"",
		"create procedure " .. result.procedure .. "()",
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

local function write_to_buffers(result)
	-- Get the current buffer number
	-- local bufnr = api.nvim_get_current_buf()
	local bufnr = api.nvim_create_buf(true, false)
	api.nvim_set_current_buf(bufnr)

	-- Insert the input at the current cursor position
	api.nvim_buf_set_lines(bufnr, 0, 0, false, script_template(result))
	-- api.nvim_buf_set_name(bufnr, result.script_name .. ".sql")

	local test_file_root = utils.find_root()

	if test_file_root == nil then
		api.nvim_buf_set_name(bufnr, result.script_name .. ".sql")
		print(test_file_root)
	else
		local database_script_path = "\\DatabaseScripts\\Standard\\800\\"
		api.nvim_buf_set_name(bufnr, test_file_root .. database_script_path .. result.script_name .. ".sql")
	end

	api.nvim_buf_set_option(bufnr, "filetype", "sql")

	-- create the new buffer and put the procedure template in there
	local proc_buffer = api.nvim_create_buf(true, false)
	api.nvim_set_current_buf(proc_buffer)
	bufnr = api.nvim_get_current_buf()
	api.nvim_buf_set_lines(bufnr, 0, 0, false, proc_template(result.procedure))
	--api.nvim_buf_set_name(bufnr, result.procedure .. ".sql")

	if test_file_root == nil then
		api.nvim_buf_set_name(bufnr, result.procedure .. ".sql")
		print(test_file_root)
	else
		local database_script_path = "\\DatabaseScripts\\Standard\\800StoredProcedures\\"
		api.nvim_buf_set_name(bufnr, test_file_root .. database_script_path .. result.procedure .. ".sql")
	end

	api.nvim_buf_set_option(bufnr, "filetype", "sql")

	local new_pos = { 7, 0 }
	local win = api.nvim_get_current_win()
	api.nvim_win_set_cursor(win, new_pos)
end

function M.prompt_for_input()
	local result = prompt_for_data()
	if result == nil then
		return
	else
		write_to_buffers(result)
	end
end

return M
