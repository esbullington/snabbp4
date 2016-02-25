
insulate("Register declaration", function()
	local parser = require("snabbp4.syntax.parser")
	local config = {preprocess = true}
	local input = [[
		// The register stores the "previous" state of the color.
		// Index is the same as that used by the meter.
		register prev_color {
			width : 8;
			// paired w/ meters above
			instance_count : PORT_COUNT * PORT_COUNT;
		}
	]]
	local statements = parser.parse(input, config)
	local register = statements[1]
	it("should parse register declaration node", function()
		local node = register.node
		assert.is_equal(node, "register_declaration")
	end)
	it("should count number of nested statements", function()
		assert.is_equal(#register.statements, 2)
	end)
	it("should parse width declaration", function()
		local width_declaration = register.statements[1]
		assert.is_equal(width_declaration.node, "width_declaration")
	end)
	it("should parse instance count statement", function()
		local instance_count = register.statements[2]
		assert.is_equal(instance_count.node, "instance_count")
	end)
end)
