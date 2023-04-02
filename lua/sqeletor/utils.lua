local M = {}

function M.find_root()
	-- RICHARD WAS HERE
	-- vim.fn.findfile doesn't seem to want to play with *.sln, but seems happy with AIS8.sln
	-- write a utility function that will take in a table of filenames and test each one and report
	-- back if any are found, along with the directory name
	-- create a setup() function for the plugin, that takes on opt and allows the user to create a table
	-- of filenames to search for (optional)

	-- Define the file name or pattern you are searching for
	local filename_pattern = "AIS8.sln"

	-- Get the root directory of the current project
	local current_dir = vim.fn.getcwd()

	while current_dir ~= "" do
		-- Use findfile() to search for the file in the root directory
		local found_file = vim.fn.findfile(filename_pattern, current_dir)

		if found_file ~= "" then
			return current_dir
		end

		-- Move up to the parent directory
		current_dir = vim.fn.fnamemodify(current_dir, ":h")

		-- TODO: either use the WinApi to check "if root", or test whether "current_dir" stayed the same (meaning we are at the root)
		if current_dir == "C:\\" then
			return
		end
	end
end

return M
