local proc = require("sqeletor.sqeletor-proc")
local script = require("sqeletor.sqeletor-script")
local M = {}

M.new_script = script.prompt_for_input
M.new_procedure = proc.prompt_for_input

return M
