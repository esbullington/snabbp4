local utils = require("snabbp4.syntax.utils.debug")

insulate("Field list declaration", function()
	local parser = require("snabbp4.syntax.parser")
	local config = {preprocess = true}
	local input = [[
		// list of fields used to determine the ECMP next hop
		field_list l3_hash_fields {
			ipv4.srcAddr;
			ipv4.dstAddr;
			ipv4.protocol;
			ipv4.protocol;
			tcp.sport;
			tcp.dport;
		}
	]]
	local statements = parser.parse(input, config)
	it("should correctly parse field list node", function()
		local node = statements[1].node
		assert.is_equal(node, "field_list_declaration")
	end)
	it("should correctly count field list statements", function()
		local field_list_statements = statements[1].statements
		assert.is_equal(#field_list_statements, 6)
	end)
	it("should correctly parse an accessor", function()
		local ipv4_src_addr = statements[1].statements[1]
		assert.is_equal(ipv4_src_addr.left.value, "ipv4")
		assert.is_equal(ipv4_src_addr.right.value, "srcAddr")
	end)
end)

insulate("Field list calculation", function()
	local parser = require("snabbp4.syntax.parser")
	local config = {preprocess = true}
	local input = [[
		field_list_calculation ecmp_hash {
			input {
				l3_hash_fields;
			}
			algorithm : crc16;
			output_width : 16;
		}
	]]
	local statements = parser.parse(input, config)
	it("should correctly parse header instance node", function()
		local node = statements[1].node
		assert.is_equal(node, "field_list_calculation_declaration")
	end)
end)
