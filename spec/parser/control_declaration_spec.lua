
insulate("Control function declaration", function()
	local parser = require("snabbp4.syntax.parser")
	local config = {preprocess = true}
	local input = [[
		control egress {
			// Check for unknown egress state or bad retagging with mTag.
			apply(egress_check);
			apply(egress_meter) {
				hit {
					apply(hysteresis_check);
					apply(meter_policy);
				}
			}
		}
	]]
	local statements = parser.parse(input, config)
	local control_function = statements[1]
	it("should parse control function declaration node", function()
		local node = control_function.node
		assert.is_equal(node, "control_function_declaration")
	end)
end)
