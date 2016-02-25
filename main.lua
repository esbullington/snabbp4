local utils = require("snabbp4.syntax.utils.debug")
local parser = require("snabbp4.syntax.parser")
local symbols = require("snabbp4.syntax.symbols")

-- frontend
local filename = arg[1]
local fh = assert(io.open(filename))
local input = fh:read'*a'
local config = {preprocess=true}
local result = parser.parse(input, config)
utils.print_r(result)

fh:close()
