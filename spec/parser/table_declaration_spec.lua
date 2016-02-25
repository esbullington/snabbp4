

insulate("Table declaration", function()
	local parser = require("snabbp4.syntax.parser")
	local config = {preprocess = true}
	local input = [[
		table ipv4_routing {
			action_profile : ecmp_action_profile;
			size : 16384; // 16K possible IPv4 prefixes
			reads {
				ipv4.dstAddr: lpm;
			}
		}
	]]
	local statements = parser.parse(input, config)
	local table = statements[1]
	it("should parse table declaration node", function()
		local node = table.node
		assert.is_equal(node, "table_declaration")
	end)
end)

insulate("Table 2 declaration", function()
	local parser = require("snabbp4.syntax.parser")
	local config = {preprocess = true}
	local input = [[
		table hysteresis_check {
			reads {
				local_metadata.color : exact;
				local_metadata.prev_color : exact;
			}
			actions {
				update_prev_color;
				mark_pkt;
				no_op;
			}
			size : 4;
		}
	]]
	local statements = parser.parse(input, config)
	local table = statements[1]
	it("should parse table declaration node", function()
		local node = table.node
		assert.is_equal(node, "table_declaration")
	end)
end)
