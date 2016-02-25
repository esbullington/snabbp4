
insulate("Calculated field declaration", function()
	local parser = require("snabbp4.syntax.parser")
	local config = {preprocess = true}
	local input = [[
		calculated_field tcp.chksum {
			update tcpv4_calc if (valid(ipv4));
			update tcpv6_calc if (valid(ipv6));
			verify tcpv4_calc if (valid(ipv4));
			verify tcpv6_calc if (valid(ipv6));
		}
	]]
	local statements = parser.parse(input, config)
	it("should correctly calculated field declaration node", function()
		local node = statements[1].node
		assert.is_equal(node, "calculated_field_declaration")
	end)
	it("should correctly count number of update/verify statements", function()
		local stmts = statements[1].statements
		assert.is_equal(#stmts, 4)
	end)
	it("should correctly parse update/verify statements", function()
		local update_one = statements[1].statements[1]
		assert.is_equal(update_one.field_list_calculation_name, "tcpv4_calc")
		assert.is_equal(update_one.if_cond.calc_bool_cond.node, "valid")
		assert.is_equal(update_one.if_cond.calc_bool_cond.param.value, "ipv4")
	end)
end)
