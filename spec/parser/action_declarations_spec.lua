
insulate("Action declaration", function()
	local parser = require("snabbp4.syntax.parser")
	local config = {preprocess = true}
	local input = [[
		////////////////////////////////////////////////////////////////
		// Actions used by tables
		////////////////////////////////////////////////////////////////
		// Copy the packet to the CPU;
		action common_copy_pkt_to_cpu(in bit<8> cpu_code, in bit bad_packet) {
			modify_field(local_metadata.copy_to_cpu, 1);
			modify_field(local_metadata.cpu_code, cpu_code);
			modify_field(local_metadata.bad_packet, bad_packet);
		}
	]]
	local statements = parser.parse(input, config)
	it("should correctly parse action node", function()
		local node = statements[1].node
		assert.is_equal(node, "action_function_declaration")
	end)
	it("should correctly parse action parameters", function()
		local params = statements[1].params
		assert.is_equal(2, #params)
		assert.is_equal(params[1].node_value.node_type.length, "8")
	end)
end)

insulate("Action profile declaration", function()
	local parser = require("snabbp4.syntax.parser")
	local config = {preprocess = true}
	local input = [[
		action_profile some_action_profile_name {
			actions {
				action_one;
				action_two;
			}
			size: 5;
			dynamic_action_selection: some_name;
		}
	]]
	local statements = parser.parse(input, config)
	it("should correctly parse action node", function()
		local node = statements[1].node
		assert.is_equal(node, "action_profile_declaration")
	end)
end)
