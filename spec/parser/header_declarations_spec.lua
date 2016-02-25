
insulate("Header type declaration", function()
	local parser = require("snabbp4.syntax.parser")
	local config = {preprocess = true}
	local input = [[
		// Standard IPv4 header
		header_type ipv4_t {
			fields {
				bit<4> version;
				bit<4> ihl;
				bit<32> dstAddr;
				// snip
				varbit<320> options;
			}
			length : ihl * 4;
		}
	]]
	local statements = parser.parse(input, config)
	it("should correctly parse header type node", function()
		local node = statements[1].node
		assert.is_equal(node, "header_type")
	end)
	it("should correctly parse header type node identifier", function()
		local id = statements[1].node_identifier.value
		assert.is_equal(id, "ipv4_t")
	end)
	it("should correctly provide number of sub-statements", function()
		local stmts = statements[1].statements
		assert.is_equal(#stmts, 2)
	end)
	it("should correctly provide node name of first sub-statement", function()
		local node = statements[1].statements[1].node
		assert.is_equal(node, "field_declaration")
	end)
end)

insulate("Header instance declaration", function()
	local parser = require("snabbp4.syntax.parser")
	local config = {preprocess = true}
	local input = [[
		// Header instance declaration
		header ipv4_t ipv4;
	]]
	local statements = parser.parse(input, config)
	it("should correctly parse header instance node", function()
		local node = statements[1].node
		assert.is_equal(node, "header_instance")
	end)
	it("should correctly parse header instance node", function()
		local e = statements[1].expression
		assert.is_equal(e.node_identifier, "ipv4")
		assert.is_equal(e.node_type, "ipv4_t")
	end)
end)

