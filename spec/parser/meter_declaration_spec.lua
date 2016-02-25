
insulate("Meter declaration", function()
	local parser = require("snabbp4.syntax.parser")
	local config = {preprocess = true}
	local input = [[
		meter customer_meters {
			type : bytes;
			instance_count : 1000;
		}
	]]
	local statements = parser.parse(input, config)
	it("should parse meter declaration node", function()
		local node = statements[1].node
		assert.is_equal(node, "meter_declaration")
	end)
end)
