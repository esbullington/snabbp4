local utils = require"snabbp4.syntax.utils"

insulate("Parser declaration ('parser' keyword)", function()
	local parser = require("snabbp4.syntax.parser")
	local config = {preprocess = true}
	local input = [[
		// Start with ethernet always.
		parser start {
			return ethernet;
		}
		parser ethernet {
			extract(ethernet); // Start with the ethernet header
			return select(latest.ethertype) {
				0x8100: vlan;
				0x800: ipv4;
				default: ingress;
			}
		}
	]]
	local statements = parser.parse(input, config)
	it("should correctly identify number of statements", function()
		local n = #statements
		assert.is_equal(n, 2)
	end)
	it("should correctly parse 'start' parser declaration", function()
		local start_parser = statements[1]
		assert.is_equal(start_parser.node, "parser_function_declaration")
		assert.is_equal(start_parser.node_identifier, "start")
		assert.is_equal(start_parser.statements[1].node, "return_statement")
		assert.is_equal(start_parser.statements[1].node_identifier, "ethernet")
	end)
	it("should correctly parse 'ethernet' parser declaration", function()
		local ethernet_parser = statements[2]
		assert.is_equal(ethernet_parser.node, "parser_function_declaration")
		assert.is_equal(ethernet_parser.node_identifier, "ethernet")
	end)
	it("should correctly parse 'extract' function call", function()
		local extract_statement = statements[2].statements[1]
		assert.is_equal(extract_statement.node, "extract_statement")
	end)
	it("should correctly parse select statement and value list", function()
		local select_statement  = statements[2].statements[2]
		local value_list = select_statement.statement.statements
		assert.is_equal(select_statement.node, "return_statement")
		assert.is_equal(#value_list, 3)
	end)
end)

insulate("Parser exception declaration ('parser' keyword)", function()
	local parser = require("snabbp4.syntax.parser")
	local config = {preprocess = true}
	local input = [[
		parser_exception some_exception {
			// Just some example statement, not a real p4 script
			set_metadata(flow.eth_src, l2_eth.eth_src);
			return main;
		}
		parser_exception another_exception {
			parser_drop;
		}
	]]
	local statements = parser.parse(input, config)
	it("should correctly parse parser exception declarations", function()
		local some_exception = statements[1]
		local another_exception = statements[2]
		assert.is_equal(some_exception.node, "parser_exception_declaration")
		assert.is_equal(some_exception.node_identifier, "some_exception")
	end)
end)
