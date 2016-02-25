
insulate("Counter declaration", function()
	local parser = require("snabbp4.syntax.parser")
	local config = {preprocess = true}
	local input = [[
		// Count packets and bytes by mtag instance added
		counter pkts_by_dest {
			type : packets;
			direct : mTag_table;
		}
	]]
	local statements = parser.parse(input, config)
	it("should parse counter declaration node", function()
		local node = statements[1].node
		assert.is_equal(node, "counter_declaration")
	end)
end)
