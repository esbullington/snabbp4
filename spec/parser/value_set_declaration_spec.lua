local utils = require"snabbp4.syntax.utils.debug"

insulate("Value set declaration", function()
	local parser = require("snabbp4.syntax.parser")
	local config = {preprocess = true}
	local input = [[
		parser_value_set avar;
	]]
	local statements = parser.parse(input, config)
	it("should correctly parser value set declaration node", function()
		local node = statements[1].node
		assert.is_equal(node, "value_set_declaration")
	end)
end)
